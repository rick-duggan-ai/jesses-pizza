using Flurl.Http;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity;
using JessesPizzaKitchen.Models;
using JessesPizzaKitchen.ViewModels;
using SQLite;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Telerik.XamarinForms.Primitives;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizzaKitchen.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class LoginPage : ContentPage
    {
        SQLiteConnection _db;
        public bool IsBusy;
        private LoginViewModel _viewModel;
        public LoginPage()
        {
            InitializeComponent();

            BindingContext = _viewModel = new LoginViewModel();
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);
            
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();
            MessagingCenter.Send(this, "OnResume");
            IsBusy = false;
        }
        private async void Login_ClickedAsync(object sender, EventArgs e)
        {
            if(IsBusy)
                return;
            IsBusy = true;
            try { 
            KDSUser user = new KDSUser() { Password = _viewModel.Password, Username = _viewModel.UserName };
            var blah = await Constants.LoginAddress.PostJsonAsync(user);
            if (blah.StatusCode == System.Net.HttpStatusCode.OK)
                {
                    var kdsUserSql = new KDSUserSQL() { Username = user.Username, Password = user.Password };
                    _db.Insert(kdsUserSql);
                    MessagingCenter.Send(this, "OnLogin");
                    await Navigation.PopModalAsync();
                    return;
                }
                else
                CreatePopupForInvalidForm("Incorrect username or password");
                IsBusy = false;
            }
            catch(Exception ex)
            {
                CreatePopupForInvalidForm("Incorrect username or password");
                IsBusy = false;
            }
        }
        private void CreatePopupForInvalidForm(string text)
        {
            var validationPopup = new RadPopup { IsModal = true, OutsideBackgroundColor = Color.FromHex("#6F000000") };
            var containerGrid = new Grid { Padding = 20 };
            containerGrid.RowDefinitions.Add(new RowDefinition { Height = new GridLength(30) });
            containerGrid.RowDefinitions.Add(new RowDefinition { Height = new GridLength(20) });
            containerGrid.Children.Add(new Label { Text = text });

            var hidePopupBtn = new Button { Padding = new Thickness(2), HorizontalOptions = LayoutOptions.Center, Text = "Return to Form" };
            hidePopupBtn.SetValue(Grid.RowProperty, 2);
            hidePopupBtn.Clicked += delegate (object sender, EventArgs args) { validationPopup.IsOpen = false; };
            containerGrid.Children.Add(hidePopupBtn);
            var border = new RadBorder { CornerRadius = new Thickness(8), BackgroundColor = Color.Wheat };
            border.Content = containerGrid;
            validationPopup.Content = border;
            validationPopup.IsOpen = true;
            validationPopup.Placement = PlacementMode.Center;
        }

    }
}