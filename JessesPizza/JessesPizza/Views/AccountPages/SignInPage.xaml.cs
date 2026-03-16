using Acr.UserDialogs;
using Flurl;
using Flurl.Http;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Helpers;
using JessesPizza.Models;
using JessesPizza.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Telerik.XamarinForms.Input;
using Telerik.XamarinForms.Primitives;
using Xamarin.Essentials;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class SignInPage : ContentPage
    {
        public bool buttonPressed;
        SignInViewModel _viewModel;
        public SignInPage()
        {
            
            InitializeComponent();
            BindingContext = _viewModel = new SignInViewModel() { };
            DataForm.Source = _viewModel;
            DataForm.RegisterEditor(nameof(_viewModel.Email), EditorType.Custom);
            DataForm.RegisterEditor(nameof(_viewModel.Password), EditorType.Custom);
        }
        private void SubmitButton_Clicked(object sender, EventArgs e)
        {
            buttonPressed = true;
            DataForm.ValidateAll();
        }

        private async void DataFormValidationCompleted(object sender, Telerik.XamarinForms.Input.DataForm.FormValidationCompletedEventArgs e)
        {
            try
            {

                if (e.IsValid)
                {
                    if (!buttonPressed)
                        return;
                    LoginResponse result = await App.MenuManager.Login(new LoginRequest() { Email = _viewModel.Email, Password = _viewModel.Password });
                    if (result == null)
                    {
                        PopupHelper.CreatePopup("Sign in failed", "Something went wrong");
                    }
                    if (result.Succeeded && !string.IsNullOrEmpty(result.Token))

                    {
                        if(result.AccountConfirmed)
                        { 
                        buttonPressed = false;
                        await SecureStorage.SetAsync("oauth_token", result.Token);
                        await SecureStorage.SetAsync("oauth_token_expiration", result.TokenExpires.ToString());
                        await SecureStorage.SetAsync("oauth_token_is_guest", "false");
                        var mainPage = new MainPage() { Detail = new NavigationPage(new MainMenuPage()), Master = new MenuPageUser() };
                        MessagingCenter.Send<SignInPage, string>(this, "Login", result.Name);
                        App.Current.MainPage = mainPage;
                        PopupHelper.CreatePopup("Sign in succeeded", $"Welcome {result.Name}");

                        }
                        else
                            await Navigation.PushModalAsync(new ConfirmAccountPage(_viewModel.Email));

                    }

                    else
                    {
                        PopupHelper.CreatePopup("Sign in failed", result.Message);

                    }
                }
                else
                    buttonPressed = false;

            }
            catch (Exception ex)
            {
            }
        }

        private async void TapGestureRecognizer_Tapped(object sender, EventArgs e)
        {
            await Navigation.PushAsync(new ForgotPasswordPage());
        }
    }
}