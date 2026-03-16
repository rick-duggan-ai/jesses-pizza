using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace JessesPizza.Core.Models
{
    public class JessesMenuItem
    {
        public JessesMenuItem()
        {

        }
        public JessesMenuItem(JessesMenuItem item)
        {
            Name = item.Name;
            Description = item.Description;
            Sizes = item.Sizes;
            ImageUrl = item.ImageUrl;
        }
        [BsonId, BsonRepresentation(BsonType.ObjectId)]
        public string Id { get; set; }

        [BsonElement("menuItemName")]
        [Required]
        public string Name { get; set; }
        [Required]
        [BsonElement("imageUrl")] 
        public string ImageUrl { get; set; }

        [BsonElement("description")]
        [Required]
        public string Description { get; set; }

        [BsonElement("sizes")]
        public List<JessesItemSize> Sizes { get; set; }




    }
}
