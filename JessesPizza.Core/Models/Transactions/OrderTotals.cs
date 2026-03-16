using SQLite;

namespace JessesPizza.Core.Models.Transactions
{
    [Table("OrderTotals")]
    public class OrderTotals
    {
        [PrimaryKey, AutoIncrement, Column("_id")]
        public int Id { get; set; }
        public decimal TaxTotal { get; set; }
        public decimal DeliveryCharge { get; set; }
        public decimal SubTotal { get; set; }
        public decimal Total { get; set; }
        public decimal Tip { get; set; }
        public string SpecialInstructions { get; set; }

    }
}
