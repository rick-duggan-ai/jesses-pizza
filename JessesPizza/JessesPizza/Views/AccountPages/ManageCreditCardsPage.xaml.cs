using Acr.UserDialogs;
using JessesPizza.Converters;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Helpers;
using JessesPizza.Models;
using JessesPizza.ViewModels;
using SQLite;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ManageCreditCardsPage : ContentPage
    {
        ICommand tapCommand;
        public ICommand TapCommand
        {
            get { return tapCommand; }
        }
        MainPage RootPage { get => Application.Current.MainPage as MainPage; }
        private SqliteTransaction _sqliteTransaction { get; set; }
        private SQLiteConnection _db { get; set; }
        public CreditCardListViewModel _viewModel { get; set; } 
        public bool IsDelivery { get; set; }
        public ManageCreditCardsPage()
        {
            try
            {
                _db = new SQLiteConnection(Constants.SqlLiteDbFolder);
                InitializeComponent();
                tapCommand = new Command(OnTapped);


                _viewModel = new CreditCardListViewModel();

                var creditCardListStackLayout = new StackLayout();
                foreach (var vm in _viewModel.CreditCards)
                {
                    var view = new CreditCardDisplayView(vm);
                    var stack = new StackLayout() { Children = { view } };
                    stack.GestureRecognizers.Add(new TapGestureRecognizer() { Command = tapCommand, CommandParameter = vm.Id });
                    creditCardListStackLayout.Children.Add(stack);
                }
                CardView.Content = creditCardListStackLayout;
            }
            catch (Exception e)
            {

            }
        }
        protected async override void OnAppearing()
        {
            base.OnAppearing();
            await _viewModel.ExecuteLoadItemsCommand();

            if (_viewModel.CreditCards == null | _viewModel.CreditCards.Count == 0)
                EmptyLabel.IsVisible = true;
            else
            {
                var creditCardListStackLayout = new StackLayout();
                foreach (var vm in _viewModel.CreditCards)
                {
                    var view = new CreditCardDisplayView(vm);
                    var stack = new StackLayout() { Children = { view } };
                    stack.GestureRecognizers.Add(new TapGestureRecognizer() { Command = tapCommand, CommandParameter = vm.Id });
                    creditCardListStackLayout.Children.Add(stack);
                }
                CardView.Content = creditCardListStackLayout;
            }
        }
        private async void OnTapped(object s)
        {
            try
            {
                var vm = _viewModel.CreditCards.FirstOrDefault(x => x.Id == (Guid)s);
                if (vm != null)
                {
                    string action = await DisplayActionSheet($"Card ending with {vm.CardNumber.Substring(Math.Max(0, vm.CardNumber.Length - 4))}", "Cancel", null, "Delete card");
                    if (action == "Delete card")
                    {
                        string deleteAction = await DisplayActionSheet($"Are you sure you want to delete card ending with {vm.CardNumber.Substring(Math.Max(0, vm.CardNumber.Length - 4))}?", "Cancel", null, "Yes", "No");
                        if (deleteAction == "Yes")
                        {
                            var request = new DeleteCreditCardRequest() { CreditCardId = vm.Id };
                            DeleteCreditCardResponse response = await App.MenuManager.DeleteCreditCard(request);
                            if (response.Succeeded) //reload and add back to view
                            {
                                PopupHelper.CreatePopup("Successfully removed card","");
                                await _viewModel.ExecuteLoadItemsCommand();
                                var creditCardListStackLayout = new StackLayout();
                                if (_viewModel.CreditCards == null | _viewModel.CreditCards.Count == 0)
                                    EmptyLabel.IsVisible = true;

                                foreach (var ccViewModel in _viewModel.CreditCards)
                                {
                                    var view = new CreditCardDisplayView(ccViewModel);
                                    var stack = new StackLayout() { Children = { view } };
                                    stack.GestureRecognizers.Add(new TapGestureRecognizer() { Command = tapCommand, CommandParameter = ccViewModel.Id });
                                    creditCardListStackLayout.Children.Add(stack);
                                }
                                CardView.Content = creditCardListStackLayout;
                            }
                            else
                            {
                                PopupHelper.CreatePopup("Uh-oh!", $"{response.Message}");
                            }
                        }
                        else
                            return;
                    }
                }
                UserDialogs.Instance.HideLoading();

            }
            catch (Exception e)
            {
                PopupHelper.CreatePopup("Uh-oh!", $"Unable to process transaction");
                UserDialogs.Instance.HideLoading();

            }
        }
    }
}