using JessesPizza.Core.Models.Identity;
using JessesPizza.Helpers;
using JessesPizza.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Telerik.XamarinForms.Input;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ForgotPasswordPage : ContentPage
    {
        public bool buttonPressed;
        public ForgotPasswordViewModel _viewModel;
        public ForgotPasswordPage()
        {
            BindingContext = _viewModel = new ForgotPasswordViewModel();
            InitializeComponent();
            DataForm.Source = _viewModel;
            DataForm.RegisterEditor(nameof(_viewModel.PhoneNumber), EditorType.TextEditor);
            
        }

        private async void DataForm_FormValidationCompleted(object sender, Telerik.XamarinForms.Input.DataForm.FormValidationCompletedEventArgs e)
        {
            try
            {

                if (e.IsValid)
                {
                    if (!buttonPressed)
                        return;

                    ForgotPasswordResponse result = await App.MenuManager.ForgotPassword(new ForgotPasswordRequest() { PhoneNumber = _viewModel.PhoneNumber});
                    if (result == null)
                    {
                        PopupHelper.CreatePopup("Sign in failed", "Something went wrong");
                    }
                    if (result.Succeeded)

                    {
                        buttonPressed = false;
                        await Navigation.PushAsync(new ConfirmPasswordChangePage(_viewModel.PhoneNumber));
                    }

                    else
                    {
                        PopupHelper.CreatePopup("Sign in failed", result.Message);

                    }
                }

            }
            catch (Exception ex)
            {
            }
        }

        private void ContinueButton_Clicked(object sender, EventArgs e)
        {
            buttonPressed = true;
            DataForm.ValidateAll();
        }
    }
}