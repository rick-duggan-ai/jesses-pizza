using System;
using System.Windows.Input;

using Xamarin.Forms;
using Xamarin.Essentials;
using System.Threading.Tasks;
using System.Diagnostics;
using JessesPizza.Core.Models;
using System.Collections.ObjectModel;
using JessesPizza.Core.Models.Identity;
using Telerik.Windows.Documents.Fixed.Model.Editing.Lists;
using System.Collections.Generic;
using JessesPizza.Helpers;
using Acr.UserDialogs;

namespace JessesPizza.ViewModels
{
    public class AddressListViewModel : BaseViewModel
    {
        public JessesPizzaSettings Settings { get; set; }
        public ObservableCollection<AddressViewModel> Addresses { get; set; } = new ObservableCollection<AddressViewModel>();
        public AddressListViewModel(List<Address> addresses)
        {
            //Addresses = new ObservableCollection<AddressViewModel>(addresses);
            Title = "Choose a delivery address";
        }
        public AddressListViewModel()
        {
            Title = "Choose a delivery address";
            LoadItemsCommand = new Command(async () => await ExecuteLoadItemsCommand());
        }
        public Command LoadItemsCommand { get; set; }

        async Task ExecuteLoadItemsCommand() 
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                UserDialogs.Instance.ShowLoading();
                Addresses.Clear();
                GetAddressesResponse response = await App.MenuManager.GetAddresses(new GetAddressesRequest());
                if (response == null)
                {
                    PopupHelper.CreateErrorPopup("Something went wrong");
                    return;
                }
                if (!response.Succeeded)
                    PopupHelper.CreateErrorPopup(response.Message);
                Device.BeginInvokeOnMainThread(() =>
                {
                    if (response.Addresses != null)
                        foreach (var item in response.Addresses)
                        {
                            var vm = new AddressViewModel(item);
                            Addresses.Add(vm);
                        }
                });
                var settingsResponse = await App.MenuManager.GetOrderInfoAsync();
                if (settingsResponse == null)
                    PopupHelper.CreateErrorPopup("Something went wrong");
                else
                    Settings = settingsResponse;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
                UserDialogs.Instance.HideLoading();
            }
            finally
            {
                IsBusy = false;
                UserDialogs.Instance.HideLoading();

            }
        }
    }

}