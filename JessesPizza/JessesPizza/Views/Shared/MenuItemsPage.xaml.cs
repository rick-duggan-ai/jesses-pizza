using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Models;
using JessesPizza.Services;
using JessesPizza.ViewModels;
using Telerik.XamarinForms.DataControls.ListView;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MenuItemsPage : ContentPage
    {
        MenuItemsViewModel viewModel;
        private bool IsBusy;

        public MenuItemsPage(List<JessesMenuItem> items,string itemParentName)
        {
            InitializeComponent();

            Device.BeginInvokeOnMainThread(() =>
            {
                viewModel = new MenuItemsViewModel(items, itemParentName);
                BindingContext = viewModel;
            });
            string fontFamily = GetIconKey();
            var fontImageSource = new FontImageSource() { Glyph = "\uf110", FontFamily = fontFamily };
            ToolbarItems.Add(new ToolbarItem() { IconImageSource = fontImageSource, Command = new Command(ShowShoppingCartPage) });
        }
        private void ShowShoppingCartPage()
        {
            this.Navigation.PushAsync(new ShoppingCartPage());
        }
        async void OnItemSelected(object sender, ItemTapEventArgs args)
        {
            if (IsBusy)
                return;
            IsBusy = true;
            var vm = args.Item as JessesMenuItemViewModel;
            if (vm == null)
                return;

            await Navigation.PushAsync(new SizeSelectionPage(vm.MenuItem));

            // Manually deselect item.
            ItemsListView.SelectedItem = null;
        }

        protected string GetIconKey()
        {
            switch (Device.RuntimePlatform)
            {
                case Device.iOS:
                    return "Material Design Icons";
                    break;
                case Device.Android:
                    return "materialdesignicons-webfont.ttf#Material Design Icons";
                    break;
                default:
                    break;
            }

            return "";
        }
        protected override void OnAppearing()
        {
            base.OnAppearing();
            IsBusy = false;
        }
    }
}
