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
    public class MenuItemDetailViewModel : BaseViewModel
    {
        public int ShoppingCartId { get; set; }
        public JessesMenuItem Item { get; set; }
        public ObservableCollection<Group> AllGroups { get; set; }
        public ObservableCollection<GroupViewModel> RequiredGroups { get; set; }
        public ObservableCollection<GroupViewModel> OptionalGroups { get; set; }
        public ObservableCollection<GroupItemViewModel> SelectedRequiredGroupItems { get; set; }
        public ObservableCollection<GroupItemViewModel> SelectedOptionalGroupItems { get; set; }
        public string SpecialInstructions { get; set; }
        //public Dictionary<int, MinMax> MinMaxDictionary { get; set; }
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
        private string _buttonText;
        public string ButtonText
        {
            get => _buttonText;
            set
            {
                _buttonText = value;
                OnPropertyChanged("IsEdit");
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
        public MenuItemDetailViewModel(JessesMenuItem item, JessesItemSize selectedSize)
        {
            RequiredGroups = new ObservableCollection<GroupViewModel>();
            OptionalGroups = new ObservableCollection<GroupViewModel>();
            SelectedRequiredGroupItems = new ObservableCollection<GroupItemViewModel>();
            SelectedOptionalGroupItems = new ObservableCollection<GroupItemViewModel>();
            //MinMaxDictionary = new Dictionary<int, MinMax>();
            LoadItemsCommand = new Command(async () => await ExecuteLoadItemsCommand());
            Task.Run(async () =>await ExecuteLoadItemsCommand()).Wait();

            Item = item;
            foreach(var id in selectedSize.GroupIds)
            {
                var group = AllGroups.Where(x => x.Id == id).FirstOrDefault();
                if (group == null)
                    return;
                var vm = new GroupViewModel(group);
                if (group.IsRequired)
                    RequiredGroups.Add(vm);
                else
                    OptionalGroups.Add(vm);
            }
            SelectedRequiredGroupItems.CollectionChanged += observable_CollectionChanged;
            SelectedOptionalGroupItems.CollectionChanged += observable_CollectionChanged;


            if (SelectedSize == null)
            {
                SelectedSize = new JessesItemSize();
                SelectedSize.Price = Item.Sizes.Where(c => c.Price > 0).Min(c => c.Price);
                SelectedSize = Item.Sizes.Where(s => s.Price == SelectedSize.Price).Select(s => s).First();

            }
            Total = SelectedSize.Price;
            Title = string.Concat(item.Name, $" ({SelectedSize.Name})");
            if (string.IsNullOrEmpty(Item.ImageUrl))
                ImageHasValue = false;
            else
                ImageHasValue = true;
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
            var total = SelectedSize.Price;
            total = total * Quantity;
            if (SelectedRequiredGroupItems != null)
                foreach (var item in SelectedRequiredGroupItems)
                {
                    total += item.GroupItem.Sizes[item.SizeIndex].Price * Quantity;
                }
            if (SelectedOptionalGroupItems != null)
                foreach (var item in SelectedOptionalGroupItems)
                {
                    try
                    {
                        total += item.GroupItem.Sides[item.SideIndex].Price * Quantity;
                    }
                    catch
                    {

                    }
                }
            return total;
        }

        async Task ExecuteLoadItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                var groups = await App.MenuManager.GetGroupDataAsync();
                if (groups != null)
                {
                    AllGroups = new ObservableCollection<Group>();
                    foreach (var group in groups)
                    {
                        AllGroups.Add(group);
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
