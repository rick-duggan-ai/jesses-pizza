using JessesPizza.Services;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;
using System.Windows.Input;
using Telerik.XamarinForms.Common;
using Telerik.XamarinForms.Common.DataAnnotations;
using Xamarin.Forms;

namespace JessesPizza.ViewModels
{
    class NewPasswordViewModel : NotifyPropertyChangedBase
    {
        public NewPasswordViewModel( )
        {
        }

        private string _password;
        [DisplayOptions(Header = "Password", PlaceholderText = "password", Position = 2, Group = "Registration Info")]
        [RegularExpressionValidator(@"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$", "Must be 8 characters long, have a number, and a special character")]

        public string Password
        {
            get => _password;
            set
            {
                _password = value;
                OnPropertyChanged();
            }
        }

        private string _confirmPassword;
        [DisplayOptions(Header = "Confirm Password", PlaceholderText = "password", Position = 3, Group = "Registration Info")]
        [RegularExpressionValidator(@"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$", "Must be 8 characters long, have a number, and a special character")]
        public string ConfirmPassword
        {
            get => _confirmPassword;
            set
            {
                _confirmPassword = value;
                OnPropertyChanged();
            }
        }

    }
}
