using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using JessesPizza.Core.Models;
using JessesPizza.Helpers;
using JessesPizza.Models;
using JessesPizza.Services;
using JessesPizza.ViewModels;
using Telerik.XamarinForms.DataControls.ListView;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MainMenuPage : ContentPage
    {
        MainMenuItemsViewModel viewModel;
        private bool IsBusy;
        public MainMenuPage()
        {
            InitializeComponent();
            ItemsListView.IsVisible = false;
            BindingContext = viewModel = new MainMenuItemsViewModel();
            string fontFamily = "";
            switch (Device.RuntimePlatform)
            {
                case Device.iOS:
                    fontFamily = "Material Design Icons";
                    break;
                case Device.Android:
                    fontFamily = "materialdesignicons-webfont.ttf#Material Design Icons";
                        break;
                default:
                    break;
            }
            var fontImageSource = new FontImageSource() { Glyph = "\uf110", FontFamily = fontFamily };
            ToolbarItems.Add(new ToolbarItem() { IconImageSource = fontImageSource, Command = new Command(ShowShoppingCartPage) });
            //MessagingCenter.Send<string>("1", "DisableGesture");
        }
        private void ShowShoppingCartPage()
        {
            this.Navigation.PushAsync(new ShoppingCartPage());
        }

        async void OnItemSelected(object sender, ItemTapEventArgs args)
        {
            if(IsBusy)
                return;
            IsBusy = true;
            var item = args.Item as MainMenuItemViewModel;
            if (item == null) 
                return;
            await Navigation.PushAsync(new MenuItemsPage(item.MenuItems,item.Name));
            // Manually deselect item.
            ItemsListView.SelectedItem = null;
            
        }

        protected async override void OnAppearing()
        {
            viewModel.LoadItemsCommand.Execute(null);
            ItemsListView.ItemsSource = viewModel.MainItems;
            base.OnAppearing();
            if(!ItemsListView.IsVisible)
                ItemsListView.IsVisible = true;
            var hours = await CheckHours();
            IsBusy = false;

        }
        private async Task<bool> CheckHours()
        {
            try
            {
                var service = new MongoService();
                var settings = await service.GetSettings();
                if (settings == null)
                    return false;
                var day = settings.StoreHours.FirstOrDefault()?.Day.ToString();
                var blah = DateTime.Now.DayOfWeek.ToString();
                var hoursToday = settings.StoreHours.FirstOrDefault(x => x.Day.ToString() == DateTime.Now.DayOfWeek.ToString());
                var utc = DateTime.UtcNow;
                TimeZoneInfo pdt = TimeZoneInfo.Local;
                DateTime pdtTime = TimeZoneInfo.ConvertTimeFromUtc(utc, pdt);

                if (!TimeBetween(pdtTime, hoursToday.OpeningTime.Value.TimeOfDay, hoursToday.ClosingTime.Value.TimeOfDay))
                {
                    PopupHelper.CreatePopup("Store is not open", $"Hours today are from {hoursToday.OpeningTime.Value.ToString("h:mm tt")} to {hoursToday.ClosingTime.Value.ToString("h:mm tt")}");
                    return false;
                }
                return true;
            }
            catch (Exception e)
            {
                PopupHelper.CreateErrorPopup($"Unable to reach server");
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