using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Text;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Models;
using Xamarin.Forms;

namespace JessesPizza.ViewModels
{
    class MainMenuItemViewModel : BaseViewModel
    {
        private string _id;
        private string _name;
        private List<JessesMenuItem> _menuItems;
        private string _imageUrl;
        public string Id
        {
            get => _id;
            set
            {
                _id = value;
                OnPropertyChanged();
            }
        }
        public string Name
        {
            get => _name;
            set
            {
                _name = value;
                OnPropertyChanged();
            }
        }
        private int _ordinal;
        public int Ordinal
        {
            get => _ordinal;
            set
            {
                _ordinal = value;
            }
        }
        public List<JessesMenuItem> MenuItems
        {
            get => _menuItems;
            set
            {
                _menuItems = value;
                OnPropertyChanged();
            }
        }
        public string ImageUrl
        {
            get => _imageUrl;
            set
            {
                _imageUrl = value;
                OnPropertyChanged();
            }
        }
        private bool _imageHasValue;
        public bool ImageHasValue
        {
            get => _imageHasValue;
            set
            {
                _imageHasValue = value;
                OnPropertyChanged();
            }
        }
        public MainMenuItemViewModel()
        {

        }
        public MainMenuItemViewModel(MainMenuItem mmi)
        {
            ImageUrl = mmi.ImageUrl;
            Name = mmi.Name;
            Id = mmi.Id;
            MenuItems = mmi.MenuItems;
            if (string.IsNullOrEmpty(ImageUrl))
                ImageHasValue = false;
            else
                ImageHasValue = true;
            Ordinal = mmi.Ordinal;
        }
    }
}
