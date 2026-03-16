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
    public partial class SignUpAddressPage : ContentPage
    {
        private SignUpAddressViewModel _viewModel;
        private bool buttonPressed;

        public SignUpAddressPage(string username, string password)
        {
            _viewModel = new SignUpAddressViewModel(username,password);

            InitializeComponent();
            DataForm.Source = _viewModel;
            DataForm.RegisterEditor(nameof(_viewModel.LastName), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.FirstName), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.AddressLine1), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.City), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.ZipCode), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.PhoneNumber), EditorType.TextEditor);
        }

        private void SubmitButton_Clicked(object sender, EventArgs e)
        {
            buttonPressed = true;
            DataForm.ValidateAll();
            
        }
        protected override void OnAppearing()
        {
            base.OnAppearing();
            buttonPressed = false;
        }
        private async void DataFormValidationCompleted(object sender, FormValidationCompletedEventArgs e)
        {
            if (e.IsValid)
            {
                var request = new SignUpRequest()
                {
                    Info = new CustomerInfo()
                    {
                        Address = _viewModel.AddressLine1,
                        City = _viewModel.City,
                        FirstName = _viewModel.FirstName,
                        LastName = _viewModel.LastName,
                        PhoneNumber = _viewModel.PhoneNumber,
                        ZipCode = _viewModel.ZipCode,
                        Email = _viewModel.Username
                    },
                    Email = _viewModel.Username,
                    Password = _viewModel.Password
                    
                };
                SignUpResponse result = await App.MenuManager.CreateUser(request);
                if (result == null)
                {
                    PopupHelper.CreateErrorPopup("Something went wrong");
                }
                if (result.Succeeded)
                {
                    if (buttonPressed)
                        await Navigation.PushModalAsync(new ConfirmAccountPage(_viewModel.Username));
                }
                else
                {
                    PopupHelper.CreateErrorPopup(result.Message);
                }
            }
            buttonPressed = false;
        }
    }
}