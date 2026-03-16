using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Models;
using Xamarin.Forms;

namespace JessesPizza.ViewModels
{
    class JessesMenuItemViewModel : BaseViewModel
    {
        private string _id;
        private string _name;
        private string _description;
        private List<JessesItemSize> _sizes;
        private string _imageUrl;
        private bool _imageHasValue;
        public JessesMenuItem MenuItem;
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
        public string Description
        {
            get => _description;
            set
            {
                _description = value;
                OnPropertyChanged();
            }
        }
        public List<JessesItemSize> Sizes
        {
            get => _sizes;
            set
            {
                _sizes = value;
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
        public bool ImageHasValue
        {
            get => _imageHasValue;
            set
            {
                _imageHasValue = value;
                OnPropertyChanged();
            }
        }
        public JessesMenuItemViewModel()
        {

        }
        public JessesMenuItemViewModel(JessesMenuItem mi)
        {
            ImageUrl = mi.ImageUrl;
            Name = mi.Name;
            Id = mi.Id;
            Sizes = mi.Sizes;
            MenuItem = mi;
            Description = mi.Description;
            if (string.IsNullOrEmpty(ImageUrl))
                ImageHasValue = false;
            else
                ImageHasValue = true;
        }
    }
}
