using Acr.UserDialogs;
using JessesPizza.Converters;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Helpers;
using JessesPizza.Models;
using JessesPizza.ViewModels;
using JessesPizza.Views.AccountPages;
using SQLite;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CreditCardListPage : ContentPage
    {
        ICommand tapCommand;
        public ICommand TapCommand
        {
            get { return tapCommand; }
        }
        MainPage RootPage { get => Application.Current.MainPage as MainPage; }
        public SqliteTransaction _sqliteTransaction { get; set; }
        private SQLiteConnection _db { get; set; }
        public CreditCardListViewModel _viewModel { get; set; }
        public bool IsDelivery { get; set; }
        public bool NewCardButtonClicked { get; set; } = false;
        public bool NoContact { get; }


        public CreditCardListPage(List<CreditCard> cards, bool isDelivery,bool noContact)
        {
            try
            {
                IsDelivery = isDelivery;
                NoContact = noContact;
                _db = new SQLiteConnection(Constants.SqlLiteDbFolder);
                _sqliteTransaction = (from i in _db.Table<SqliteTransaction>()
                                      select i).ToList().FirstOrDefault();
                InitializeComponent();
                tapCommand = new Command(OnTapped);

                _viewModel = new CreditCardListViewModel(cards);

                var creditCardListStackLayout = new StackLayout();
                foreach (var vm in _viewModel.CreditCards)
                {
                    var view = new CreditCardDisplayView(vm);
                    var stack = new StackLayout() { Children = { view } };
                    stack.GestureRecognizers.Add(new TapGestureRecognizer() { Command = tapCommand, CommandParameter = vm.Id });
                    creditCardListStackLayout.Children.Add(stack);
                }
                CardView.Content = creditCardListStackLayout;
            }
            catch (Exception e)
            {

            }
        }

        private async void OnTapped(object s)
        {
            if (IsBusy)
                return;
            try
            {
                var vm = _viewModel.CreditCards.FirstOrDefault(x => x.Id == (Guid)s);
                if (vm == null)
                    return;
                IsBusy = true;

                string action = await DisplayActionSheet($"Card ending with {vm.CardNumber.Substring(Math.Max(0, vm.CardNumber.Length - 4))}", "Cancel", null, "Use this card", "Delete card");
                    if (action == "Use this card")
                    {
                        var items = from i in _db.Table<ShoppingCartItem>()
                                    select i;
                        var orderTotal = (from o in _db.Table<OrderTotals>() select o).FirstOrDefault();
                        if (orderTotal == null)
                        {
                            PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
                            IsBusy = false;
                            return;
                        }
                        GetAccountInfoResponse response = await App.MenuManager.GetAccountInfo();
                        if (response.Succeeded) //reload and add back to view
                        {
                        var info = new CustomerInfoApp()
                        {
                            AddressLine1 = _sqliteTransaction.Address1,
                            City = _sqliteTransaction.City,
                            EmailAddress = response.Info.EmailAddress,
                            FirstName = response.Info.FirstName,
                            LastName = response.Info.LastName,
                            PhoneNumber = response.Info.PhoneNumber,
                            ZipCode = response.Info.ZipCode
                        };
                        var localTransaction = new LocalTransactionV1_1(_sqliteTransaction, items.ToList(), orderTotal, info) { IsDelivery = IsDelivery,NoContactDelivery = NoContact };
                            var card = new CreditCard()
                            {
                                CardNumber = vm.CardNumber,
                                ExpirationDate = vm.CardExpirationDate,
                                ShortDescription = vm.CardDescription,
                                Id = vm.Id
                            };

                            await Navigation.PushAsync(new ReviewOrderPage(localTransaction, card));
                        }
                        else
                        {
                            PopupHelper.CreatePopup("Uh-oh!", $"{response.Message}");
                            IsBusy = false;

                    }
                }
                    else if (action == "Delete card")
                    {
                        string deleteAction = await DisplayActionSheet($"Are you sure you want to delete card ending with {vm.CardNumber.Substring(Math.Max(0, vm.CardNumber.Length - 4))}?", "Cancel", null, "Yes", "No");
                        if (deleteAction == "Yes")
                        {
                            var request = new DeleteCreditCardRequest() { CreditCardId = vm.Id };
                            DeleteCreditCardResponse response = await App.MenuManager.DeleteCreditCard(request);
                            if (response.Succeeded) //reload and add back to view
                            {
                                PopupHelper.CreatePopup("Successfully removed card", "");
                                await _viewModel.ExecuteLoadItemsCommand();
                                var creditCardListStackLayout = new StackLayout();
                                if (_viewModel.CreditCards == null | _viewModel.CreditCards.Count == 0)
                                    EmptyLabel.IsVisible = true;
                                foreach (var ccViewModel in _viewModel.CreditCards)
                                {
                                    var view = new CreditCardDisplayView(ccViewModel);
                                    var stack = new StackLayout() { Children = { view } };
                                    stack.GestureRecognizers.Add(new TapGestureRecognizer() { Command = tapCommand, CommandParameter = ccViewModel.Id });
                                    creditCardListStackLayout.Children.Add(stack);
                                }
                                CardView.Content = creditCardListStackLayout;
                                IsBusy = false;
                            }
                        else
                            {
                                PopupHelper.CreatePopup("Uh-oh!", $"{response.Message}");
                                IsBusy = false;
                            }
                    }
                        else
                        {
                            IsBusy = false;
                            return;
                        }
                }
                UserDialogs.Instance.HideLoading();

            }
            catch (Exception e)
            {
                PopupHelper.CreatePopup("Uh-oh!", $"Unable to process transaction");
                UserDialogs.Instance.HideLoading();
                IsBusy = false;

            }
        }
        private async void DisplayOrderSubmittedPage()
        {

            await Navigation.PopToRootAsync();
            await RootPage.NavigateFromMenu((int)MenuItemType.Orders);
            PopupHelper.CreatePopup("Success!", "Order is fully complete");

        }
        private async void ToolbarItem_Clicked(object sender, EventArgs e)
        {
            try
            {
                if (NewCardButtonClicked)
                    return;
                NewCardButtonClicked = true;
                await PushPaymentPage();
                NewCardButtonClicked = false;
            }
            catch (Exception ex)
            {
                NewCardButtonClicked = false;

            }
        }


        private async Task PushPaymentPage()
        {
            var items = from i in _db.Table<ShoppingCartItem>()
                        select i;
            var orderTotal = (from o in _db.Table<OrderTotals>() select o).FirstOrDefault();
            if (orderTotal == null)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
                return;
            }
            _db.CreateTable<SqliteTransaction>();
            var localTransactions = from i in _db.Table<SqliteTransaction>()
                                    select i;
            var sqliteTransaction = localTransactions.FirstOrDefault();
            var localTransaction = new LocalTransactionV1_1(sqliteTransaction, items.ToList(), orderTotal)
            {
                IsDelivery = IsDelivery,
                NoContactDelivery = NoContact
            };
            var response = await App.MenuManager.ValidateTransaction(localTransaction);
            if (response.Succeeded)
            {
                var sendTransactionResponse = await App.MenuManager.GetHPPToken(localTransaction);
                if (sendTransactionResponse != null)
                {
                    await Navigation.PushAsync(new WebViewPage(sendTransactionResponse), false);
                }
                else
                {
                    PopupHelper.CreatePopup("Uh-oh!", "Unable to process transaction");
                }
            }
            else
            {
                if (response.Message != null || response.Message != string.Empty)
                    PopupHelper.CreatePopup("Uh-oh!", response.Message);
                else
                    PopupHelper.CreatePopup("Uh-oh!", "Unable to process transaction");
            }
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();
            IsBusy = false;
            NewCardButtonClicked = false;
        }
    }
}