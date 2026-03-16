using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Models;
using Telerik.XamarinForms.Common;
using Xamarin.Forms;

namespace JessesPizza.ViewModels
{
    public class MenuItemEditViewModel : BaseViewModel
    {
        public int ShoppingCartId { get; set; }
        public JessesMenuItem Item { get; set; }
        public ObservableCollection<GroupViewModel> AllGroups { get; set; }
        public ObservableCollection<GroupItemViewModel> AllGroupItems { get; set; } = new ObservableCollection<GroupItemViewModel>();

        public string SpecialInstructions { get; set; }
        public Command LoadItemsCommand { get; set; }

        private bool _isEdit;
        public bool IsEdit
        {
            get => _isEdit;
            set
            {
                _isEdit = value;
                OnPropertyChanged("ButtonText");
                OnPropertyChanged();
            }
        }

        private bool _listEmpty;
        public bool ListEmpty
        {
            get => _listEmpty;
            set
            {
                _listEmpty = value;
                OnPropertyChanged();
            }
        }

        private string _buttonText;
        public string ButtonText
        {
            get => _buttonText;
            set
            {
                if (IsEdit)
                    _buttonText = "Save";
                else
                    _buttonText = "Add To Cart";
                OnPropertyChanged();
            }
        }
        private int _quantity;
        public int Quantity
        {
            get => _quantity;
            set
            {
                _quantity = value;
                Total = CalculateTotal();
                OnPropertyChanged("Quantity");
                OnPropertyChanged("Total");
            }
        }
        public JessesItemSize SelectedSize { get; set; }
        private decimal _total;
        public decimal Total
        {
            get => _total;
            set
            {
                _total = value;
                OnPropertyChanged("Quantity");
                OnPropertyChanged();
            }
        }
        private bool _imageHasValue;
        public bool ImageHasValue
        {
            get => _imageHasValue;
            set
            {
                _imageHasValue = value;
                OnPropertyChanged();
            }
        }
        private JessesItemSize _selectedSize;
        public MenuItemEditViewModel(JessesMenuItem item, JessesItemSize selectedSize)
        {
            _selectedSize = selectedSize;
            LoadItemsCommand = new Command(async () => await ExecuteLoadItemsCommand());
            AllGroupItems.CollectionChanged += observable_CollectionChanged;
            Task.Run(async () => await ExecuteLoadItemsCommand()).Wait();
            try { 
            Item = item;

            if (selectedSize == null)
            {
                SelectedSize = new JessesItemSize
                {
                    Price = Item.Sizes.Where(c => c.Price > 0).Min(c => c.Price)
                };
                SelectedSize = Item.Sizes.Where(s => s.Price == SelectedSize.Price).Select(s => s).First();
            }
            else
                SelectedSize = selectedSize;
            Total = SelectedSize.Price;
            Title = string.Concat(item.Name, $" ({SelectedSize.Name})");
                if (string.IsNullOrEmpty(Item.ImageUrl))
                    ImageHasValue = false;
                else
                    ImageHasValue = true;
            }
            catch(Exception e){
                Console.WriteLine(e.Message);
            }
        }
        public void observable_CollectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e)
        {
            if (e.NewItems != null)
                foreach (INotifyPropertyChanged added in e.NewItems)
                {
                    added.PropertyChanged += OnPropertyInCollectionChanged;
                }
            if (e.OldItems != null)
                foreach (INotifyPropertyChanged removed in e.OldItems)
                {
                    removed.PropertyChanged -= OnPropertyInCollectionChanged;
                }
            Total = CalculateTotal();
        }
        public void OnPropertyInCollectionChanged(object sender, PropertyChangedEventArgs propertyChangedEventArgs)
        {
            Total = CalculateTotal();

        }
        private decimal CalculateTotal()
        {
            decimal total = 0;
            if (SelectedSize != null)
                total = SelectedSize.Price;

            foreach (var item in AllGroupItems)
            {

                if (item.IsItemSelected)
                {
                    if(item.GroupItem.Sides != null)
                        if (item.GroupItem.Sides.Count != 0)
                             total += item.GroupItem.Sides[item.SideIndex].Price;
                    if (item.GroupItem.Sizes != null)
                        if (item.GroupItem.Sizes.Count != 0)
                            total += item.GroupItem.Sizes[item.SizeIndex].Price;
                }

            }
            total *= Quantity;
            return total;
        }

        private async Task ExecuteLoadItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                var groups = await App.MenuManager.GetGroupDataAsync();
                if (groups != null)
                {
                    int i = 0;
                    AllGroups = new ObservableCollection<GroupViewModel>();
                    foreach (var group in groups)
                    {
                        if(_selectedSize.GroupIds.Contains(group.Id))
                        { 
                                var vm = new GroupViewModel(group);
                                AllGroups.Add(vm);
                                foreach (var groupItem in vm.Items)
                                {
                                    groupItem.GroupName = vm.DisplayName;
                                    groupItem.IsRequired = group.IsRequired;
                                    groupItem.GroupImageUrlString = group.ImageUrl;
                                    groupItem.GroupListIndex = i;
                                    AllGroupItems.Add(groupItem);
                                }
                                i++;
                        }
                    }

                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
            }
            finally
            {
                IsBusy = false;
            }
        }
    }

}
