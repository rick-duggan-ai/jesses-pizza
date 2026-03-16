using JessesPizza.Core.Models.Identity;
using JessesPizza.Helpers;
using JessesPizza.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class AddressEditPage : ContentPage
    {
        private AddressViewModel _viewModel;
        private bool isEdit { get; set; }
        public bool buttonPressed;

        public AddressEditPage()
        {
            InitializeComponent();
            BindingContext = _viewModel = new AddressViewModel();
            Title = "Add a new address";
            isEdit = false;
        }
        public AddressEditPage(Address address)
        {
            InitializeComponent();
            BindingContext = _viewModel = new AddressViewModel(address);
            Title = "Edit Address";
            isEdit = true;
        }
        public AddressEditPage(AddressViewModel vm)
        {
            InitializeComponent();
            BindingContext = _viewModel = vm;
            Title = "Edit Address";
            isEdit = true;
        }
        private void SaveButton_Clicked(object sender, EventArgs e)
        {
            buttonPressed = true;
            DataForm.ValidateAll();
        }

        private async void DataForm_FormValidationCompleted(object sender, Telerik.XamarinForms.Input.DataForm.FormValidationCompletedEventArgs e)
        {
            try
            {

                if (e.IsValid)
                {
                    if (!buttonPressed)
                        return;
                    var address = new Address();
                    address.DisplayName = _viewModel.DisplayName;
                    address.AddressLine1 = _viewModel.AddressLine1;
                    address.ZipCode = _viewModel.ZipCode;
                    address.City = _viewModel.City;
                    address.IsDefault = _viewModel.IsDefault;
                    address.Id = Guid.Parse(_viewModel.Id);
                    SaveAddressResponse result = await App.MenuManager.SaveAddress(new SaveAddressRequest() {Address=address });
                    if (result == null)
                    {
                        PopupHelper.CreatePopup("Unable to save address", "Something went wrong");
                    }
                    if (result.Succeeded)

                    {
                        await Navigation.PopAsync();
                    }

                    else
                    {
                        PopupHelper.CreatePopup("Unable to save address", result.Message);

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