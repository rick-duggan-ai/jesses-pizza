using System;
using System.Linq;
using System.Threading.Tasks;
using JessesPizza.Models;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using JessesPizza.Services;
using JessesPizza.Views;
using System.Collections.ObjectModel;
using JessesPizza.Helpers;
using static JessesPizza.Helpers.IEnvironment;
using Telerik.XamarinForms.Primitives;
using SQLite;
using Acr.UserDialogs;
using JessesPizza.Core.Models;
using Xamarin.Essentials;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Views.AccountPages;
//[assembly: ExportFont("italiana-regular.otf",Alias ="pizzaFont")]
//[assembly: ExportFont("Italianno-Regular-OTF.otf", Alias = "pizzaFont")]

[assembly: XamlCompilation(XamlCompilationOptions.Compile)]
namespace JessesPizza
{
    public partial class App : Application
    {
        public static MenuItemManager MenuManager { get; private set; }
        public ObservableCollection<ThemeColors> ThemeColors { get; set; }
        public Theme AppTheme { get; set; }
        private SQLiteConnection _db;
        private AppUser _user;


        public bool UserLoggedIn {get;set; } = false;
        public App()
        {
            InitializeComponent();
            MenuManager = new MenuItemManager(new MongoService());
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);

            MessagingCenter.Subscribe<string>(this, "TokenExpired", (sender) =>
            {
                MainPage = new NavigationPage(new HomeScreen());
            });
        }

        protected override async void OnStart()
        {
            base.OnStart();
            UserLoggedIn = await CheckUser();
            if (UserLoggedIn) // Check if user is logged in
            {
                if (_user != null) //if true make sure user object is filled up 
                {
                    if (_user.IsGuest) //if user is guest show appropriate .
                    {
                        var mainMenu = new NavigationPage(new MainMenuPage());
                        var master = new MenuPageGuest();
                        var mainPage = new MainPage() { Detail = mainMenu, Master = master };
                        MainPage = mainPage;
                    }
                    else
                        MainPage = new MainPage() { Detail = new NavigationPage(new MainMenuPage()), Master = new MenuPageUser() };
                }
                else
                    MainPage = new NavigationPage(new HomeScreen());
            }
            else
                MainPage = new NavigationPage(new HomeScreen());
            //await CheckHours();
            SetTheme(Theme.Light);
        }

        protected override void OnSleep()
        {
            // Handle when your app sleeps
        }

        protected override async void OnResume()
        {
            base.OnStart();
        }


        void SetTheme(Theme theme)
        {
            if (theme == Theme.Light)
                ThemeColors = new ObservableCollection<ThemeColors>() { new ThemeColors() { BackgroundColor = new Color(1, 1, 1), FontColor = new Color(0, 0, 0) } };
            else
                ThemeColors = new ObservableCollection<ThemeColors>() { new ThemeColors() { BackgroundColor = new Color(1, 1, 1), FontColor = new Color(0, 0, 0) } };

        }
        private async Task<bool> CheckUser()
        {
            try
            {
                if (_user == null)
                {
                    var oauthToken = await SecureStorage.GetAsync("oauth_token");
                    var oauthTokenExpiration = await SecureStorage.GetAsync("oauth_token_expiration");
                    var oauthTokenIsGuest = await SecureStorage.GetAsync("oauth_token_is_guest");
                    if (!string.IsNullOrEmpty(oauthToken) && !string.IsNullOrEmpty(oauthTokenExpiration) && !string.IsNullOrEmpty(oauthTokenIsGuest))
                        _user = new AppUser() { IsGuest = bool.Parse(oauthTokenIsGuest), Token = oauthToken, TokenExpires = DateTime.Parse(oauthTokenExpiration) };
                }
                if (_user == null)
                    return false;
                if (string.IsNullOrEmpty(_user.Token))
                    return false;
                if (_user.TokenExpires < DateTime.Now)
                    return false;
                return true;
            }
            catch
            {
                PopupHelper.CreatePopup("Uh-oh!", $"Unable to reach server");
                return false;
            }
        }
    }
}
