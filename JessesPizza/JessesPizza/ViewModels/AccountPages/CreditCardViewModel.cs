using JessesPizza.Core.Models.Identity;
using JessesPizza.Core.Models.Transactions;
using System;
using System.Collections.Generic;
using System.Text;
using Telerik.XamarinForms.Common;
using Telerik.XamarinForms.Common.DataAnnotations;

namespace JessesPizza.ViewModels
{
    public class CreditCardViewModel : NotifyPropertyChangedBase
    {
        public CreditCardViewModel()
        {
        }
        public CreditCardViewModel(CreditCard card)
        {
            CardNumber = card.CardNumber;
            CardExpirationDate = card.ExpirationDate;
            CardDescription = card.ShortDescription;
            Id = card.Id;
        }
        public Guid Id { get; set; }
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

    }
}
