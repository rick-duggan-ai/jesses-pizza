using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace JessesPizza.Core.Models
{
    public class MainMenuItemWrapper
    {
        public MainMenuItemWrapper()
        {

        }
        public MainMenuItemWrapper(MainMenuItem item)
        {
            Id = item.Id;
            this.Name = item.Name;
            this.ImageUrl = item.ImageUrl;
            Ordinal = item.Ordinal;
            MenuItems =  item.MenuItems;
            Selected = "notSelected";
        }
        public int Ordinal { get; set; }

        public string Selected { get; set; }
        public string Id { get; set; }
        public string Name { get; set; }
        public List<JessesMenuItem> MenuItems { get; set; }
        public string ImageUrl { get; set; }

    }
}
