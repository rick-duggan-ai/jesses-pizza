using System;
using System.Collections.Generic;
using System.Text;
using Telerik.XamarinForms.Common;
using Telerik.XamarinForms.Common.DataAnnotations;

namespace JessesPizza.ViewModels
{
    class SignUpAddressViewModel : NotifyPropertyChangedBase
    {
        public SignUpAddressViewModel(string username,string password)
        {
            Username = username;
            Password = password;
        }

        private string _firstName;
        private string _lastName;
        private string _phoneNumber;
        private string _address1;
        private string _city;
        private string _zipCode;
        [Ignore]
        public string Username { get; set; }
        [Ignore]
        public string Password { get; set; }

        [DisplayOptions(Group = "Enter your address", Header = "Zip Code", PlaceholderText = "Zip Code", Position = 7)]
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

        [DisplayOptions(Group = "Enter your address", Header = "City", PlaceholderText = "City", Position = 5)]
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

        [DisplayOptions(Group = "Enter your address", PlaceholderText = "Address", Header = "Address", Position = 3)]
        [StringLengthValidator(5, 40)]
        public string AddressLine1
        {
            get => _address1;
            set
            {
                if (value != _address1)
                {
                    _address1 = value;
                    OnPropertyChanged();
                }
            }
        }

        [DisplayOptions(Group = "Enter your address", PlaceholderText = "(XXX)XXX-XXXX", Header = "Phone Number", Position = 2)]
        [StringLengthValidator(10, 11)]
        public string PhoneNumber
        {
            get => _phoneNumber;
            set
            {
                if (value != this._phoneNumber)
                {
                    this._phoneNumber = value;
                    OnPropertyChanged();
                }
            }
        }

        [DisplayOptions(Group = "Enter your address", PlaceholderText = "First Name", Header = "First Name", Position = 1)]
        [NonEmptyValidator("First Name is required!")]
        public string FirstName
        {
            get => _firstName;
            set
            {
                if (value != _firstName)
                {
                    _firstName = value;
                    OnPropertyChanged();
                }
            }
        }
        [DisplayOptions(Group = "Enter your address", PlaceholderText = "Last Name", Header = "Last Name", Position = 0)]
        [NonEmptyValidator("Last Name is required!")]
        public string LastName
        {
            get => _lastName;
            set
            {
                if (value != _lastName)
                {
                    _lastName = value;
                    OnPropertyChanged();
                }
            }
        }

    }
}