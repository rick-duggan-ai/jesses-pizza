using System;
using System.Collections.Generic;
using System.Linq;
using JessesPizza.Core.Models;
using JessesPizzaKitchen.Models;
using JessesPizzaKitchen.ViewModels;
using SQLite;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using HomeMenuItem = JessesPizzaKitchen.Models.HomeMenuItem;
using MenuItemType = JessesPizzaKitchen.Models.MenuItemType;

namespace JessesPizzaKitchen.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MenuPage : ContentPage
    {
        SQLiteConnection _db;

        MainPage RootPage { get => Application.Current.MainPage as MainPage; }
        List<HomeMenuItem> menuItems;
        private MenuViewModel _viewModel;
        public MenuPage()
        {
            menuItems = new List<HomeMenuItem>
            {
                new HomeMenuItem {Id = MenuItemType.MainPage, Title="Main Page" },
                //new HomeMenuItem {Id = MenuItemType.Settings, Title="Settings" }
            };
            BindingContext = _viewModel = new MenuViewModel(menuItems);
            InitializeComponent();

            ListViewMenu.ItemsSource = _viewModel.Pages;

            ListViewMenu.SelectedItem = _viewModel.Pages[0];
            ListViewMenu.ItemSelected += async (sender, e) =>
            {
                if (e.SelectedItem == null)
                    return;

                var id = (int)((HomeMenuItem)e.SelectedItem).Id;
                await RootPage.NavigateFromMenu(id);
            };

            MessagingCenter.Subscribe<OrdersPage>(this, "OnLogin", (sender) =>
            {
                _viewModel.IsLoggedIn = true;
            });
            MessagingCenter.Subscribe<OrdersPage>(this, "OnLogout", async app =>
            {
                _viewModel.IsLoggedIn = false;
            });
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);

        }

        //private async System.Threading.Tasks.Task TapGestureRecognizer_TappedAsync(object sender, EventArgs e)
        //{
        //    await Navigation.PushModalAsync(new LoginPage());
        //}

        private async void TapGestureRecognizer_TappedAsync(object sender, EventArgs e)
        {
            _db.CreateTable<KDSUserSQL>();

            var kdsUsers = from f in _db.Table<KDSUserSQL>() select f;
            foreach (var user in kdsUsers)
            {
                _db.Delete(user);
            }
            _viewModel.IsLoggedIn = false;
            await Navigation.PushModalAsync(new LoginPage());
        }

    }
}