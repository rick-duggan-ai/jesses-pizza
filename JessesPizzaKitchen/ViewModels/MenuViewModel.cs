
using JessesPizzaKitchen.Models;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Xamarin.Forms;

namespace JessesPizzaKitchen.ViewModels
{
    public class MenuViewModel : BaseViewModel
    {


        public MenuViewModel(List<HomeMenuItem> pages)
        {
            Pages = pages;

        }
        public List<HomeMenuItem> Pages { get; set; }

        private bool _isLoggedIn;
        public bool IsLoggedIn
        {
            get => _isLoggedIn;
            set
            {
                _isLoggedIn = value;
                OnPropertyChanged("IsLoggedIn");
            }
        }
    }
}
