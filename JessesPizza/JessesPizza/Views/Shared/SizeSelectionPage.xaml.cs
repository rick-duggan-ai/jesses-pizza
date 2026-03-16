using JessesPizza.Core.Models;
using JessesPizza.ViewModels;
using System;
using System.Linq;
using JessesPizza.Helpers;
using Telerik.XamarinForms.Primitives;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class SizeSelectionPage : ContentPage
    {
        private JessesItemSize _selectedSize = new JessesItemSize();
        public SizeSelectionViewModel _viewModel;
        public bool buttonPressed = false;
        public JessesMenuItem _menuItem;
        public SizeSelectionPage(JessesMenuItem menuItem)
        {
            _menuItem = menuItem;
            _viewModel = new SizeSelectionViewModel(menuItem);
            InitializeComponent();
            BindingContext = _viewModel ;
            SizeView.SelectionChanged += RadListView_SelectionChanged;
            SizeView.ItemsSource = _viewModel.SizeList;
        }
        private void RadListView_SelectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e)
        {
            if (e.OldItems != null)
            {
                foreach (var item in e.OldItems)
                {
                    (item as SizeViewModel).IsSelected = false;
                }
            }

            if (e.NewItems != null)
            {
                foreach (var item in e.NewItems)
                {
                    foreach (var size in _viewModel.SizeList)
                    {
                        size.IsSelected = false;
                    }
                    (item as SizeViewModel).IsSelected = true;

                }
            }
        }
        protected override void OnAppearing()
        {
            base.OnAppearing();
            buttonPressed = false;
            _selectedSize = _menuItem.Sizes.Where(x=>x.Id == _viewModel.defaultSize.Id).FirstOrDefault();
            var defaultSize = _viewModel.SizeList.Where(x => x.Id == _viewModel.defaultSize.Id).FirstOrDefault();
            if (defaultSize != null)
            defaultSize.IsSelected = true;
            var allSizes = _viewModel.SizeList.Where(x => x.IsSelected == true).ToList();
            foreach (var sizeVM in allSizes)
            {
                if (sizeVM.Id != _selectedSize.Id && sizeVM.IsSelected == true)
                    sizeVM.IsSelected = false;
            }
        }

        private async void continueButton_Clicked(object sender, EventArgs e)
        {
            if(!buttonPressed)
            { 
            buttonPressed = true;
            if (_selectedSize != null)
                await Navigation.PushAsync(new MenuItemDetailPage(_viewModel.MenuItem, _selectedSize));
            else
                PopupHelper.CreateErrorPopup("Please select a size to continue");
                buttonPressed = false;
            }
        }

        private void SizeView_ItemTapped(object sender, Telerik.XamarinForms.DataControls.ListView.ItemTapEventArgs e)
        {
            var size = e.Item as SizeViewModel;
            if (size.IsSelected)
            { 
                size.IsSelected = false;
                _selectedSize = null;
            }
            else
            { 
                size.IsSelected = true;
                _selectedSize = _menuItem.Sizes.Where(x=>x.Id == size.Id).FirstOrDefault();
            }
            var selectedSizes = _viewModel.SizeList.Where(x => x.IsSelected == true).ToList();
            foreach (var sizeVM in selectedSizes)
            {
                if (sizeVM.Id != size.Id )
                    sizeVM.IsSelected = false;
            }

        }
    }
}