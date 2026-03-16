using Acr.UserDialogs;
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
    public partial class ConfirmPasswordChangePage : ContentPage
    {
        ConfirmPasswordChangeViewModel _viewModel;
        private bool buttonPressed;

        public string PhoneNumber { get; set; }
        public ConfirmPasswordChangePage(string phoneNumber)
        {
            PhoneNumber = phoneNumber;
            BindingContext = _viewModel = new ConfirmPasswordChangeViewModel();
            InitializeComponent();
            DataForm.Source = _viewModel;
            DataForm.RegisterEditor(nameof(_viewModel.Code), EditorType.TextEditor);
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
                    ConfirmPasswordChangeRequest request = new ConfirmPasswordChangeRequest() { Code = _viewModel.Code, PhoneNumber = PhoneNumber};
                    ConfirmPasswordChangeResponse result = await App.MenuManager.ConfirmPasswordChange(request);
                    if (result == null)
                    {
                        PopupHelper.CreatePopup("Uh-oh!", "Something went wrong");
                    }
                    if (result.Succeeded)
                    {
                        await Navigation.PushAsync(new NewPasswordPage(PhoneNumber));
                        buttonPressed = false;
                    }
                    else
                    {
                        PopupHelper.CreatePopup("Uh-oh!", result.Message);
                        buttonPressed = false;
                    }
                }

            }
            catch (Exception ex)
            {
            }
        }

        private async void TapGestureRecognizer_Tapped(object sender, EventArgs e)
        {
            try
            {
                ResendChangePasswordCodeRequest request = new ResendChangePasswordCodeRequest() { Code = _viewModel.Code, PhoneNumber = PhoneNumber};
                ResendChangePasswordCodeResponse result = await App.MenuManager.ResendChangePasswordCode(request);
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
            catch (Exception ex)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Failed to resend code");
            }
        }
    }
}