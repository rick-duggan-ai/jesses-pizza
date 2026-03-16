using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Helpers;
using JessesPizza.Models;
using JessesPizza.ViewModels;
using SQLite;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Telerik.XamarinForms.DataControls;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ManageAddressesPage : ContentPage
    {
        AddressListViewModel _viewModel;
        private SQLiteConnection _db;
        private bool IsBusy;

        public ManageAddressesPage(List<Address> addresses)
        {
            InitializeComponent();
            BindingContext = _viewModel = new AddressListViewModel(addresses);
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);

        }
        public ManageAddressesPage()
        {
            InitializeComponent();
            BindingContext = _viewModel = new AddressListViewModel();
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);
        }
        protected override void OnAppearing()
        {
            base.OnAppearing();
            IsBusy = false;
            _viewModel.LoadItemsCommand.Execute(null);
        }
        private async void editButton_Clicked(object sender, EventArgs e)
        {
            if (IsBusy)
                return;
            IsBusy = true;
            var button = sender as Button;
            var vm = button.CommandParameter as AddressViewModel;
            if (vm == null)
                return;
            await Navigation.PushAsync(new AddressEditPage(vm));
        }



        private async void deleteButton_Clicked(object sender, EventArgs e)
        {
            if (IsBusy)
                return;
            try
            {
                IsBusy = true;
                var button = sender as Button;
                var vm = button.CommandParameter as AddressViewModel;
                if (vm == null)
                    return;
                string action = await DisplayActionSheet("Are you sure you want to remove this address?", "Cancel", null, "Yes", "No");
                if (action == "Yes")
                {
                    var address = new Address()
                    {
                        AddressLine1 = vm.AddressLine1,
                        City = vm.City,
                        DisplayName = vm.DisplayName,
                        Id = Guid.Parse(vm.Id),
                        IsDefault = vm.IsDefault,
                        ZipCode = vm.ZipCode
                    };
                    DeleteAddressResponse response = await App.MenuManager.DeleteAddress(new DeleteAddressRequest() { Address = address });
                    if (response == null)
                        return;
                    if (!response.Succeeded)
                    {
                        if (!string.IsNullOrEmpty(response.Message))
                            PopupHelper.CreateErrorPopup(response.Message);
                        else
                            PopupHelper.CreateErrorPopup("Something went wrong");
                    }
                    else
                        _viewModel.LoadItemsCommand.Execute(null);

                }
                else if (action == "No")
                    return;
            }
            catch (Exception ex)
            {
                IsBusy = false;

            }
            IsBusy = false;
        }

        private async void NewAddress_Clicked(object sender, EventArgs e)
        {
            if (IsBusy)
                return;
            IsBusy = true;
            await Navigation.PushAsync(new AddressEditPage());
        }

    }
}