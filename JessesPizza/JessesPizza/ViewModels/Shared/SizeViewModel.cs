using JessesPizza.Core.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.ViewModels
{

    public class SizeViewModel :BaseViewModel
    {
        public string Id { get; set; }

        public string Name { get; set; }
        public decimal Price { get; set; }

        public JessesItemSize Size { get; set; }
        private bool _isSelected;

        public bool IsSelected
        {
            get => _isSelected;
            set
            {
                _isSelected = value;
                OnPropertyChanged();
            }
        }

        public SizeViewModel(JessesItemSize size)
        {
            Size = size;
            Name = size.Name;
            Price = size.Price;
            Id = size.Id;
        }
    }
}
