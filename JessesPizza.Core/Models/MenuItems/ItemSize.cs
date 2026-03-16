using System.ComponentModel.DataAnnotations;

namespace JessesPizza.Core.Models
{
    public class ItemSize
    {
        [Required]
        public string Name { get; set; }
        [Required]
        public decimal Price { get; set; }
        [Required]
        public bool Default { get; set; }
    }
}
