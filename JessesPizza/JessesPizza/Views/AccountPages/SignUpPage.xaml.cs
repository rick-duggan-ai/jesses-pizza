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
using Telerik.XamarinForms.Primitives;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class SignUpPage : ContentPage
    {
        SignUpViewModel _viewModel;
        private bool buttonPressed;

        public SignUpPage()
        {

            _viewModel = new SignUpViewModel() { };
            InitializeComponent();
            DataForm.Source = _viewModel;
            DataForm.RegisterEditor(nameof(_viewModel.Email), EditorType.Custom);
            DataForm.RegisterEditor(nameof(_viewModel.Password), EditorType.Custom);
            DataForm.RegisterEditor(nameof(_viewModel.ConfirmPassword), EditorType.Custom);
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();
            buttonPressed = false;
        }
        private async void SubmitButton_Clicked(object sender, EventArgs e)
        {
            DataForm.ValidateAll();
            buttonPressed = true;
        }
        private async void DataFormValidationCompleted(object sender, FormValidationCompletedEventArgs e)
        {
            try
            {

                if (e.IsValid)
                {
                    if (!_viewModel.Password.Equals(_viewModel.ConfirmPassword))
                    {
                        PopupHelper.CreatePopup("Uh oh!", " Passwords do not match");
                        return;
                    }
                    SignUpEmailValidationResponse result = await App.MenuManager.ValidateEmailAddress(_viewModel.Email, _viewModel.Password);
                    if (result == null)
                    {
                        PopupHelper.CreatePopup("Uh oh!", "Something went wrong");
                    }
                    if (result.Succeeded)
                    {
                        if (buttonPressed)
                            await Navigation.PushAsync(new SignUpAddressPage(_viewModel.Email, _viewModel.Password));
                    }

                    else
                    {
                        PopupHelper.CreatePopup("Uh oh!", result.Message);

                    }
                }

            }
            catch (Exception ex)
            {
            }
        }
    }
}