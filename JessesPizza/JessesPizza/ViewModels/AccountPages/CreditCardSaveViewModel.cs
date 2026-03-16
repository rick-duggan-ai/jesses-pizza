using JessesPizza.Core.Models.Transactions;
using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.ViewModels
{
    public class CreditCardSaveViewModel : BaseViewModel
    {
        private string _cardNumber;
        private string _cardExpirationDate;
        private string _cardDescription;
        public CreditCardSaveViewModel(CreditCard card)
        {
            CardNumber = card.CardNumber;
            CardExpirationDate = card.ExpirationDate;
            CardDescription = card.ShortDescription;
        }
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
            get => _cardExpirationDate;
            set
            {
                _cardExpirationDate = value;
                OnPropertyChanged();
            }
        }
        public string CardDescription
        {
            get => _cardDescription;
            set
            {
                _cardDescription = value;
                OnPropertyChanged();
            }
        }



    }

}
