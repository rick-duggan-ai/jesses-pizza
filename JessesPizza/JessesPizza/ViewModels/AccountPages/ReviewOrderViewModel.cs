using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Core.Models.Transactions;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Text;
using Telerik.XamarinForms.Common;
using Telerik.XamarinForms.Common.DataAnnotations;

namespace JessesPizza.ViewModels
{
    public class ReviewOrderViewModel : NotifyPropertyChangedBase
    {
        public ReviewOrderViewModel()
        {
        }
        public ReviewOrderViewModel(LocalTransactionV1_1 transaction, CreditCard card)
        {
            CardNumber = card.CardNumber;
            CardExpirationDate = card.ExpirationDate;
            CardDescription = card.ShortDescription;
            CardId = card.Id;
            ShoppingCartItems = new ObservableCollection<ReviewOrderCartItemViewModel>();
            foreach(var item in transaction.TransactionItems)
            {
                ShoppingCartItems.Add(new ReviewOrderCartItemViewModel(item));
            }
            Totals = transaction.Totals;
            Info = transaction.Info;
            LocalTransaction = transaction;
            SpecialInstructions = transaction.SpecialInstructions;
            if (!string.IsNullOrWhiteSpace(transaction.SpecialInstructions))
                SpecialInstructionsVisible = true;
        }
        public LocalTransactionV1_1 LocalTransaction { get; set; }
        private CustomerInfoApp _info;
        public CustomerInfoApp Info
        {
            get => _info;
            set
            {
                _info = value;
                OnPropertyChanged();
            }
        }
        public ObservableCollection<ReviewOrderCartItemViewModel> ShoppingCartItems { get; set; }
        private OrderTotals _totals;
        public OrderTotals Totals
        {
            get => _totals;
            set
            {
                _totals = value;
                OnPropertyChanged();
            }
        }
        public Guid CardId { get; set; }
        public string CardNumber
        {
            get => _cardNumber;
            set
            {
                _cardNumber = value;
                OnPropertyChanged();
            }
        }
        public string CardExpirationDate
        {
            get => _expirationDate;
            set
            {
                _expirationDate = value;
                OnPropertyChanged();
            }
        }
        public string CardDescription
        {
            get => _shortDescription;
            set
            {
                _shortDescription = value;
                OnPropertyChanged();
            }
        }
        public string SpecialInstructions
        {
            get => _specialInstructions;
            set
            {
                _specialInstructions = value;
                OnPropertyChanged();
            }
        }
        private string _specialInstructions;
        private string _cardNumber;
        private string _expirationDate;
        private string _shortDescription;

        public bool IsSelected
        {
            get => _isSelected;
            set
            {
                _isSelected = value;
                OnPropertyChanged();
            }
        }
        private bool _isSelected;
        public bool SpecialInstructionsVisible
        {
            get => _specialInstructionsVisible;
            set
            {
                _specialInstructionsVisible = value;
                OnPropertyChanged();
            }
        }
        private bool _specialInstructionsVisible;
        
        private string _addressText;

        public string AddressLabelText
        {
            get => _addressText;
            set
            {
                _addressText = value;
                OnPropertyChanged();
            }
        }
    }
    public class ReviewOrderCartItemViewModel : NotifyPropertyChangedBase
    {
        public ReviewOrderCartItemViewModel()
        {
        }
        public ReviewOrderCartItemViewModel(ShoppingCartItem item)
        {
            Name = $"{item.Name}({item.SizeName})";
            Quantity = item.Quantity;
            Price = item.Price.ToString("$0.00");
            
        }
        private string _name;

        public string Name
        {
            get => _name;
            set
            {
                _name = value;
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
                OnPropertyChanged();
            }
        }
        private string _price;

        public string Price
        {
            get => _price;
            set
            {
                _price = value;
                OnPropertyChanged();
            }
        }
    }
}

