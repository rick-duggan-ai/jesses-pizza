using System;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using JessesPizzaKitchen.Views;
using System.Threading.Tasks;
using SQLite;
using JessesPizzaKitchen.Models;
using JessesPizza.Core.Models;
using System.Linq;
using JessesPizza.Core.Models.Identity;
[assembly: XamlCompilation(XamlCompilationOptions.Compile)]
namespace JessesPizzaKitchen
{
    public partial class App : Application
    {
        SQLiteConnection _db;
        public KDSUser _kdsUser;
        public App()
        {
            InitializeComponent();

            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);
            MainPage = new MainPage();
        }


        protected override void OnSleep()
        {
            // Handle when your app sleeps
        }


        protected override void OnResume()
        {
            MessagingCenter.Send(this, "OnResume");
        }

        private async Task<bool> CheckLogin()
        {
            var kdsUser = from f in _db.Table<KDSUser>() select f;
            _kdsUser = kdsUser.FirstOrDefault();
            return true;
            //if(_kdsUser == null)
        }
    }
}
