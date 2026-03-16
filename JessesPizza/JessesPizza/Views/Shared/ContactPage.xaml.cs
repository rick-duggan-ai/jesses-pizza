using JessesPizza.Core.Models;
using JessesPizza.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Essentials;
using Xamarin.Forms;
using Xamarin.Forms.Maps;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ContactPage : ContentPage
    {
        public ContactViewModel _viewModel;
        public ContactPage()
        {
            InitializeComponent();
            BindingContext = _viewModel = new ContactViewModel();

        }
        MainPage RootPage { get => Application.Current.MainPage as MainPage; }
        protected override bool OnBackButtonPressed()
        {
            Device.BeginInvokeOnMainThread(async () => { await RootPage.NavigateFromMenu((int)MenuItemType.MainMenu); });

            return true;
        }
        protected override async void OnAppearing()
        {
            base.OnAppearing();
            await _viewModel.ExecuteLoadItemsCommand();
            JessesPin.InfoWindowClicked += async (s, args) =>
            {
                if (Device.RuntimePlatform == Device.iOS)
                {
                    // https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
                    await Launcher.OpenAsync("http://maps.apple.com/maps?daddr=1450+W+Horizon+Ridge+Pkwy+Henderson,+NV");
                }
                else if (Device.RuntimePlatform == Device.Android)
                {
                    // open the maps app directly
                    await Launcher.OpenAsync("http://maps.google.com/?daddr=1450+W+Horizon+Ridge+Pkwy+Henderson,+NV");
                }
            };
        }

        private async void Button_Clicked(object sender, EventArgs e)
        {
            try { 
            var success = await Launcher.TryOpenAsync(new Uri("fb://page/133494703384"));
            if(!success)
                await Launcher.TryOpenAsync(new Uri("https://www.facebook.com/Jesses-Pizza-133494703384"));
                }
            catch(Exception ex)
            {

            }
        }

        private void TapGestureRecognizer_Tapped(object sender, EventArgs e)
        {
            try
            { 
            PhoneDialer.Open("(702)898-5635");
            }
            catch(Exception ex)
            {

            }
        }
    }
}