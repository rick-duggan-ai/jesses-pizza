using Acr.UserDialogs;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Helpers;
using JessesPizza.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Telerik.XamarinForms.Input.DataForm;
using Telerik.XamarinForms.Primitives;
using Xamarin.Essentials;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ConfirmAccountPage : ContentPage
    {
        ConfirmAccountViewModel _viewModel;
        private bool buttonPressed;
        string Email;
        protected override bool OnBackButtonPressed() => false;
        public ConfirmAccountPage(string emailAddress)
        {
            Email = emailAddress;
            InitializeComponent();
            DataForm.Source = _viewModel = new ConfirmAccountViewModel();
        }

        private void SubmitButton_Clicked(object sender, EventArgs e)
        {
            buttonPressed = true;
            DataForm.ValidateAll();
        }

        private async void DataFormValidationCompleted(object sender, FormValidationCompletedEventArgs e)
        {
            try
            {

                if (e.IsValid)
                {
                    if (!buttonPressed)
                        return;
                    ConfirmAccountRequest request = new ConfirmAccountRequest() { Code = _viewModel.Code, Email = Email };
                    ConfirmAccountResponse result = await App.MenuManager.ConfirmAccount(request);
                    if (result == null)
                    {
                        PopupHelper.CreatePopup("Uh-oh!","Something went wrong");
                    }
                    if (result.Succeeded)
                    {
                        await SecureStorage.SetAsync("oauth_token", result.Token);
                        await SecureStorage.SetAsync("oauth_token_expiration", result.TokenExpires.ToString());
                        await SecureStorage.SetAsync("oauth_token_is_guest", "false");
                        MessagingCenter.Send(this, "Login", "Successful");
                        var mainPage = new MainPage() { Detail = new NavigationPage(new MainMenuPage()), Master = new MenuPageUser() { } };
                        App.Current.MainPage = mainPage;
                        MessagingCenter.Send<ConfirmAccountPage, string>(this, "Login", result.Name);
                        PopupHelper.CreatePopup($"Welcome {result.Name}!", "Your account was successfully set up!");

                    }
                    else
                    {
                        PopupHelper.CreatePopup("Uh-oh!",result.Message);

                    }
                }

            }
            catch (Exception ex)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Unable To validate code");
            }
        }
        private async void TapGestureRecognizer_Tapped(object sender, EventArgs e)
        {
            try
            {
                ResendSignupCodeRequest request = new ResendSignupCodeRequest() { Code = _viewModel.Code, Email = Email };
                ResendSignupCodeResponse result = await App.MenuManager.ResendSignupCode(request);
                if (result == null)
                {
                    PopupHelper.CreatePopup("Uh-oh!", "Something went wrong");
                }
                if (result.Succeeded)
                {
                    UserDialogs.Instance.Toast($"Code resent successfully");
                }
                else
                {
                    PopupHelper.CreatePopup("Uh-oh!", result.Message);
                }
            }
            catch(Exception ex)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Failed to resend code");
            }
        }
    }
}