using JessesPizza.Core.Models.Identity;
using JessesPizza.Helpers;
using JessesPizza.ViewModels;
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
    public partial class PrivacyPolicyPage : ContentPage
    {
        private PrivacyPolicyViewModel _viewModel;
        private bool IsGuest { get; set; }
        public PrivacyPolicyPage(bool isGuest)
        {
            IsGuest = isGuest;
            BindingContext = _viewModel = new PrivacyPolicyViewModel();
            InitializeComponent();
        }
        protected override async void OnAppearing()
        {
            _viewModel.LoadItemsCommand.Execute(null);
            base.OnAppearing();
        }

        private async void ContinueButton_Clicked(object sender, EventArgs e)
        {
            try
            {
                if (IsGuest)
                {
                    var result = await App.MenuManager.GuestLogin(new GuestLoginRequest() { Secret = "JessesPizzaAppSecret" });
                    await SecureStorage.SetAsync("oauth_token", result.Token);
                    await SecureStorage.SetAsync("oauth_token_expiration", result.TokenExpires.ToString());
                    await SecureStorage.SetAsync("oauth_token_is_guest", "true");
                    MessagingCenter.Send<object, string>(this, "GuestLogin", "Successful");
                    //MessagingCenter.Send(this, "GuestLogin", "Successful");
                    var mainPage = new MainPage() { Detail = new NavigationPage(new MainMenuPage()), Master = new MenuPageGuest() };
                    App.Current.MainPage = mainPage;
                }
                else
                {
                    await Navigation.PushAsync(new SignUpPage());
                }
            }
            catch (Exception ex)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Unable to reach server");
            }
        }
    }
}