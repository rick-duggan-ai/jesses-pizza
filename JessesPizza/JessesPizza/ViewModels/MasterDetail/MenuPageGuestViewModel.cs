using JessesPizza.Core.Models;
using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.ViewModels
{
    public class MenuPageGuestViewModel: BaseViewModel
    {
        public System.Collections.ObjectModel.ObservableCollection<HomeMenuItem> HomeMenuItems;
        public MenuPageGuestViewModel()
        {
            HomeMenuItems = new System.Collections.ObjectModel.ObservableCollection<HomeMenuItem>
            {
                new HomeMenuItem {Id = MenuItemType.MainMenu, Title="Main Menu",Icon="\uf2dc" },
                new HomeMenuItem {Id = MenuItemType.Orders, Title="My Orders",Icon="\uf116" },
                new HomeMenuItem {Id = MenuItemType.Contact, Title="Contact Us",Icon="\uf34e"},
                new HomeMenuItem {Id = MenuItemType.About, Title="About",Icon="\uf2fc" },

            };
        }
    
    }
}
