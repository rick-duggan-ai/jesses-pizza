using SQLite;

namespace JessesPizza.Core.Models
{
    [Table("ShoppingCart")]
    public class ShoppingCartItem
    {
        [PrimaryKey, AutoIncrement, Column("_id")]
        public int Id { get; set; }

        public string MenuItemId { get; set; }

        public string Name { get; set; }

        public string Description { get; set; }

        public string SizeName { get; set; }
        public string SelectedSizeId { get; set; }

        public string ImageUrl { get; set; }


        public bool RequiredChoicesEnabled { get; set; }
        public string RequiredChoices { get; set; }
        public string RequiredDelimitedString { get; set; }

        public bool OptionalChoicesEnabled { get; set; }
        public string OptionalChoices { get; set; }
        public string OptionalDelimitedString { get; set; }
        public int Quantity { get; set; }

        public decimal Price { get; set; }

        public bool InstructionsEnabled { get; set; }
        public string Instructions { get; set; }
    }
}
