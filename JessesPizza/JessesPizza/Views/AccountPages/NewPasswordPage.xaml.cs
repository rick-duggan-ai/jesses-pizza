using JessesPizza.Core.Models.Identity;
using JessesPizza.Helpers;
using JessesPizza.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Telerik.XamarinForms.Input;
using Telerik.XamarinForms.Input.DataForm;
using Xamarin.Essentials;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class NewPasswordPage : ContentPage
    {
        private bool buttonPressed;
        private NewPasswordViewModel _viewModel;

        string PhoneNumber { get; set; }
        public NewPasswordPage(string phoneNumber)
        {
            BindingContext = _viewModel = new NewPasswordViewModel();
            PhoneNumber = phoneNumber;
            InitializeComponent();
            DataForm.Source = _viewModel;
            DataForm.RegisterEditor(nameof(_viewModel.Password), EditorType.Custom);
            DataForm.RegisterEditor(nameof(_viewModel.ConfirmPassword), EditorType.Custom);

        }

        private void ResetButton_Clicked(object sender, EventArgs e)
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
                    if (!_viewModel.Password.Equals(_viewModel.ConfirmPassword))
                    {
                        PopupHelper.CreatePopup("Uh oh!", "Passwords do not match");
                        return;
                    }
                    NewPasswordResponse result = await App.MenuManager.UpdatePassword(new NewPasswordRequest() { PhoneNumber = PhoneNumber, Password = _viewModel.Password });
                    if (result == null)
                    {
                        PopupHelper.CreatePopup("Uh-oh!", "Something went wrong");
                    }
                    if (result.Succeeded)
                    {
                        PopupHelper.CreatePopup("Password Changed", "Your password was updated successfully!");
                        await SecureStorage.SetAsync("oauth_token", result.Token);
                        await SecureStorage.SetAsync("oauth_token_expiration", result.TokenExpires.ToString());
                        await SecureStorage.SetAsync("oauth_token_is_guest", "false");
                        MessagingCenter.Send(this, "Login", "Successful");
                        var mainPage = new MainPage() { Detail = new NavigationPage(new MainMenuPage()), Master = new MenuPageUser() };
                        App.Current.MainPage = mainPage;
                    }

                    else
                    {
                        PopupHelper.CreatePopup("Uh-oh!", result.Message);

                    }
                }
                else
                    buttonPressed = false;

            }
            catch (Exception ex)
            {
            }
        }
    }
}