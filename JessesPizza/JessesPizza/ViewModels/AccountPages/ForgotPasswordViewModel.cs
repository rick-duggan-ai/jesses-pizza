using System;
using System.Collections.Generic;
using System.Text;
using Telerik.XamarinForms.Common;
using Telerik.XamarinForms.Common.DataAnnotations;

namespace JessesPizza.ViewModels
{
    public class ForgotPasswordViewModel : NotifyPropertyChangedBase
    {
        private string _phoneNumber;

        [DisplayOptions(PlaceholderText = "(XXX)XXX-XXXX", Header = "Phone Number", Position = 2)]
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
    }
}
