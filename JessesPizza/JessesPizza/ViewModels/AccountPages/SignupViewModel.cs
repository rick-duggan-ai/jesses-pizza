using System;
using System.Windows.Input;

using Xamarin.Forms;
using Xamarin.Essentials;
using System.Threading.Tasks;
using System.Diagnostics;
using JessesPizza.Core.Models;
using System.ComponentModel.DataAnnotations;
using Telerik.XamarinForms.Common;
using Telerik.XamarinForms.Common.DataAnnotations;
using JessesPizza.Helpers;

namespace JessesPizza.ViewModels
{
    public class SignUpViewModel : NotifyPropertyChangedBase
    {

        public SignUpViewModel()
        {

        }
        private string _email;
        private string _password;

        [DisplayOptions(Header = "Email", PlaceholderText = "email", Group = "Registration Info")]
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