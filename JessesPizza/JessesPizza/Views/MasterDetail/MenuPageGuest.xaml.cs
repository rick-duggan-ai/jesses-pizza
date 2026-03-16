using JessesPizza.Models;
using System;
using System.Collections.Generic;
using JessesPizza.Core.Models;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using Xamarin.Essentials;
using JessesPizza.ViewModels;
using JessesPizza.Services;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MenuPageGuest : ContentPage
    {
        MainPage RootPage { get => Application.Current.MainPage as MainPage; }
        MenuPageGuestViewModel _viewModel;

        public MenuPageGuest()
        {
            InitializeComponent();
            _viewModel = new MenuPageGuestViewModel();
            BindingContext = _viewModel;
            ListViewMenu.ItemsSource = _viewModel.HomeMenuItems;
        }
        protected override void OnAppearing()
        {
            base.OnAppearing();
        }
        private void LoginButton_Clicked(object sender, EventArgs e)
        {
            SecureStorage.Remove("oauth_token");
            SecureStorage.Remove("oauth_token_expiration");
            SecureStorage.Remove("oauth_token_is_guest");
            App.Current.MainPage = new NavigationPage(new HomeScreen());
            App.MenuManager._mongoService = new MongoService();
        }
        private async void ListViewMenu_ItemSelected(object sender, SelectedItemChangedEventArgs e)
        {
            if (e.SelectedItem == null)
                return;

            var id = (int)((HomeMenuItem)e.SelectedItem).Id;
            await RootPage.NavigateFromMenu(id);
        }
    }
}