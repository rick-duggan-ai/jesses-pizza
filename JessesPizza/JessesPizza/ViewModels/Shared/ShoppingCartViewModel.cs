using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Models;
using JessesPizza.Services;
using SQLite;
using Xamarin.Forms;

namespace JessesPizza.ViewModels
{
    class ShoppingCartViewModel : BaseViewModel
    {
        public Command LoadItemsCommand { get; set; }
        public ObservableCollection<ShoppingCartItem> ShoppingItems {get;}
        public JessesMenuItem SelectedMenuItem { get; set; }
        public decimal TaxRate { get; set; }
        private string _count;
        public string Count
        {
            get => _count;
            set
            {
                _count = value;
                OnPropertyChanged();
            }
        }
        private bool _isEmpty;
        public bool IsEmpty
        {
            get => _isEmpty;
            set
            {
                _isEmpty = value;
                OnPropertyChanged();
            }
        }
        private decimal _deliveryCharge { get; set; }
        public decimal DeliveryCharge
        {
            get => _deliveryCharge ;
            set
            {
                _deliveryCharge = value;
                OnPropertyChanged();
            }
        }
        private decimal _taxTotal;

        public decimal TaxTotal
        {
            get => _taxTotal = CalculateTaxTotal();
            set
            { 
                _taxTotal = value;
                OnPropertyChanged();
                OnPropertyChanged("SubTotal");
            }
        }
        private decimal _tip;
        public decimal Tip
        {
            get => _tip;
            set
            {
                _tip = value;
                OnPropertyChanged();
                OnPropertyChanged("SubTotal");

            }
        }
        private decimal _subTotal;
        public decimal SubTotal
        {
            get => _subTotal = CalculateSubTotal();
            set
            {
                _subTotal = value;
                OnPropertyChanged();

            }
        }
        private decimal _total;
        public decimal Total
        {
            get => _total;
            set
            {
                _total = value;
                OnPropertyChanged();
                OnPropertyChanged("SubTotal");
                OnPropertyChanged("TaxTotal");
            }
        }
        private void observable_CollectionChanged(object sender, System.Collections.Specialized.NotifyCollectionChangedEventArgs e)
        {
            Total = CalculateTotal();
        }
        public ShoppingCartViewModel()
        {
            Title = "Shopping Cart";
            IsEmpty = false;
            ShoppingItems = new ObservableCollection<ShoppingCartItem>();
            ShoppingItems.CollectionChanged += observable_CollectionChanged;
            LoadItemsCommand = new Command(async () => await ExecuteLoadItemsCommand());

        }
        private decimal CalculateTaxTotal()
        {
            if (TaxRate != 0)
            { 
                decimal taxTotal =Convert.ToDecimal(SubTotal * TaxRate/100);
                return taxTotal;
            }
            return 0;
        }
        private decimal CalculateSubTotal()
        {
            decimal cartTotal = 0;
            foreach (var shoppingCartItem in ShoppingItems)
            {
                cartTotal += shoppingCartItem.Price;
            }

            return cartTotal;
        }

        private decimal CalculateTotal()
        {
            decimal cartTotal = SubTotal + TaxTotal + Tip;
            return cartTotal;
        }
        public async Task ExecuteLoadItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                // get menu item ids
                var mainMenuItems = await App.MenuManager.GetMainMenuItemsAsync();
                List<string> menuItemIds = new List<string>();
                foreach(MainMenuItem mmi in mainMenuItems)
                {
                    foreach(JessesMenuItem mi in mmi.MenuItems)
                    {
                        menuItemIds.Add(mi.Id);
                    }
                };
                //Get payment info
                var info = await App.MenuManager.GetOrderInfoAsync();
                if (info != null)
                {
                    TaxRate = info.TaxRate;
                    DeliveryCharge = info.DeliveryCharge;
                }
                // get shopping cart from sqlite
                ShoppingItems.Clear();
                var db = new SQLiteConnection(Constants.SqlLiteDbFolder);
                db.CreateTable<ShoppingCartItem>();
                var items = from i in db.Table<ShoppingCartItem>()
                            select i;
                // add items only if they still exist in Mongo
                foreach (var item in items)
                {
                    if (menuItemIds.Any(x => x == item.MenuItemId))
                        ShoppingItems.Add(item);
                    else
                        db.Delete(item);
                }
                //set empty flags
                if (ShoppingItems.Count == 0)
                {
                    IsEmpty = true;
                    Count = "";
                }
                else
                {
                    IsEmpty = false;
                    var count = ShoppingItems.Count();
                    if (count == 0)
                        Count = ""; 
                    if (count == 1)
                        Count = $"(1 item)";
                    else
                        Count = $"({count} items)";
                }
                Tip = 0;
                Total = CalculateTotal();

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            finally
            {
                IsBusy = false;
            }
        }
    }
}
