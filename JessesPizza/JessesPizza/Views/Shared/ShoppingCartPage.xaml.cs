using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Acr.UserDialogs;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Helpers;
using JessesPizza.Models;
using JessesPizza.Services;
using JessesPizza.ViewModels;
using SQLite;
using Telerik.XamarinForms.Primitives;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class ShoppingCartPage : ContentPage
    {
        ShoppingCartViewModel _viewModel;
        SQLiteConnection _db;

        public bool IsBusy { get; set; }

        public ShoppingCartPage()
        {
            BindingContext = _viewModel = new ShoppingCartViewModel();
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);
            InitializeComponent();

        }
        protected override async void OnAppearing()
        {
            base.OnAppearing();
            IsBusy = false;
            await _viewModel.ExecuteLoadItemsCommand();
            if (_viewModel.TaxRate == 0)
                PopupHelper.CreateErrorPopup("Couldn't reach server");
        }

        private async void delete_button_Clicked(object sender, EventArgs e)
        {

            Device.BeginInvokeOnMainThread(async () =>
            {
                if (IsBusy)
                    return;
                    IsBusy = true;
                    var cartItem = _viewModel.ShoppingItems.First(item =>
                        item.Id == int.Parse((sender as Button).CommandParameter.ToString()));
                    if (cartItem == null)
                        return;
                    if (!_viewModel.ShoppingItems.Contains(cartItem))
                        return;
                    var db = new SQLiteConnection(Constants.SqlLiteDbFolder);
                    db.Delete(cartItem);

                    _viewModel.ShoppingItems.Remove(cartItem);
                    if (_viewModel.ShoppingItems.Count == 0)
                        _viewModel.IsEmpty = true;
                    await _viewModel.ExecuteLoadItemsCommand();
                    IsBusy = false;
            });
        }

        private async void edit_button_Clicked(object sender, EventArgs e)
        {
            Device.BeginInvokeOnMainThread(async () =>
            {
                if (!IsBusy)
                {
                    IsBusy = true;
                    var cartItem = _viewModel.ShoppingItems.First(item =>
                        item.Id == int.Parse((sender as Button).CommandParameter.ToString()));
                    if (cartItem == null)
                        return;
                    var jessesMenuItem = await LoadItemForEdit(cartItem.MenuItemId);
                    if (jessesMenuItem == null)
                        return;
                    var selectedSize = jessesMenuItem.Sizes.FirstOrDefault(x => x.Id == cartItem.SelectedSizeId);
                    var editMenuItem = new MenuItemEditViewModel(jessesMenuItem, selectedSize);
                    editMenuItem.Item = jessesMenuItem;
                    editMenuItem.SelectedSize = selectedSize;
                    editMenuItem.Quantity = cartItem.Quantity;
                    editMenuItem.IsEdit = true;
                    editMenuItem.ShoppingCartId = cartItem.Id;
                    var service = new MongoService();
                    var allGroups = await service.GetGroupsAsync();

                    List<GroupItemViewModel> selectedRequiredItems = new List<GroupItemViewModel>();
                    List<GroupItemViewModel> selectedOptionalItems = new List<GroupItemViewModel>();
                    if (!string.IsNullOrWhiteSpace(cartItem.RequiredDelimitedString))
                    {
                        string[] words = cartItem.RequiredDelimitedString.Split(',');
                        foreach (var word in words)
                        {
                            var trim = word.TrimStart();
                            foreach (var groupId in selectedSize.GroupIds)
                            {
                                var group = allGroups.Where(x => x.Id == groupId).FirstOrDefault();
                                string[] parameters = trim.Split('/');
                                var requiredGroupItem = group.Items.FirstOrDefault(x => x.Id == parameters[0]);
                                if (requiredGroupItem != null)
                                {
                                    GroupItemViewModel vm;
                                    if (parameters.Count() == 1)
                                    {
                                        vm = new GroupItemViewModel(requiredGroupItem, true);
                                    }
                                    else
                                    {
                                        vm = new GroupItemViewModel(requiredGroupItem, true)
                                            {SizeLabelText = parameters[1]};
                                        if (parameters.Count() > 2)
                                        {
                                            vm.SideLabelText = parameters[2];
                                        }
                                    }

                                    selectedRequiredItems.Add(vm);
                                }
                            }
                        }
                    }

                    if (!string.IsNullOrWhiteSpace(cartItem.OptionalDelimitedString))
                    {
                        string[] words = cartItem.OptionalDelimitedString.Split(',');
                        foreach (var word in words)
                        {
                            var trim = word.TrimStart();
                            foreach (var groupId in selectedSize.GroupIds)
                            {
                                var group = allGroups.Where(x => x.Id == groupId).FirstOrDefault();
                                string[] parameters = trim.Split('/');
                                var optionalGroupItem = group.Items.FirstOrDefault(x => x.Id == parameters[0]);
                                if (optionalGroupItem != null)
                                {
                                    GroupItemViewModel vm;
                                    if (parameters.Count() == 1)
                                    {
                                        vm = new GroupItemViewModel(optionalGroupItem, false);
                                    }
                                    else
                                    {
                                        vm = new GroupItemViewModel(optionalGroupItem, false)
                                            {SizeLabelText = parameters[1]};
                                        if (parameters.Count() > 2)
                                        {
                                            vm.SideLabelText = parameters[2];
                                        }
                                    }

                                    selectedOptionalItems.Add(vm);
                                }
                            }
                        }
                    }

                    editMenuItem.SpecialInstructions = cartItem.Instructions;
                    await Navigation.PushAsync(new MenuItemDetailPage(editMenuItem, selectedSize, selectedRequiredItems,
                        selectedOptionalItems));
                }
            });
        }


        private async void checkout_button_Clicked(object sender, EventArgs e)
        {
            if (IsBusy)
                return;
            try
            {
                IsBusy = true;
                if(_viewModel.SubTotal == 0)
                {
                    IsBusy = false;
                    return;
                }
                var hours = await CheckHours();
                if (!hours)
                    return;
                decimal tip = 0;
                string action = await DisplayActionSheet("Add a tip?", "Cancel", null, $"20% - {(_viewModel.SubTotal * 0.20M).ToString("C")}", $"22% - {(_viewModel.SubTotal * 0.22M).ToString("C")}", $"25% - {(_viewModel.SubTotal * 0.25M).ToString("C")}", "Custom", "No Tip");
                if (action == "Cancel" || string.IsNullOrEmpty(action))
                {
                    IsBusy = false;
                    return;
                }
                if (action == $"20% - {(_viewModel.SubTotal * 0.20M).ToString("C")}")
                {
                    tip = _viewModel.SubTotal * 0.20M;
                }
                else if (action == $"22% - {(_viewModel.SubTotal * 0.22M).ToString("C")}")
                {
                    tip = _viewModel.SubTotal * 0.22M;
                }
                else if (action == $"25% - {(_viewModel.SubTotal * 0.25M).ToString("C")}")
                {
                    tip = _viewModel.SubTotal * 0.25M;
                }
                else if (action == "Custom")
                {
                    PromptResult pResult = await UserDialogs.Instance.PromptAsync(new PromptConfig
                    {
                        InputType = InputType.DecimalNumber,
                        OkText = "Ok",
                        Title = "Custom tip amount"
                    });
                    if (pResult.Ok && !string.IsNullOrWhiteSpace(pResult.Text))
                    {
                        var check = decimal.TryParse(pResult.Text, out tip);
                        if (!check)
                        {
                            PopupHelper.CreateErrorPopup("Invalid tip amount");
                            IsBusy = false;
                            return;
                        }
                            
                        
                    }
                    if (!pResult.Ok)
                    {
                        IsBusy = false;
                        return;

                    }
                }
                var total = Decimal.Round(_viewModel.Total, 2);
                _db.CreateTable<OrderTotals>();
                var existingTotals = from t in _db.Table<OrderTotals>() select t;
                if (existingTotals.Count() != 0)
                    _db.DeleteAll<OrderTotals>();
                _db.Insert(new OrderTotals()
                {
                    SubTotal = _viewModel.SubTotal,
                    Total = total + tip,
                    DeliveryCharge = 0.00m,
                    TaxTotal = _viewModel.TaxTotal,
                    Tip = tip
                });
                decimal newTotal = total + tip;
                await Navigation.PushAsync(new DeliveryOrPickupPage());
            }
            catch (Exception exception)
            {
                PopupHelper.CreateErrorPopup("Something went wrong");
                IsBusy = false;
            }
        }

        public async Task<JessesMenuItem> LoadItemForEdit(string id)
        {
            try
            {

                var service = new MongoService();
                var items = await service.GetMainMenuItemsAsync();
                foreach (var item in items)
                {
                    var menuItem = item.MenuItems.FirstOrDefault(mi => mi.Id == id);
                    if (menuItem != null)
                        return menuItem;
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
                return null;

            }
        }
        private async Task<bool> CheckHours()
        {
            try
            {
                var service = new MongoService();
                var settings = await service.GetSettings();
                var day = settings.StoreHours.FirstOrDefault()?.Day.ToString();
                var blah = DateTime.Now.DayOfWeek.ToString();
                var hoursToday = settings.StoreHours.FirstOrDefault(x => x.Day.ToString() == DateTime.Now.DayOfWeek.ToString());
                var utc = DateTime.UtcNow;
                TimeZoneInfo pdt = TimeZoneInfo.Local;
                DateTime pdtTime = TimeZoneInfo.ConvertTimeFromUtc(utc, pdt);

                if (!TimeBetween(pdtTime, hoursToday.OpeningTime.Value.TimeOfDay, hoursToday.ClosingTime.Value.TimeOfDay))
                {
                    PopupHelper.CreatePopup("Store is not open", $"Hours today are from {hoursToday.OpeningTime.Value.ToString("h:mm tt")} to {hoursToday.ClosingTime.Value.ToString("h:mm tt")}");
                    IsBusy = false;
                    return false;

                }
                return true;
            }
            catch (Exception e)
            {
                PopupHelper.CreateErrorPopup($"Unable to reach server");
                IsBusy = false;
                return false;
            }
        }
        private bool TimeBetween(DateTime datetime, TimeSpan start, TimeSpan end)
        {
            // convert datetime to a TimeSpan
            TimeSpan now = datetime.TimeOfDay;
            // see if start comes before end
            if (start < end)
                return start <= now && now <= end;
            // start is after end, so do the inverse comparison
            return !(end < now && now < start);
        }
    }
}