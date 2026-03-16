using System;
using JessesPizza.Core.Models;
using JessesPizza.Models;
using JessesPizza.Services;
using JessesPizza.ViewModels;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class AboutPage : ContentPage
    {
        AboutViewModel _viewModel;
        public AboutPage()
        {
            
            InitializeComponent();
            BindingContext = _viewModel = new AboutViewModel();
        }
        MainPage RootPage { get => Application.Current.MainPage as MainPage; }
        protected override bool OnBackButtonPressed()
        {
            Device.BeginInvokeOnMainThread(async () => { await RootPage.NavigateFromMenu((int)MenuItemType.MainMenu); });

            return true;
        }
        protected async override void OnAppearing()
        {
            base.OnAppearing();
            await _viewModel.ExecuteLoadItemsCommand();
        }

    }
}