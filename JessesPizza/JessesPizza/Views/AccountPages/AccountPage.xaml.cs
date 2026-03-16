using Acr.UserDialogs;
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
    public partial class AccountPage : ContentPage
    {
        public AccountPage()
        {
            InitializeComponent();
        }

        private void Button_Clicked(object sender, EventArgs e)
        {

        }

        private async void InfoButton_Clicked(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new ManageAddressesPage());
        }

        private async void PaymentInfoButton_Clicked(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new ManageCreditCardsPage());

        }

        private async void DeleteButton_Clicked(object sender, EventArgs e)
        {
            try
            {
                string action = await DisplayActionSheet($"Are you sure you want to delete your account? You cannot undo this action", "Cancel", null, "No", "Yes, I'm sure");
                if (action == "Yes, I'm sure")
                {
                    UserDialogs.Instance.ShowLoading();
                    var request = new DeleteAccountRequest()
                    {
                    };
                    DeleteAccountResponse response = await App.MenuManager.DeleteAccount(request);
                    if (response == null)
                    {
                        PopupHelper.CreatePopup("Uh-oh!", $"Something went wrong");
                        return;
                    }
                    if (response.Succeeded)
                    {
                        SecureStorage.Remove("oauth_token");
                        SecureStorage.Remove("oauth_token_expiration");
                        SecureStorage.Remove("oauth_token_is_guest");
                        App.Current.MainPage = new NavigationPage(new HomeScreen());
                        PopupHelper.CreatePopup("Successfully deleted account!", $"Your payment and personal information has been permanently removed from our server");
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
                UserDialogs.Instance.HideLoading();
            }
            return;
        }
    }
}
