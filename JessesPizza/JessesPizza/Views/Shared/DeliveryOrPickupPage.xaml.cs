using Acr.UserDialogs;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Helpers;
using JessesPizza.Models;
using SQLite;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Essentials;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class DeliveryOrPickupPage : ContentPage
    {
        private SQLiteConnection _db { get; set; }
        public decimal DeliveryCharge { get; set; } = 0m;
        public bool IsBusy { get; set; }
        public bool IsGuest { get; set; }
        public string SpecialInstructionsForOrder { get; set; }
        public DeliveryOrPickupPage()
        {
            InitializeComponent();
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);

        }
        private async Task<bool> GetSpecialInstructions()
        {
            string action = await DisplayActionSheet("Add special instructions for order?", "Cancel", null,"Yes", "No");
            if (action == "Cancel" || string.IsNullOrEmpty(action))
            {
                return false;
            }
            if (action == "No" || string.IsNullOrEmpty(action))
            {
                return true;
            }
            if (action == "Yes" || string.IsNullOrEmpty(action))
            {
                PromptResult pResult = await UserDialogs.Instance.PromptAsync(new PromptConfig
                {
                    InputType = InputType.Default,
                    OkText = "Ok",
                    Title = "Special instructions for order"
                });
                if (pResult.Ok && !string.IsNullOrWhiteSpace(pResult.Text))
                {
                    SpecialInstructionsForOrder  = pResult.Text;
                    var orderTotals = (from o in _db.Table<OrderTotals>() select o).ToList();
                    var totals = orderTotals.FirstOrDefault();
                    if (totals == null)
                    {
                        PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
                        return false;
                    }
                    if (orderTotals.Count() != 0)
                        _db.DeleteAll<OrderTotals>();
                    totals.SpecialInstructions = SpecialInstructionsForOrder;
                    _db.Insert(totals);
                    return true;

                }
                if (!pResult.Ok)
                {
                    return false;

                }
                return true;
            }

            return false;

        }
        protected override async void OnAppearing()
        {
            try
            {
                IsBusy = false;
                base.OnAppearing();
                var oauthTokenIsGuest = await SecureStorage.GetAsync("oauth_token_is_guest");
                IsGuest = bool.Parse(oauthTokenIsGuest);
                var settingsResponse = await App.MenuManager.GetOrderInfoAsync();
                if (settingsResponse == null)
                    PopupHelper.CreateErrorPopup("Something went wrong");
                else
                {
                    DeliveryButton.Text = $"DELIVERY (+ {settingsResponse.DeliveryCharge.ToString("C")})";
                    NoContactButton.Text = $"NO CONTACT DELIVERY (+ {settingsResponse.DeliveryCharge.ToString("C")})";
                    DeliveryCharge = settingsResponse.DeliveryCharge;
                }

            }

            catch (Exception e)
            {

            }
        }
        private async void PickUpButton_Clicked(object sender, EventArgs e)
        {
            if (IsBusy)
                return;
            IsBusy = true;
            try
            {
                 var instructions = await GetSpecialInstructions();
                if (!instructions)
                {
                    IsBusy = false;
                    return;
                }
                var orderTotal = (from o in _db.Table<OrderTotals>() select o).FirstOrDefault();
                if (orderTotal == null)
                {
                    PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
                    return;
                }

                orderTotal.DeliveryCharge = 0m;
                orderTotal.Total = orderTotal.SubTotal + decimal.Round(orderTotal.TaxTotal, 2) + decimal.Round(orderTotal.Tip, 2);
                _db.Update(orderTotal);

                if (IsGuest)
                    await Navigation.PushAsync(new GuestInfoPage("Payment Information",false,false));
                else
                {
                    GetCreditCardsRequest request = new GetCreditCardsRequest();
                    GetCreditCardsResponse response = await App.MenuManager.GetCreditCards(request);
                    if (!response.Succeeded)
                    {
                        IsBusy = false;
                        PopupHelper.CreateErrorPopup(response.Message);
                    }

                    else
                    {
                        if (response.CreditCards.Count != 0)
                            await Navigation.PushAsync(new CreditCardListPage(response.CreditCards, false,false)); 
                        else
                            PushPaymentPage(false,false);

                    }

                }
            }
            catch
            {
                PopupHelper.CreateErrorPopup("Something went wrong");
                IsBusy = false;
            }
        }



        private async void DeliveryButton_Clicked(object sender, EventArgs e)
        {
            if (IsBusy)
                return;
            IsBusy = true;
            var instructions = await GetSpecialInstructions();
            if (!instructions)
            {
                IsBusy = false;
                return;
            }
            var orderTotal = (from o in _db.Table<OrderTotals>() select o).FirstOrDefault();
            if (orderTotal == null)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
                return;
            }
            var response = await App.MenuManager.ValidateTransactionAmount(orderTotal.SubTotal);
            if (!response.Succeeded)
            {
                if (!string.IsNullOrEmpty(response.Message))
                    PopupHelper.CreateErrorPopup(response.Message);
                else
                    PopupHelper.CreateErrorPopup("Couldn't reach server");
                IsBusy = false;
                return;
            }
            orderTotal.DeliveryCharge = DeliveryCharge;
            orderTotal.Total = orderTotal.DeliveryCharge + orderTotal.SubTotal + decimal.Round(orderTotal.TaxTotal, 2) + decimal.Round(orderTotal.Tip, 2);
            _db.Update(orderTotal);
            if (IsGuest)
                await Navigation.PushAsync(new GuestInfoPage("Delivery Information",true,false));
            else
                await Navigation.PushAsync(new AddressListPage(true,false));
        }

        private async void NoContactDeliveryButton_Clicked(object sender, EventArgs e)
        {
            if (IsBusy)
                return;
            IsBusy = true;
            var instructions = await GetSpecialInstructions();
            if (!instructions)
            {
                IsBusy = false;
                return;
            }
            var orderTotal = (from o in _db.Table<OrderTotals>() select o).FirstOrDefault();
            if (orderTotal == null)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
                return;
            }
            var response = await App.MenuManager.ValidateTransactionAmount(orderTotal.SubTotal);
            if (!response.Succeeded)
            {
                if (!string.IsNullOrEmpty(response.Message))
                    PopupHelper.CreateErrorPopup(response.Message);
                else
                    PopupHelper.CreateErrorPopup("Couldn't reach server");
                IsBusy = false;
                return;
            }
            orderTotal.DeliveryCharge = DeliveryCharge;
            orderTotal.Total = orderTotal.DeliveryCharge + orderTotal.SubTotal + decimal.Round(orderTotal.TaxTotal, 2) + decimal.Round(orderTotal.Tip, 2);
            _db.Update(orderTotal);
            if (IsGuest)
                await Navigation.PushAsync(new GuestInfoPage("Delivery Information",false,true));
            else
                await Navigation.PushAsync(new AddressListPage(false,true));
        }  


        private async void PushPaymentPage(bool isDelivery, bool noContact)
        {
            var items = from i in _db.Table<ShoppingCartItem>()
                        select i;
            var orderTotal = (from o in _db.Table<OrderTotals>() select o).FirstOrDefault();
            if (orderTotal == null)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
                return;
            }
            orderTotal.DeliveryCharge = 0;
            orderTotal.Total = orderTotal.DeliveryCharge + orderTotal.SubTotal + orderTotal.Tip + orderTotal.TaxTotal;
            _db.Update(orderTotal);
            GetAccountInfoResponse infoResponse = await App.MenuManager.GetAccountInfo();
            if (!infoResponse.Succeeded) //reload and add back to view
                PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
            CustomerInfoApp info = infoResponse.Info;
            var localTransaction = new LocalTransactionV1_1()
            {
                IsDelivery = false,
                Info = info,
                TransactionItems = items.ToList(),
                Totals = orderTotal,
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
    }
}