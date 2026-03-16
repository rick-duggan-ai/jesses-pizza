using Acr.UserDialogs;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace JessesPizza.ViewModels
{
    public class PrivacyPolicyViewModel : BaseViewModel
    {
        public PrivacyPolicyViewModel()
        {
            Title = "Privacy Policy";
            LoadItemsCommand = new Command(async () => await ExecuteLoadItemsCommand());

        }
        public Command LoadItemsCommand { get; set; }

        private string _privacyString;
        public string PrivacyString
        {
            get => _privacyString;
            set
            {
                _privacyString = value;
                OnPropertyChanged();
            }
        }
        private bool _agreed;
        public bool Agreed
        {
            get => _agreed;
            set
            {
                _agreed = value;
                OnPropertyChanged();
            }
        }
        private async Task ExecuteLoadItemsCommand()
        {

            if (IsBusy)
                return;
            UserDialogs.Instance.ShowLoading("Loading", MaskType.Black);
            IsBusy = true;

            try
            {
                PrivacyString = null;
                var privacy = await App.MenuManager.GetPrivacyAsync();

                Device.BeginInvokeOnMainThread(() =>
                {
                    if (privacy != null)
                        PrivacyString = privacy;
                });
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
            }
            finally
            {
                IsBusy = false;
                UserDialogs.Instance.HideLoading();
            }
        }
    }
}
