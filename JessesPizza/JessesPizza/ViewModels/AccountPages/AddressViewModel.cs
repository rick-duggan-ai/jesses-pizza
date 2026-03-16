using JessesPizza.Core.Models.Identity;
using System;
using System.Collections.Generic;
using System.Text;
using Telerik.XamarinForms.Common;
using Telerik.XamarinForms.Common.DataAnnotations;

namespace JessesPizza.ViewModels
{
    public class AddressViewModel : NotifyPropertyChangedBase
    {
        public AddressViewModel()
        {
            Id = Guid.NewGuid().ToString();
        }
        public AddressViewModel(Address address)
        {
            DisplayName = address.DisplayName;
            AddressLine1 = address.AddressLine1;
            ZipCode = address.ZipCode;
            City = address.City;
            IsSelected = false;
            IsDefault = address.IsDefault;
            Id = address.Id.ToString();
        }
        public string Id;

        private bool _isSelected;
        [Ignore]
        public bool IsSelected
        {
            get => _isSelected;
            set
            {
                if (value != _isSelected)
                {
                    _isSelected = value;
                    OnPropertyChanged();
                }
            }
        }
        private bool _isDefault;
        [Ignore]
        public bool IsDefault
        {
            get => _isDefault;
            set
            {
                if (value != _isDefault)
                {
                    _isDefault = value;
                    OnPropertyChanged();
                }
            }
        }
        [Ignore]
        public string UserName;
        [Ignore]
        public string  Password;
        private string _displayName;
        private string _address;
        private string _city;
        private string _zipCode;

        [DisplayOptions(Header = "Zip Code", PlaceholderText = "Zip Code", Position = 7, Group = "Address")]
        public string ZipCode
        {
            get => _zipCode;
            set
            {
                if (value != _zipCode)
                {
                    _zipCode = value;
                    OnPropertyChanged();
                }
            }
        }

        [DisplayOptions(Header = "City", PlaceholderText = "City", Position = 5, Group = "Address")]
        [StringLengthValidator(4, 20)]

        public string City
        {
            get => _city;
            set
            {
                if (value != _city)
                {
                    _city = value;
                    OnPropertyChanged();
                }
            }
        }

        [DisplayOptions(PlaceholderText = "Address", Header = "Address", Position = 3, Group = "Address")]
        [StringLengthValidator(5, 40)]
        public string AddressLine1
        {
            get => _address;
            set
            {
                if (value != _address)
                {
                    _address = value;
                    OnPropertyChanged();
                }
            }
        }

        [DisplayOptions( PlaceholderText = "Display Name", Header = "Display Name", Position = 1, Group ="Address")]
        public string DisplayName
        {
            get => _displayName;
            set
            {
                if (value != _displayName)
                {
                    _displayName = value;
                    OnPropertyChanged();
                }
            }
        }

    }
}
