using System.Collections.Generic;
using System.Collections.ObjectModel;

namespace JessesPizzaKitchen.Models
{
    public class Grouping<PaymentParent, ShoppingCartItem> : ObservableCollection<ShoppingCartItem>
    {
        public PaymentParent Key { get; private set; }

        public Grouping(PaymentParent key, IEnumerable<ShoppingCartItem> items)
        {
            Key = key;
            foreach (var item in items)
                this.Items.Add(item);
        }
    }
}
