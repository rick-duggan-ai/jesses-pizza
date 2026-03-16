using System;
using System.Windows.Input;

using Xamarin.Forms;
using Xamarin.Essentials;
using System.Threading.Tasks;
using System.Diagnostics;
using JessesPizza.Core.Models;

namespace JessesPizza.ViewModels
{
    public class AboutViewModel : BaseViewModel
    {
        public JessesPizzaSettings Settings { get; set; }

        public AboutViewModel()
        {
            Title = "About";

            OpenWebCommand = new Command(async async => await  Launcher.OpenAsync(new Uri("https://www.JessesPizza.com")));
        }
        private string _aboutString;
        public string AboutString
        {
            get => _aboutString;
            set
            {
                _aboutString = value;
                OnPropertyChanged();
            }
        }
        public ICommand OpenWebCommand { get; }
        public async Task ExecuteLoadItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                var info = await App.MenuManager.GetOrderInfoAsync();
                if (info != null)
                {
                    Settings = info;
                    AboutString = Settings.AboutText;
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
            }
            finally
            {
                IsBusy = false;
            }
        }
    }

}