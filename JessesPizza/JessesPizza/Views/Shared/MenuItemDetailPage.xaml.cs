using JessesPizza.Core.Models;
using JessesPizza.Helpers;
using JessesPizza.Models;
using JessesPizza.Styles;
using JessesPizza.ViewModels;
using SQLite;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using Telerik.XamarinForms.Common;
using Telerik.XamarinForms.DataControls;
using Telerik.XamarinForms.DataControls.ListView;
using Telerik.XamarinForms.Primitives;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;
using SelectionMode = Telerik.XamarinForms.DataControls.ListView.SelectionMode;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class MenuItemDetailPage : ContentPage
    {
        readonly MenuItemEditViewModel _viewModel;
        private JessesItemSize _selectedSize;
        public ObservableCollection<GroupItemViewModel> SelectedRequiredGroupItems { get; set; } = new ObservableCollection<GroupItemViewModel>();
        public ObservableCollection<GroupItemViewModel> SelectedOptionalGroupItems { get; set; } = new ObservableCollection<GroupItemViewModel>();
        public bool IsBusy;
        public MenuItemDetailPage(JessesMenuItem menuItem, JessesItemSize selectedSize)
        {
            _viewModel = new MenuItemEditViewModel(menuItem, selectedSize);
            _viewModel.IsEdit = false;
            if (_viewModel.AllGroupItems == null)
                _viewModel.ListEmpty = true;
            else if (_viewModel.AllGroupItems.Count == 0)
                _viewModel.ListEmpty = true;
            InitializeComponent();
            listView.IsVisible = false;
            listView.SelectedItemStyle = null;
            listView.ItemStyle = null;
            listView.SelectionMode = SelectionMode.None;
            _selectedSize = selectedSize;
            BindingContext = this._viewModel;
            listView.BindingContext = _viewModel;
            listView.SortDescriptors.Add(new Telerik.XamarinForms.DataControls.ListView.PropertySortDescriptor { PropertyName = "GroupName", SortOrder = SortOrder.Ascending });
            _viewModel.ButtonText = "ADD TO CART";

            if (_viewModel.Quantity == 0)
                _viewModel.Quantity = 1;
            _viewModel.Quantity = _viewModel.Quantity;
            int i = 0;
            DelegateGroupDescriptor delegateDescriptor = new DelegateGroupDescriptor
            {
                KeyExtractor = GroupKeyExtractor
            };
            listView.GroupDescriptors.Add(delegateDescriptor);

        }
        public MenuItemDetailPage(MenuItemEditViewModel viewModel, JessesItemSize selectedSize, List<GroupItemViewModel> selectedRequiredItems, List<GroupItemViewModel> selectedOptionalItems)
        {
            _viewModel = viewModel;
            SelectedRequiredGroupItems = new ObservableCollection<GroupItemViewModel>(selectedRequiredItems);
            SelectedOptionalGroupItems = new ObservableCollection<GroupItemViewModel>(selectedOptionalItems);

            InitializeComponent();
            listView.IsVisible = false;
            listView.SelectedItemStyle = null;
            listView.ItemStyle = null;
            listView.SelectionMode = SelectionMode.None;
            _selectedSize = selectedSize;
            BindingContext = this._viewModel;
            listView.BindingContext = _viewModel;
            listView.SortDescriptors.Add(new Telerik.XamarinForms.DataControls.ListView.PropertySortDescriptor { PropertyName = "GroupName", SortOrder = SortOrder.Ascending });
            _viewModel.ButtonText = "SAVE";
            DelegateGroupDescriptor delegateDescriptor = new DelegateGroupDescriptor
            {
                KeyExtractor = GroupKeyExtractor
            };
            listView.GroupDescriptors.Add(delegateDescriptor);
        }

        private object GroupKeyExtractor(object arg)
        {
            var converItem = arg as GroupItemViewModel;
            return string.Concat(converItem?.GroupListIndex.ToString(), "<", converItem?.GroupName, "<", converItem.GroupImageUrlString);
        }
        protected override void OnAppearing()
        {
            base.OnAppearing();
            //_viewModel.LoadItemsCommand.Execute(null);
            if (_viewModel.IsEdit)
            {
                foreach (var preSelectedGroupItem in SelectedRequiredGroupItems)
                {
                    var selectedItem = _viewModel.AllGroupItems.FirstOrDefault(x => x.GroupItem.Id == preSelectedGroupItem.GroupItem.Id);
                    var size = preSelectedGroupItem.GroupItem.Sizes.Where(x => x.Name == preSelectedGroupItem.SizeLabelText).FirstOrDefault();
                    if (size != null)
                    {
                        selectedItem.SizeIndex = preSelectedGroupItem.GroupItem.Sizes.IndexOf(size);
                        selectedItem.SizeLabelText = size.Name;
                    }
                    var side = preSelectedGroupItem.GroupItem.Sides.Where(x => x.Name == preSelectedGroupItem.SideLabelText).FirstOrDefault();
                    if (side != null)
                    {
                        selectedItem.SideIndex = preSelectedGroupItem.GroupItem.Sides.IndexOf(side);
                        selectedItem.SideLabelText = side.Name;

                    }
                    listView.SelectedItems.Add(selectedItem);
                    selectedItem.IsItemSelected = true;
                }

                foreach (var preSelectedGroupItem in SelectedOptionalGroupItems)
                {
                    var selectedItem = _viewModel.AllGroupItems.FirstOrDefault(x => x.GroupItem.Id == preSelectedGroupItem.GroupItem.Id);
                    var size = preSelectedGroupItem.GroupItem.Sizes.Where(x => x.Name == preSelectedGroupItem.SizeLabelText).FirstOrDefault();
                    if (size != null)
                    {
                        selectedItem.SizeIndex = preSelectedGroupItem.GroupItem.Sizes.IndexOf(size);
                        selectedItem.SizeLabelText = size.Name;
                    }
                    var side = preSelectedGroupItem.GroupItem.Sides.Where(x => x.Name == preSelectedGroupItem.SideLabelText).FirstOrDefault();
                    if (side != null)
                    {
                        selectedItem.SideIndex = preSelectedGroupItem.GroupItem.Sides.IndexOf(side);
                        selectedItem.SideLabelText = side.Name;

                    }
                    selectedItem.IsItemSelected = true;
                    listView.SelectedItems.Add(selectedItem);

                }
            }
            listView.SelectedItem = null;
            var dataView = this.listView.GetDataView();
            dataView.CollapseAll();
            listView.IsVisible = true;
            IsBusy = false;

        }
        private bool ValidateRequiredEntries()
        {
            if (_viewModel.AllGroups != null)
                foreach (var requiredGroup in _viewModel.AllGroups)
                {
                    if (requiredGroup.Group.IsRequired)
                    {
                        if (requiredGroup.Group.Type == GroupType.Single)
                        {
                            var selection = _viewModel.AllGroupItems.FirstOrDefault(x => x.GroupItem.GroupId == requiredGroup.Group.Id && x.IsItemSelected);
                            if (selection == null)
                                return false;
                        }
                        if (requiredGroup.Group.Type == GroupType.Multiple)
                        {
                            var selection = _viewModel.AllGroupItems.FirstOrDefault(x => x.GroupItem.GroupId == requiredGroup.Group.Id && x.IsItemSelected);
                            if (selection == null)
                                return false;
                        }
                        if (requiredGroup.Group.Type == GroupType.MinMax)
                        {
                            var selectedItems = _viewModel.AllGroupItems.Where(x => x.GroupItem.GroupId == requiredGroup.Group.Id && x.IsItemSelected).ToList();
                            if (!(selectedItems.Count >= requiredGroup.Group.Min && selectedItems.Count <= requiredGroup.Group.Max))
                                return false;
                        }
                    }
                }

            return true;
        }

        void OnStepperValueChanged(object sender, ValueChangedEventArgs e)
        {
            _viewModel.Quantity = (int)e.NewValue;
        }
        private async void AddToCartButton_Clicked(object sender, EventArgs e)
        {
            if (IsBusy)
                return;
            if (!ValidateRequiredEntries())
            {
                PopupHelper.CreatePopup("", "Please select required choices");
                return;
            }
            try
            {
                IsBusy = true ;
                var db = new SQLiteConnection(Constants.SqlLiteDbFolder);
                db.CreateTable<ShoppingCartItem>();
                var shoppingCartItem = MapViewModelToCartItem();
                shoppingCartItem.Id = _viewModel.ShoppingCartId; //Id only exists in "Edit" mode
                if (_viewModel.IsEdit)
                {
                    db.Update(shoppingCartItem);
                    await Navigation.PopAsync();
                    IsBusy = false;
                }
                else
                {
                    db.Insert(shoppingCartItem);
                    string action = await DisplayActionSheet("Item successfully added to cart!", null, null, "Back to Menu", "Shopping Cart");
                    if (action == "Back to Menu")
                    {
                        await Navigation.PopToRootAsync();
                    }
                    else if (action == "Shopping Cart")
                    {
                        var existingPages = Navigation.NavigationStack.ToList();
                        await Navigation.PushAsync(new ShoppingCartPage());
                        foreach (var page in existingPages)
                        {
                            if (page.Title != "Main Menu" && page.Title != "Shopping Cart")
                                Navigation.RemovePage(page);
                        }

                    }
                    else
                    {
                        await Navigation.PopToRootAsync();

                    }
                }
            }
            catch (Exception exception)
            {
                PopupHelper.CreatePopup("Uh-oh!", "Unable to add to cart at this time");
                IsBusy = false;
#if DEBUG
                Console.WriteLine("Post to cart failed because {0}", exception);
#endif
            }

        }


        private ShoppingCartItem MapViewModelToCartItem()
        {
            var cartItem = new ShoppingCartItem()
            {
                Description = _viewModel.Item.Description,
                Price = _viewModel.Total,
                Name = _viewModel.Item.Name,
                ImageUrl = _viewModel.Item.ImageUrl,
                Quantity = _viewModel.Quantity,
                SizeName = _viewModel.SelectedSize.Name,
                MenuItemId = _viewModel.Item.Id,
                SelectedSizeId = _selectedSize.Id,
                OptionalDelimitedString = "",
                RequiredDelimitedString = "",
                InstructionsEnabled = false
            };
            if (!string.IsNullOrEmpty(_viewModel.SpecialInstructions))
            {
                cartItem.Instructions = _viewModel.SpecialInstructions.Trim();
                cartItem.InstructionsEnabled = true;
            }
            if (_viewModel.AllGroupItems.Where(x => x.IsRequired == true).Any())
            {
                var requiredItems = _viewModel.AllGroupItems.Where(x => x.IsRequired == true);
                cartItem.RequiredChoicesEnabled = true;
                List<GroupItemViewModel> selectedRequiredGroupsItems = new List<GroupItemViewModel>();
                foreach (var item in requiredItems)
                {
                    if (item.IsItemSelected)
                    {
                        var group = _viewModel.AllGroups.FirstOrDefault(x => x.Group.Id == item.GroupItem.GroupId);
                        if (group.Group.IsRequired)
                            selectedRequiredGroupsItems.Add(item);
                    }
                }
                foreach (var groupItem in selectedRequiredGroupsItems)
                {
                    cartItem.RequiredChoicesEnabled = true;
                    string optionsLabel;
                    string delimitedString;
                    if (!string.IsNullOrEmpty(groupItem.SideLabelText))
                    {
                        optionsLabel = $"({groupItem.SizeLabelText},{groupItem.SideLabelText})";
                        delimitedString = $"/{groupItem.SizeLabelText}/{groupItem.SideLabelText}";
                    }
                    else if (!string.IsNullOrEmpty(groupItem.SizeLabelText))
                    {
                        optionsLabel = $"({groupItem.SizeLabelText})";
                        delimitedString = $"/{groupItem.SizeLabelText}";

                    }
                    else
                    {
                        optionsLabel = $"";
                        delimitedString = $"";
                    }
                    if (selectedRequiredGroupsItems.IndexOf(groupItem) == selectedRequiredGroupsItems.Count - 1)
                    {
                        cartItem.RequiredChoices = string.Concat(cartItem.RequiredChoices, groupItem.GroupItem.Name, optionsLabel);
                        delimitedString = string.Concat(groupItem.GroupItem.Id, delimitedString);
                    }
                    else
                    {
                        cartItem.RequiredChoices = string.Concat(cartItem.RequiredChoices, groupItem.GroupItem.Name, optionsLabel, ", ");
                        delimitedString = string.Concat(groupItem.GroupItem.Id, delimitedString, ",");

                    }
                    cartItem.RequiredDelimitedString += delimitedString;
                }

            }
            if (_viewModel.AllGroupItems.Where(x => x.IsRequired == false).Any())
            {
                var optionalItems = _viewModel.AllGroupItems.Where(x => x.IsRequired == false);
                List<GroupItemViewModel> selectedOptionalGroupsItems = new List<GroupItemViewModel>();
                foreach (var item in optionalItems)
                {
                    if (item.IsItemSelected)
                    {
                        var group = _viewModel.AllGroups.FirstOrDefault(x => x.Group.Id == item.GroupItem.GroupId);
                        if (!group.Group.IsRequired)
                            selectedOptionalGroupsItems.Add(item);
                    }
                }
                foreach (var groupItem in selectedOptionalGroupsItems)
                {
                    cartItem.OptionalChoicesEnabled = true;
                    string optionsLabel = "";
                    string delimitedString = "";
                    if (!string.IsNullOrEmpty(groupItem.SideLabelText))
                    {
                        optionsLabel = $"({groupItem.SizeLabelText}, {groupItem.SideLabelText})";
                        delimitedString = $"/{groupItem.SizeLabelText}/{groupItem.SideLabelText}";
                    }
                    else if (!string.IsNullOrEmpty(groupItem.SizeLabelText))
                    {
                        optionsLabel = $"({groupItem.SizeLabelText})";
                        delimitedString = $"/{groupItem.SizeLabelText}";
                    }
                    else
                    {
                        optionsLabel = $"";
                        delimitedString = $"";
                    }
                    if (selectedOptionalGroupsItems.IndexOf(groupItem) == selectedOptionalGroupsItems.Count - 1)
                    {
                        cartItem.OptionalChoices = string.Concat(cartItem.OptionalChoices, groupItem.GroupItem.Name, optionsLabel);
                        delimitedString = string.Concat(groupItem.GroupItem.Id, delimitedString);
                    }
                    else
                    {
                        cartItem.OptionalChoices = string.Concat(cartItem.OptionalChoices, groupItem.GroupItem.Name, optionsLabel, ", ");
                        delimitedString = string.Concat(groupItem.GroupItem.Id, delimitedString, ",");
                    }
                    cartItem.OptionalDelimitedString += delimitedString;


                }
            }
            return cartItem;
        }


        private void listView_ItemTapped(object sender, ItemTapEventArgs e)
        {
            var groupItem = e.Item as GroupItemViewModel;
            var group = _viewModel.AllGroups.FirstOrDefault(x => x.Group.Id == groupItem.GroupItem.GroupId);
            if (group == null)
                return;
            switch (group.Group.Type)
            {
                case GroupType.Single:
                    var preselectedItem = _viewModel.AllGroupItems.FirstOrDefault(x => x.IsItemSelected == true && x.GroupItem.GroupId == group.Group.Id);

                    if (groupItem.IsItemSelected)
                        groupItem.IsItemSelected = false;
                    else
                        groupItem.IsItemSelected = true;
                    if (preselectedItem != null)
                    {
                        if (preselectedItem != groupItem)
                        {
                            preselectedItem.IsItemSelected = false;

                        }
                    }
                    break;
                case GroupType.Multiple:
                    if (groupItem.IsItemSelected)
                    {
                        groupItem.IsItemSelected = false;
                    }
                    else
                    {
                        groupItem.IsItemSelected = true;
                    }
                    break;
                case GroupType.MinMax:
                    var preselectedItems = _viewModel.AllGroupItems.Where(x => x.IsItemSelected == true && x.GroupItem.GroupId == group.Group.Id);
                    if (groupItem.IsItemSelected)
                    {
                        groupItem.IsItemSelected = false;
                    }
                    else if (preselectedItems.Count() < group.Group.Max)
                    {
                        groupItem.IsItemSelected = true;
                    }
                    else
                        listView.SelectedItem = null;
                    break;
            }

        }

    }
}