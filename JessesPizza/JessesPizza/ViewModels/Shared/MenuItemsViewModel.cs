using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Text;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Models;
using JessesPizza.Services;
using JessesPizza.Views;
using Xamarin.Forms;

namespace JessesPizza.ViewModels
{
    class MenuItemsViewModel : BaseViewModel
    {
        public ObservableCollection<JessesMenuItemViewModel> Items { get; set; }
        public MenuItemsViewModel(List<JessesMenuItem> items,string itemTitle)
        {
            Title = itemTitle;
            Items = new ObservableCollection<JessesMenuItemViewModel>();
            foreach (var item in items)
            {
                Items.Add(new JessesMenuItemViewModel(item));
            }
        }
    }
}
