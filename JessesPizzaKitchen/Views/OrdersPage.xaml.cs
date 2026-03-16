using System;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using Acr.UserDialogs;
using Flurl.Http;
using JessesPizza.Core.Models;
using JessesPizza.Services;
using JessesPizzaAdmin.ViewModels;
using JessesPizzaKitchen.Models;
using Microsoft.AspNetCore.SignalR.Client;
using SQLite;
using Telerik.XamarinForms.Primitives;
using Xamarin.Essentials;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizzaKitchen.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class OrdersPage : ContentPage
    {
        OrdersViewModel _viewModel;
        private MongoService _service;
        private HubConnection _hubConnection;
        public KDSUserSQL _kdsUser;
        SQLiteConnection _db; 
        static System.Timers.Timer t;


        public OrdersPage()
        {
            InitializeComponent();
            BindingContext = _viewModel = new OrdersViewModel();
            _service = new MongoService();
            // localhost for UWP/iOS or special IP for Android
            Connectivity.ConnectivityChanged += Connectivity_ConnectivityChanged;

            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);

            MessagingCenter.Subscribe<App>(this, "OnResume", app =>
            {
               OnAppearing();
            });

            MessagingCenter.Subscribe<LoginPage>(this, "OnLogin", app =>
            {
                OnAppearing();
            });
             _viewModel.ExecuteLoadDeliveredItemsCommand().Wait();
             _viewModel.ExecuteLoadAuthorizedItemsCommand().Wait();
             _viewModel.ExecuteLoadOutItemsCommand().Wait();
             _viewModel.ExecuteLoadKitchenItemsCommand().Wait(); 
            t = new System.Timers.Timer();
            t.Interval = GetInterval();
            t.Elapsed += t_Elapsed;
            t.Start();
            //var assembly = typeof(App).GetTypeInfo().Assembly;
            //Stream audioStream = assembly.GetManifestResourceStream("JessesPizzaKitchen.sound.mp3");
            //var player = Plugin.SimpleAudioPlayer.CrossSimpleAudioPlayer.Current;
            //player.Load(audioStream);
            //player.Play();
        }
        static double GetInterval()
        {
            DateTime now = DateTime.Now;
            return (60 - now.Second) * 1000 - now.Millisecond;
        }
        private async void t_Elapsed(object sender, System.Timers.ElapsedEventArgs e)
        {
            try { 
            await _viewModel.ExecuteLoadDeliveredItemsCommand();
            await _viewModel.ExecuteLoadAuthorizedItemsCommand();
            await _viewModel.ExecuteLoadOutItemsCommand();
            await _viewModel.ExecuteLoadKitchenItemsCommand();
            t.Interval = GetInterval();
            t.Start();
            }
            catch (Exception ex)
            {
                
            }
        }

        private async void Connectivity_ConnectivityChanged(object sender, ConnectivityChangedEventArgs e)
        {
            var access = e.NetworkAccess;
            if (access == NetworkAccess.None || access == NetworkAccess.Local || access == NetworkAccess.Unknown)
            {
                _viewModel.ConnectedIcon = "Disconnected";
                _viewModel.IconColor = Color.Red;
            }
            else if (_hubConnection.State != HubConnectionState.Connected)
            {
                await Connect();
                if (_hubConnection.State == HubConnectionState.Connected)
                {
                    _viewModel.ConnectedIcon = "Connected";
                    _viewModel.IconColor = Color.LightGreen;
                }
                else
                {
                    _viewModel.ConnectedIcon = "Disconnected";
                    _viewModel.IconColor = Color.Red;
                }
            }
        }

        private async Task Connect()
        {
            try
            {
                if (_hubConnection.State == HubConnectionState.Disconnected)
                    await _hubConnection.StartAsync();
                if (_hubConnection.State == HubConnectionState.Connected)
                {
                    _viewModel.ConnectedIcon = "Connected";
                    _viewModel.IconColor = Color.LightGreen;
                    _viewModel.LoadAuthorizedItemsCommand.Execute(null);
                    _viewModel.LoadKitchenItemsCommand.Execute(null);
                    _viewModel.LoadOutItemsCommand.Execute(null);
                    _viewModel.LoadDeliveredItemsCommand.Execute(null);
                }
                else
                {
                    _viewModel.ConnectedIcon = "Disconnected";
                    _viewModel.IconColor = Color.Red;
                }
            }
            catch (Exception ex)
            {
                _viewModel.ConnectedIcon = "Disconnected";
                _viewModel.IconColor = Color.Red;
            }
        }

        protected override async void OnDisappearing()
        {
            try
            {
                _hubConnection.Closed -= HubDisconnected;
                _hubConnection.Reconnecting -= HubReconnecting;
                _hubConnection.Reconnected -= HubReconnected;
                await _hubConnection.DisposeAsync();
            }
            catch (Exception e)
            {

            }

        }
        protected override async void OnAppearing()
        {
            base.OnAppearing();
            try
            {
                UserDialogs.Instance.ShowLoading();
                _db.CreateTable<KDSUserSQL>();
                var kdsUsers = from f in _db.Table<KDSUserSQL>() select f;
                if (kdsUsers != null)
                {
                    if (kdsUsers.Count() != 0)
                        _kdsUser = kdsUsers.FirstOrDefault();

                }

                if (_kdsUser == null)
                {
                    if (!Navigation.ModalStack.Any())
                        await Navigation.PushModalAsync(new LoginPage());
                }
                else
                {
                    var KDSUser = new JessesPizza.Core.Models.Identity.KDSUser() { Password = _kdsUser.Password, Username = _kdsUser.Username };
                    var blah = await Constants.LoginAddress.PostJsonAsync(KDSUser);
                    if (blah.StatusCode == System.Net.HttpStatusCode.OK)
                    {
                        MessagingCenter.Send(this, "OnLogin");
                        await _viewModel.ExecuteLoadDeliveredItemsCommand();
                        await _viewModel.ExecuteLoadAuthorizedItemsCommand();
                        await _viewModel.ExecuteLoadOutItemsCommand();
                        await _viewModel.ExecuteLoadKitchenItemsCommand();

                        _hubConnection = new HubConnectionBuilder()
                            .WithUrl(Constants.ChatAddress)
                            .WithAutomaticReconnect()
                            .Build();
                        _hubConnection.On<string, string>("ReceiveMessage", (user, message) =>
                        {
                            if (user == "Authorized" || message == "Authorized")
                            {
                                _viewModel.LoadAuthorizedItemsCommand.Execute(null);
                                if (message == "")
                                {
                                    var assembly = typeof(App).GetTypeInfo().Assembly;
                                    Stream audioStream = assembly.GetManifestResourceStream("JessesPizzaKitchen.sound.mp3");
                                    var player = Plugin.SimpleAudioPlayer.CrossSimpleAudioPlayer.Current;
                                    player.Load(audioStream);
                                    player.Play();
                                }
                            }
                            if (user == "InKitchen" || message == "InKitchen")
                                _viewModel.LoadKitchenItemsCommand.Execute(null);
                            if (user == "Out" || message == "Out")
                                _viewModel.LoadOutItemsCommand.Execute(null);
                            if (user == "Delivered" || message == "Delivered")
                                _viewModel.LoadDeliveredItemsCommand.Execute(null);
                        // Update the UI
                    });
                        _hubConnection.Closed += HubDisconnected;
                        _hubConnection.Reconnecting += HubReconnecting;
                        _hubConnection.Reconnected += HubReconnected;

                        await Connect();
                    }
                    else
                    {
                        CreatePopupForInvalidForm("Incorrect username or password");
                    }
                }
                UserDialogs.Instance.HideLoading();
            }
            catch (Exception e)
            {
                UserDialogs.Instance.HideLoading();
            }
        }

        private Task HubReconnected(string arg)
        {
            return Task.Run(() =>
            {
                _viewModel.ConnectedIcon = "Connected";
                _viewModel.IconColor = Color.LightGreen;
            });
        }
        private Task HubReconnecting(Exception arg)
        {
            return Task.Run(() =>
            {
                _viewModel.ConnectedIcon = "Disconnected";
                _viewModel.IconColor = Color.Red;
            });
        }

        private Task HubDisconnected(Exception arg)
        {
            return Task.Run(() =>
            {
                _viewModel.ConnectedIcon = "Disconnected";
                _viewModel.IconColor = Color.Red;
            });
        }
        private async void ShowInstructionsButton_OnClicked(object sender, EventArgs e)
        {
            try
            {
                var button = sender as Button;
                var paymentParent = button.CommandParameter as PaymentParent;
                var result = await UserDialogs.Instance.ConfirmAsync(new ConfirmConfig
                {
                    Message = paymentParent.SpecialInstructions,
                    OkText = "Ok",
                    CancelText = "Cancel"
                });
            }
            catch (Exception exception)
            {
                CreatePopupForInvalidForm(exception.Message);
            }
        }
        private async void AuthorizedButton_OnClicked(object sender, EventArgs e)
        {
            try
            {
                var button = sender as Button;
                var guidString = button.CommandParameter.ToString();
                var Guid = new Guid(guidString);
                var payment = _viewModel.AuthorizedPaymentsGrouped.First(item =>item.Key.TransactionGuid == Guid);
                if (payment == null) return;
                var state = await _service.UpdateTransactionState(TransactionState.InKitchen, Guid,payment.Key.Version);
                if (!state)
                    throw new Exception("Unable to change transaction state");

                _viewModel.AuthorizedPaymentsGrouped.Remove(payment);
                _viewModel.KitchenPaymentsGrouped.Add(payment);
                await _hubConnection.InvokeAsync("SendMessage", "Authorized", "InKitchen");

            }
            catch (Exception exception)
            {
                CreatePopupForInvalidForm(exception.Message);
            }
        }

        private async void KitchenButton_OnClicked(object sender, EventArgs e)
        {
            try
            {
                var button = sender as Button;
                var guidString = button.CommandParameter.ToString();
                var Guid = new Guid(guidString);
                var payment = _viewModel.KitchenPaymentsGrouped.First(item =>
                    item.Key.TransactionGuid == Guid);
                if (payment == null) return;
                var state = await _service.UpdateTransactionState(TransactionState.OutForDelivery, Guid,payment.Key.Version);
                if (!state)
                    throw new Exception();

                _viewModel.KitchenPaymentsGrouped.Remove(payment);
                _viewModel.OutPaymentsGrouped.Add(payment);
                await _hubConnection.InvokeAsync("SendMessage", "InKitchen", "Out");

            }
            catch (Exception exception)
            {
                CreatePopupForInvalidForm("Unable to change transaction state");
            }
        }

        private async void KitchenBackButton_OnClicked(object sender, EventArgs e)
        {
            try
            {
                var button = sender as Button;
                var guidString = button.CommandParameter.ToString();
                var Guid = new Guid(guidString);
                var payment = _viewModel.KitchenPaymentsGrouped.First(item =>
                item.Key.TransactionGuid == Guid);
                if (payment == null) return;
                var state = await _service.UpdateTransactionState(TransactionState.Authorized, Guid,payment.Key.Version);
                if (!state)
                    throw new Exception();
                _viewModel.KitchenPaymentsGrouped.Remove(payment);
                _viewModel.AuthorizedPaymentsGrouped.Add(payment);
                await _hubConnection.InvokeAsync("SendMessage", "InKitchen", "Authorized");

            }
            catch (Exception exception)
            {
                CreatePopupForInvalidForm("Unable to change transaction state");
            }
        }

        private async void OutBackButton_OnClicked(object sender, EventArgs e)
        {
            try
            {
                var button = sender as Button;
                var guidString = button.CommandParameter.ToString();
                var Guid = new Guid(guidString);
                var payment = _viewModel.OutPaymentsGrouped.First(item =>
                item.Key.TransactionGuid == Guid);
                if (payment == null) return;
                var state = await _service.UpdateTransactionState(TransactionState.InKitchen, Guid,payment.Key.Version);
                if (!state)
                    throw new Exception();
                _viewModel.OutPaymentsGrouped.Remove(payment);
                _viewModel.KitchenPaymentsGrouped.Add(payment);
                await _hubConnection.InvokeAsync("SendMessage", "Out", "InKitchen");
            }
            catch (Exception exception)
            {
                CreatePopupForInvalidForm("Unable to change transaction state");
            }
        }

        private async void OutButton_OnClicked(object sender, EventArgs e)
        {
            try
            {
                var button = sender as Button;
                var guidString = button.CommandParameter.ToString();
                var Guid = new Guid(guidString);
                var payment = _viewModel.OutPaymentsGrouped.First(item =>
                    item.Key.TransactionGuid == Guid);
                if (payment == null) return;
                var state = await _service.UpdateTransactionState(TransactionState.Delivered, Guid,payment.Key.Version);
                if (!state)
                    throw new Exception();

                _viewModel.OutPaymentsGrouped.Remove(payment);
                _viewModel.DeliveredPaymentsGrouped.Add(payment);
                await _hubConnection.InvokeAsync("SendMessage", "Out", "Delivered");
            }
            catch (Exception exception)
            {
                CreatePopupForInvalidForm("Unable to change transaction state");
            }
        }
        private void DeliveredButton_OnClicked(object sender, EventArgs e)
        {
            try
            {
                var button = sender as Button;
                var guidString = button.CommandParameter.ToString();
                var Guid = new Guid(guidString);
                var payment = _viewModel.OutPaymentsGrouped.First(item =>
                    item.Key.TransactionGuid == Guid);
                if (payment == null) return;
                _viewModel.OutPaymentsGrouped.Remove(payment);
                _viewModel.AuthorizedPaymentsGrouped.Add(payment);

            }
            catch (Exception exception)
            {
                CreatePopupForInvalidForm("Unable to change transaction state");
            }
        }

        private async void DeliveredBackButton_OnClicked(object sender, EventArgs e)
        {
            try
            {
                var button = sender as Button;
                var guidString = button.CommandParameter.ToString();
                var Guid = new Guid(guidString);
                var payment = _viewModel.DeliveredPaymentsGrouped.First(item =>
                    item.Key.TransactionGuid == Guid);
                if (payment == null) return;
                var state = await _service.UpdateTransactionState(TransactionState.OutForDelivery, Guid,payment.Key.Version);
                if (!state)
                    throw new Exception();

                _viewModel.DeliveredPaymentsGrouped.Remove(payment);
                _viewModel.OutPaymentsGrouped.Add(payment);
                await _hubConnection.InvokeAsync("SendMessage", "Delivered", "Out");

            }
            catch (Exception exception)
            {
                CreatePopupForInvalidForm("Unable to change transaction state");
            }
        }


        private void CreatePopupForInvalidForm(string text)
        {
            var validationPopup = new RadPopup { IsModal = true, OutsideBackgroundColor = Color.FromHex("#6F000000") };
            var containerGrid = new Grid { Padding = 20 };
            containerGrid.RowDefinitions.Add(new RowDefinition { Height = new GridLength(30) });
            containerGrid.RowDefinitions.Add(new RowDefinition { Height = new GridLength(20) });
            containerGrid.Children.Add(new Label { Text = text });

            var hidePopupBtn = new Button { Padding = new Thickness(2), HorizontalOptions = LayoutOptions.Center, Text = "Return to Form" };
            hidePopupBtn.SetValue(Grid.RowProperty, 2);
            hidePopupBtn.Clicked += delegate (object sender, EventArgs args) { validationPopup.IsOpen = false; };
            containerGrid.Children.Add(hidePopupBtn);
            var border = new RadBorder { CornerRadius = new Thickness(8), BackgroundColor = Color.Wheat };
            border.Content = containerGrid;
            validationPopup.Content = border;
            validationPopup.IsOpen = true;
            validationPopup.Placement = PlacementMode.Center;
        }
        private async void TapGestureRecognizer_Tapped(object sender, EventArgs e)
        {
            try
            {
                if (_hubConnection.State == HubConnectionState.Disconnected)
                {
                    await Connect();

                }
            }
            catch (Exception ex)
            {

            }
        }

        private async void UpdateDeliveryTimeClicked(object sender, EventArgs e)
        {
            try
            {
                var button = sender as Button;
                var paymentParent = button.CommandParameter as PaymentParent;
                var dpc = new TimePromptConfig();
                dpc.OkText = "Ok";
                dpc.CancelText = "Cancel";
                dpc.IsCancellable = true;
                if(paymentParent.IsDelivery || paymentParent.NoContact)
                    dpc.Title = "Set the approximate delivery time ";
                else
                    dpc.Title = "Set the approximate pickup time ";
                var result = await UserDialogs.Instance.TimePromptAsync(dpc);
                if(result.Ok)    
                    await ProcessTime(result, paymentParent);

            }
            catch (Exception exception)
            {
                CreatePopupForInvalidForm("Unable to change transaction state");
            }
        }
        private async Task ProcessTime(TimePromptResult result,PaymentParent paymentParent)
        {
            var dateTime = new DateTime(result.SelectedTime.Ticks);
            string message;
            if (paymentParent.IsDelivery || paymentParent.NoContact)
                message = $"Your order from Jesse's Pizza will be delivered at approximately {dateTime.ToString("h:mm tt")}";
            else
                message = $"Your order from Jesse's Pizza will be available for pickup at approximately {dateTime.ToString("h:mm tt")}";
            var request = new JessesPizza.Core.Models.Identity.UpdateDeliveryTimeRequest() { FirstName = paymentParent.Name, IsDelivery = paymentParent.IsDelivery, Message = message, PhoneNumber = paymentParent.PhoneNumber };
            var response = await _service.UpdateDeliveryTime(request);
            if (response.Succeeded)
            {
                UserDialogs.Instance.Toast("Successfully sent text message update");
                return;
            }
            else
                CreatePopupForInvalidForm("Unable to send message");
        }

    }
}