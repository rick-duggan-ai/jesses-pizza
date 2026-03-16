using Acr.UserDialogs;
using JessesPizza.Core.Models;
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

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views.AccountPages
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ReviewOrderPage : ContentPage
    {
        private ReviewOrderViewModel _viewModel;
        private SQLiteConnection _db { get; set; }
        private CreditCard Card { get; set; }
        MainPage RootPage { get => Application.Current.MainPage as MainPage; }
        public bool IsDelivery { get; }
        public bool NoContact { get; }

        public ReviewOrderPage()
        {
            InitializeComponent();
        }
        public ReviewOrderPage(LocalTransactionV1_1 transaction, CreditCard card)
        {
            try
            {
                InitializeComponent();
                Card = card;
                BindingContext = _viewModel = new ReviewOrderViewModel(transaction, card);
                _db = new SQLiteConnection(Constants.SqlLiteDbFolder);
                if (_viewModel.LocalTransaction.IsDelivery)
                    _viewModel.AddressLabelText = "Delivery Address";
                else
                    _viewModel.AddressLabelText = "Billing Address";

            }
            catch (Exception e)
            {
                PopupHelper.CreateErrorPopup("Something went wrong");
            }
        }

        private async void Button_Clicked(object sender, EventArgs e)
        {
            try
            {
                UserDialogs.Instance.ShowLoading();
                var items = from i in _db.Table<ShoppingCartItem>()
                            select i;
                if (_viewModel.LocalTransaction != null && items != null)
                {
                    var request = new PostTransactionRequestV1_1(_viewModel.LocalTransaction, Card) { };
                    PostTransactionResponse response = await App.MenuManager.PostTransaction(request);
                    if (response.Succeeded)
                    {
                        var db = new SQLiteConnection(Constants.SqlLiteDbFolder);
                        db.DeleteAll<OrderTotals>();
                        db.DeleteAll<ShoppingCartItem>();
                        DisplayOrderSubmittedPage();
                    }
                    else
                    {
                        PopupHelper.CreatePopup("Uh-oh!", $"{response.Message}");
                    }
                }
                UserDialogs.Instance.HideLoading();
            }
            catch (Exception ex)
            {
                PopupHelper.CreatePopup("Uh-oh!", $"Unable to place order at this time");
                UserDialogs.Instance.HideLoading();
            }
        }
        private async void DisplayOrderSubmittedPage()
        {

            await Navigation.PopToRootAsync();
            await RootPage.NavigateFromMenu((int)MenuItemType.Orders);
            PopupHelper.CreatePopup("Success!", "Order is fully complete");

        }
    }
}