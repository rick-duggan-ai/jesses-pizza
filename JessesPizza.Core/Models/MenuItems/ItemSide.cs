using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models
{
    public class ItemSide
    {

        public string Name { get; set; }
        public decimal Price { get; set; }
        
        public string Icon { get; set; }
        public bool IsDefault { get; set; }
   }
}
