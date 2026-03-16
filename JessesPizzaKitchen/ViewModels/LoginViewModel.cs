using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizzaKitchen.ViewModels
{
    class LoginViewModel :BaseViewModel
    {
        private string _userName;
        public string UserName
        {
            get { return _userName; }
            set
            {
                _userName = value;
                OnPropertyChanged("UserName");
            }
        }

        private string _password;
        public string Password
        {
            get { return _password; }
            set
            {
                _password = value;
                OnPropertyChanged("Password");
            }
        }

    }
}
