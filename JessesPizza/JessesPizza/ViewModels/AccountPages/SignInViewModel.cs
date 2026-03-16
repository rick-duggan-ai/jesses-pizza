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
    class SignInViewModel : NotifyPropertyChangedBase
    {
        public SignInViewModel( )
        {
        }

        private string _email;
        private string _password;

        [DisplayOptions(Header = "Email", PlaceholderText = "email", Group = "Sign In")]
        [EmailValidator]

        public string Email
        {
            get => _email;
            set
            {
                _email = value;
                OnPropertyChanged();
            }
        }

        [DisplayOptions(Header = "Password", PlaceholderText = "password", Position = 2, Group = "Sign In")]
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
    }
}
