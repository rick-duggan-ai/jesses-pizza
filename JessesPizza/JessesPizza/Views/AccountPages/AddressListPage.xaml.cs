using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Helpers;
using JessesPizza.Models;
using JessesPizza.ViewModels;
using SQLite;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Telerik.XamarinForms.DataControls;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class AddressListPage : ContentPage
    {
        AddressListViewModel _viewModel;
        private SQLiteConnection _db;
        private  bool NoContact;

        public bool IsDelivery { get; }

        public AddressListPage(List<Address> addresses)
        {
            InitializeComponent();
            BindingContext = _viewModel = new AddressListViewModel(addresses);
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);
            _viewModel.Title="Manage delivery addresses";

        }
        public AddressListPage(bool isDelivery, bool noContact)
        {
            InitializeComponent();
            BindingContext = _viewModel = new AddressListViewModel();
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);
            IsDelivery = isDelivery;
            this.NoContact = noContact;
        }
        protected override void OnAppearing()
        {
            base.OnAppearing();
            IsBusy = false;
            _viewModel.LoadItemsCommand.Execute(null);
            foreach (var address in _viewModel.Addresses)
            {
                address.IsSelected = false;
            }
        }
        private async void editButton_Clicked(object sender, EventArgs e)
        {
            if (IsBusy)
                return;
            IsBusy = true;
            var button = sender as Button;
            var vm = button.CommandParameter as AddressViewModel;
            if (vm == null)
                return;
            await Navigation.PushAsync(new AddressEditPage(vm));
        }


        private void AddressList_SelectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e)
        {
            var list = sender as RadListView;
            var vm = list.SelectedItem as AddressViewModel;
            var isSelected = !vm.IsSelected;
            foreach (var address in _viewModel.Addresses)
            {
                address.IsSelected = false;
            }
            vm.IsSelected = isSelected;
        }
        private async void deleteButton_Clicked(object sender, EventArgs e)
        {
            if (IsBusy)
                return;
            try
            {
                IsBusy = true;
                var button = sender as Button;
                var vm = button.CommandParameter as AddressViewModel;
                if (vm == null)
                    return;
                string action = await DisplayActionSheet("Are you sure you want to remove this address?", "Cancel", null, "Yes", "No");
                if (action == "Yes")
                {
                    var address = new Address()
                    {
                        AddressLine1 = vm.AddressLine1,
                        City = vm.City,
                        DisplayName = vm.DisplayName,
                        Id = Guid.Parse(vm.Id),
                        IsDefault = vm.IsDefault,
                        ZipCode = vm.ZipCode
                    };
                    DeleteAddressResponse response = await App.MenuManager.DeleteAddress(new DeleteAddressRequest() { Address = address });
                    if (response == null)
                        return;
                    if (!response.Succeeded)
                    {
                        if (!string.IsNullOrEmpty(response.Message))
                            PopupHelper.CreateErrorPopup(response.Message);
                        else
                            PopupHelper.CreateErrorPopup("Something went wrong");
                    }
                    else
                        _viewModel.LoadItemsCommand.Execute(null);

                }
                else if (action == "No")
                    return;
            }
            catch (Exception ex)
            {
                IsBusy = false;
            }
            IsBusy = false;
        }
        private async void proceedButton_Clicked(object sender, EventArgs e)
        {
            if (IsBusy)
                return;
            try
            {
                IsBusy = true;
                var selectedAddress = AddressList.SelectedItem as AddressViewModel;
                if (selectedAddress == null )
                {
                    PopupHelper.CreatePopup("Uh-oh!", "Select an address to continue");
                    IsBusy = false;
                    return;
                }
                var address = new Address()
                {
                    AddressLine1 = selectedAddress.AddressLine1,
                    City = selectedAddress.City,
                    DisplayName = selectedAddress.DisplayName,
                    Id = Guid.Parse(selectedAddress.Id),
                    IsDefault = selectedAddress.IsDefault,
                    ZipCode = selectedAddress.ZipCode
                };
                if (selectedAddress == null)
                    return;
                var cards = await App.MenuManager.GetCreditCards(new GetCreditCardsRequest());
                if (cards == null)
                    return;
                if (!cards.Succeeded)
                {
                    if(!string.IsNullOrEmpty(cards.Message))
                        PopupHelper.CreateErrorPopup(cards.Message);
                    else
                        PopupHelper.CreateErrorPopup("Something went wrong");
                    IsBusy = false;
                    return;
                }
                    
                if (cards.CreditCards == null)
                    PushPaymentPage(address);
                if (cards.CreditCards.Count != 0)
                    PushCreditCardListPage(address, cards.CreditCards);
                else
                    PushPaymentPage(address);

            }
            catch (Exception ex)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Unable to proceed");IsBusy = false;
            }
        }

        private async void NewAddress_Clicked(object sender, EventArgs e)
        {
            IsBusy = true;
            await Navigation.PushAsync(new AddressEditPage());
        }
        private async void PushCreditCardListPage(Address selectedAddress, List<CreditCard> cards)
        {
            var items = from i in _db.Table<ShoppingCartItem>()
                        select i;
            var orderTotals = (from o in _db.Table<OrderTotals>() select o).ToList();
            var totals = orderTotals.FirstOrDefault();
            if (totals == null)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
                return;
            }
            if (orderTotals.Count() != 0)
                _db.DeleteAll<OrderTotals>();
            _db.Insert(totals);
            CustomerInfoApp info = new CustomerInfoApp()
            {
                AddressLine1 = selectedAddress.AddressLine1,
                City = selectedAddress.City,
                ZipCode = selectedAddress.ZipCode
            };
            var localTransaction = new LocalTransactionV1_1()
            {
                Info = info,
                TransactionItems = items.ToList(),
                Totals = totals,
                IsDelivery = IsDelivery,
                NoContactDelivery = NoContact
            };
            _db.CreateTable<SqliteTransaction>();
            var localTransactionSqlite = new SqliteTransaction(localTransaction);
            var forms = from f in _db.Table<SqliteTransaction>() select f;
            if (forms.Count() != 0)
                _db.DeleteAll<SqliteTransaction>();
            _db.Insert(localTransactionSqlite);

            var response = await App.MenuManager.ValidateTransaction(localTransaction);
            if (response.Succeeded)
                await Navigation.PushAsync(new CreditCardListPage(cards, IsDelivery,NoContact));
            else
            {
                if (response.Message != null || response.Message != string.Empty)
                    PopupHelper.CreatePopup("Uh-oh!", response.Message);
                else
                    PopupHelper.CreatePopup("Uh-oh!", "Unable to process transaction");
            }

        }
        private async void PushPaymentPage(Address selectedAddress)
        {
            var items = from i in _db.Table<ShoppingCartItem>()
                        select i;
            var orderTotal = (from o in _db.Table<OrderTotals>() select o).FirstOrDefault();
            if (orderTotal == null)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
                return;
            }
            CustomerInfoApp info = new CustomerInfoApp()
            {
                AddressLine1 = selectedAddress.AddressLine1,
                City = selectedAddress.City,
                ZipCode = selectedAddress.ZipCode
            };
            var localTransaction = new LocalTransactionV1_1()
            {
                IsDelivery = IsDelivery,
                Info = info,
                TransactionItems = items.ToList(),
                Totals = orderTotal,
                NoContactDelivery = NoContact
            };
            _db.CreateTable<SqliteTransaction>();
            var localTransactionSqlite = new SqliteTransaction(localTransaction);
            var forms = from f in _db.Table<SqliteTransaction>() select f;
            if (forms.Count() != 0)
                _db.DeleteAll<SqliteTransaction>();
            _db.Insert(localTransactionSqlite);

            var response = await App.MenuManager.ValidateTransaction(localTransaction);
            if (response.Succeeded)
            {
                var sendTransactionResponse = await App.MenuManager.GetHPPToken(localTransaction);
                if (sendTransactionResponse != null)
                {
                    await Navigation.PushAsync(new WebViewPage(sendTransactionResponse));
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
    }
}