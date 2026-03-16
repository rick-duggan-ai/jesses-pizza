using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace JessesPizza.Core.Models
{
    public class MainMenuItem
    {
        public MainMenuItem()
        {

        }
        public MainMenuItem(MainMenuItem item)
        {
            this.Name = item.Name;
            this.ImageUrl = item.ImageUrl;
            Ordinal = item.Ordinal;
            MenuItems = new List<JessesMenuItem>();
        }
        [BsonId, BsonRepresentation(BsonType.ObjectId)]
        public string Id { get; set; }

        [BsonElement("mainMenuItemName")]
        [Required]
        public string Name { get; set; }

        [BsonElement("jessesMenuItems")]
        public List<JessesMenuItem> MenuItems { get; set; }
        [Required]
        [BsonElement("imageUrl")]
        public string ImageUrl { get; set; }
        [Required]
        [BsonElement("ordinal")]
        public int Ordinal { get; set; }


    }
}
