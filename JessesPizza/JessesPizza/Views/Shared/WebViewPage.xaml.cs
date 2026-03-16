using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity.Guest;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Helpers;
using JessesPizza.Models;
using Microsoft.AspNetCore.SignalR.Client;
using SQLite;
using Telerik.XamarinForms.Primitives;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class WebViewPage : ContentPage
    {
        private HubConnection _hubConnection;
        MainPage RootPage { get => Application.Current.MainPage as MainPage; }
        MongoTransactionV1_1 _transaction;
        public bool PageCanceled { get; set; } = true;
        public bool CardDeclined { get; set; } = false;

        public WebViewPage(MongoTransactionV1_1 transaction)
        {
            InitializeComponent();
            _transaction = transaction;
            webView.Source = _transaction.HPPToken;
        }

        protected override async void OnAppearing()
        {
            base.OnAppearing();
            await Connect();
        }
        protected override async void OnDisappearing() 
        {
            _hubConnection.Closed -= HubDisconnected;
            await _hubConnection.DisposeAsync();
            base.OnDisappearing();

        }
        public WebViewPage()
        {
            InitializeComponent();
        }
        async Task Connect()
        {
            try
            {
                _hubConnection = new HubConnectionBuilder().WithUrl($"{Constants.BaseAddress}/chatHub").Build();
                _hubConnection.Closed += HubDisconnected;
                _hubConnection.On<string, string>("HPPCancel", async (transactionGuid, message) =>
                {
                     if (_transaction.TransactionGuid.ToString() == transactionGuid)
                    {
                        if(PageCanceled)
                        {
                            PageCanceled = false;
                        Device.BeginInvokeOnMainThread(async () => await Navigation.PopAsync());
                        
                        }
                    }
                });
                _hubConnection.On<string, string>("HPPFailed",async (transactionGuid, message) =>
                {
                    if (_transaction.TransactionGuid.ToString() == transactionGuid)
                    {
                        if (PageCanceled)
                        {
                            PageCanceled = false;

                            Device.BeginInvokeOnMainThread(async () => { await Navigation.PopAsync(); PopupHelper.CreatePopup("Failed to process transaction", "Something went wrong processing your transaction, your card may have been charged"); }); 

                        }
                    }
                });
                _hubConnection.On<string, HPPApprovalMessage>("HPPApprove", async (transactionGuid, message) =>
                {
                    if (_transaction.TransactionGuid.ToString() == transactionGuid)
                    {
                        try
                        {
                            var db = new SQLiteConnection(Constants.SqlLiteDbFolder);
                            db.DeleteAll<OrderTotals>();
                            db.DeleteAll<ShoppingCartItem>();
                            if (message.IsGuest)
                            {
                                db.CreateTable<GuestTransaction>();
                                db.Insert(new GuestTransaction() { TransactionId = message.TransactionGuid });
                                DisplayOrderSubmittedPage();
                            }
                            else
                            {
                                if (!message.IsCardSaved) //Card not saved for user
                                { 
                                     await DisplayCreditCardSavePage(message.Card);
                                    return;
                                }
                                else
                                    DisplayOrderSubmittedPage(); //Card already saved
                            }

                        }
                        catch
                        {
                            await Navigation.PopToRootAsync();
                            await RootPage.NavigateFromMenu((int)MenuItemType.Orders);
                            PopupHelper.CreatePopup("Uh-oh!", "Something went wrong");
                        }

                    }
                });
                _hubConnection.On<string, string>("HPPDecline", async (transactionGuid, message) =>
                {
                    Device.BeginInvokeOnMainThread(async () =>
                    {
                        if (_transaction.TransactionGuid.ToString() == transactionGuid)
                        {
                            if (!CardDeclined)
                            {
                                CardDeclined = true;
                                await Navigation.PopAsync(false);
                                PopupHelper.CreatePopup("Uh-oh!", "Card was declined");

                            }
                        }
                    });
                });
                //_hubConnection.On<string, string>("HPPFailed", async (transactionGuid, message) =>
                //{
                //    Device.BeginInvokeOnMainThread(async () =>
                //    {
                //        if (_transaction.TransactionGuid.ToString() == transactionGuid)
                //        {
                //                await Navigation.PopAsync(false);
                //                PopupHelper.CreatePopup("Uh-oh!", $"Failed to process transaction");
                //        }
                //    });
                //});
                await _hubConnection.StartAsync();
            }
            catch (Exception ex)
            {
                await Navigation.PopAsync(false);
                PopupHelper.CreatePopup("Uh-oh!", "Something went wrong");
            }
        }
        private Task HubDisconnected(Exception arg)
        {
            return Task.Run(() =>
            {
                Device.BeginInvokeOnMainThread(async () => { await Navigation.PopAsync(); });
            });
        }
        private async void DisplayOrderSubmittedPage()
        {

            await Navigation.PopToRootAsync();
            await RootPage.NavigateFromMenu((int)MenuItemType.Orders);
            PopupHelper.CreatePopup("Success!", "Order is fully complete");

        }
        private async Task DisplayCreditCardSavePage(CreditCard card)
        {

            await Navigation.PushAsync(new CreditCardSavePage(card));

        }
        private async Task DisplayOrderFailedPage()
        {
            await Navigation.PopAsync(false);
            PopupHelper.CreatePopup("Uh-oh!", "Card was declined");
            //var navigation = Navigation.NavigationStack;
            //var lastPage = navigation.LastOrDefault();
            //while (lastPage.GetType() != typeof(CreditCardListPage) | lastPage.GetType() != typeof(GuestInfoPage) | lastPage.GetType() != typeof(DeliveryOrPickupPage) | lastPage.GetType() != typeof(AddressListPage))
            //{
            //    await Navigation.PopAsync();
            //    navigation = Navigation.NavigationStack;
            //    lastPage = navigation.LastOrDefault();
            //}

        }
        void webviewNavigating(object sender, WebNavigatingEventArgs e)
        {
            activityIndicator.IsVisible = true;
            activityIndicator.IsRunning = true;
        }

        void webviewNavigated(object sender, WebNavigatedEventArgs e)
        {
            activityIndicator.IsVisible = false;
            activityIndicator.IsRunning = false;
        }
    }
}