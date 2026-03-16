using System;
using System.Collections.Generic;
using System.Text;
using SQLite;
using Telerik.XamarinForms.Common;
using Telerik.XamarinForms.Common.DataAnnotations;

namespace JessesPizza.Core.Models
{
    public class CustomerInfoApp : NotifyPropertyChangedBase
    {

        private string _firstName ;
        private string _lastName;
        private string _phoneNumber;
        private string _address1;
        private string _email;
        private string _city;
        private string _zipCode;

        [DisplayOptions( Group ="Payment Info", Header = "Zip Code",PlaceholderText ="Zip Code", Position = 7)]
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

        [DisplayOptions(Group = "Payment Info", Header = "City", PlaceholderText ="City", Position = 5)]
        [StringLengthValidator(4,20)]
        
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


        [DisplayOptions(Group = "Payment Info", PlaceholderText = "Email", Header = "Email Address", Position = 4)]
        [EmailValidator]
        public string EmailAddress
        {
            get => _email;
            set
            {
                if (value != _email)
                {
                    _email = value;
                    OnPropertyChanged();
                }
            }
        }

        [DisplayOptions(Group = "Payment Info", PlaceholderText = "Address", Header = "Address", Position = 3)]
        [StringLengthValidator(5,40)]
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

        [DisplayOptions(Group = "Payment Info", PlaceholderText = "(XXX)XXX-XXXX", Header = "Phone Number",Position = 2)]
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

        [DisplayOptions(Group = "Payment Info", PlaceholderText = "First Name", Header = "First Name", Position = 1)]
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
        [DisplayOptions(Group = "Payment Info", PlaceholderText = "Last Name", Header = "Last Name", Position = 0)]
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
