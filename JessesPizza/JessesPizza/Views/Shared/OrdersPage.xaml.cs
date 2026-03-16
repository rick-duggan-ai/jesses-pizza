using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Models;
using JessesPizza.ViewModels;
using SQLite;
using Telerik.XamarinForms.Primitives;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class OrdersPage : ContentPage
    {
        OrdersViewModel _viewModel;

        public OrdersPage()
        {
            InitializeComponent();
            BindingContext = _viewModel = new OrdersViewModel();
        }
        MainPage RootPage { get => Application.Current.MainPage as MainPage; }
        protected override bool OnBackButtonPressed()
        {
            Device.BeginInvokeOnMainThread(async () => {  await RootPage.NavigateFromMenu((int)MenuItemType.MainMenu); });

            return true;
        }

        protected override void OnAppearing()
        {
            base.OnAppearing();
            _viewModel.LoadItemsCommand.Execute(null);
        }
    }
}
