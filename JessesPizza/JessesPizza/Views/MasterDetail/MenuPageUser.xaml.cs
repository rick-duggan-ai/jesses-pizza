using JessesPizza.Models;
using System;
using System.Collections.Generic;
using JessesPizza.Core.Models;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using Xamarin.Essentials;
using JessesPizza.ViewModels;
using JessesPizza.Core.Models.Transactions;
using SQLite;
using JessesPizza.Services;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MenuPageUser : ContentPage
    {
        MainPage RootPage { get => Application.Current.MainPage as MainPage; }
        MenuPageUserViewModel _viewModel;

        public MenuPageUser()
        {
            InitializeComponent();
            _viewModel = new MenuPageUserViewModel();
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
            MessagingCenter.Send<MenuPageUser, string>(this, "Logout", "Test");
        }

        private async void LogoutButton_Clicked(object sender, EventArgs e)
        {
            
            string action = await DisplayActionSheet("Are you sure you want to log out?", "Cancel", null, "Yes", "No");
            if (action == "Yes")
            {
                SecureStorage.Remove("oauth_token");
                SecureStorage.Remove("oauth_token_expiration");
                SecureStorage.Remove("oauth_token_is_guest");
                var db = new SQLiteConnection(Constants.SqlLiteDbFolder);
                db.DeleteAll<OrderTotals>();
                db.DeleteAll<ShoppingCartItem>();
                App.Current.MainPage = new NavigationPage(new HomeScreen());

                App.MenuManager._mongoService = new MongoService();
            }
            else if (action == "No")
            {
                return;
            }
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