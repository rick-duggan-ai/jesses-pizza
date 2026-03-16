using JessesPizza.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MainPage : MasterDetailPage
    {
        Dictionary<int, NavigationPage> MenuPages = new Dictionary<int, NavigationPage>();
        public MainPage()
        {
            InitializeComponent();

            MasterBehavior = MasterBehavior.Popover;

            MenuPages.Add((int)MenuItemType.Menu, (NavigationPage)Detail);

        }

        public async Task NavigateFromMenu(int id)
        {
            if (!MenuPages.ContainsKey(id))
            {
                switch (id)
                {

                    case (int)MenuItemType.MainMenu:
                        MenuPages.Add(id, new NavigationPage(new MainMenuPage()));
                        break;
                    case (int)MenuItemType.Contact:
                        MenuPages.Add(id, new NavigationPage(new ContactPage()));
                        break;
                    case (int)MenuItemType.About:
                        MenuPages.Add(id, new NavigationPage(new AboutPage()));
                        break;
                    case (int)MenuItemType.Orders:
                        MenuPages.Add(id, new NavigationPage(new OrdersPage()));
                        break;
                    case (int)MenuItemType.Account:
                        MenuPages.Add(id, new NavigationPage(new AccountPage()));
                        break;
                }
            }

            var newPage = MenuPages[id];

            if (newPage != null && Detail != newPage)
            {
                Detail = newPage;

                //if (Device.RuntimePlatform == Device.Android)
                //    await Task.Delay(100);

                IsPresented = false;
            }
        }

    }
}