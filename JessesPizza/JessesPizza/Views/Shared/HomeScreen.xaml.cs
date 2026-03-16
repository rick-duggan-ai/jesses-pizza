using JessesPizza.Core.Models.Identity;
using JessesPizza.Helpers;
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
    public partial class HomeScreen : ContentPage
    {
        public HomeScreen()
        {
            InitializeComponent();
            //NavigationPage.SetHasNavigationBar(this, false);
            NavigationPage.SetHasBackButton(this, false);
        }

        protected override void OnAppearing()
        {
            MessagingCenter.Send<string>("0", "DisableGesture");
        }
        private async void SignUpButton_Clicked(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new PrivacyPolicyPage(false));

        }
        private async void SignInButton_Clicked(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new SignInPage());
        }
        private async void GuestButton_Clicked(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new PrivacyPolicyPage(true));

        }
    }
}