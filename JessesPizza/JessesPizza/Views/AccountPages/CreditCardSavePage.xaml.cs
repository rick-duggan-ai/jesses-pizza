using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Helpers;
using JessesPizza.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class CreditCardSavePage : ContentPage
    {
        public CreditCardSaveViewModel _viewModel { get; set; }
        public CreditCard _card { get; set; }
        MainPage RootPage { get => Application.Current.MainPage as MainPage; }
        
        public CreditCardSavePage(CreditCard card)
        {
            try
            {
                _card = card;
                InitializeComponent();
                NavigationPage.SetHasNavigationBar(this, false);

            }
            catch (Exception e)
            {
                PopupHelper.CreateErrorPopup("Unable to save card");
            }
        }
        protected async override void OnAppearing()
        {
            try
            {
                base.OnAppearing();
                CardView.BindingContext = new CreditCardViewModel(_card);
                IsBusy = false;
            }
            catch
            (Exception e)
            {
                PopupHelper.CreateErrorPopup("Unable to save card");
            }
        }
        private async void YesButton_Clicked(object sender, EventArgs e)
        {
            try
            {
                if (IsBusy)
                    return;
                IsBusy = true;
                var savedCardResponse = await App.MenuManager.SaveCreditCard(_card);
                if (savedCardResponse)
                {
                    PopupHelper.CreatePopup("Card Successfully Saved", "");
                    Device.BeginInvokeOnMainThread(async () => { await Navigation.PopToRootAsync();});
                    Device.BeginInvokeOnMainThread(async () => { await RootPage.NavigateFromMenu((int)MenuItemType.Orders); });
                }
                else
                {
                    PopupHelper.CreateErrorPopup("Unable to save card");
                    return;
                }

            }
            catch (Exception ex)
            {
                IsBusy = false;
                PopupHelper.CreateErrorPopup("Unable to save card");
            }
        }

        private void NoButton_Clicked(object sender, EventArgs e)
        {
            try
            {
                Device.BeginInvokeOnMainThread(async () => { await Navigation.PopToRootAsync(); await RootPage.NavigateFromMenu((int)MenuItemType.Orders); });
            }
            catch (Exception ex)
            {

            }
        }
    }
}