using System;
using SQLite;

namespace JessesPizza.Core.Models.Transactions
{
    public class SqliteTransaction
    {
        [PrimaryKey, AutoIncrement, Column("_id")]
        public int Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PhoneNumber { get; set; }
        public string Address1 { get; set; }
        public string Email { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
        public Guid TransactionGuid { get; set; }
        public decimal TaxTotal { get; set; }
        public decimal DeliveryCharge { get; set; }
        public decimal SubTotal { get; set; }
        public decimal Total { get; set; }
        public decimal Tip { get; set; }
        public bool IsDelivery { get; set; }

        public SqliteTransaction(CustomerInfoApp info)
        {
            Address1 = info.AddressLine1;
            City = info.City;
            Email = info.EmailAddress;
            FirstName = info.FirstName;
            LastName = info.LastName;
            PhoneNumber = info.PhoneNumber;
            ZipCode = info.ZipCode;
        }
        public SqliteTransaction(LocalTransaction transaction)
        {
            Address1 = transaction.Info.AddressLine1;
            City = transaction.Info.City;
            Email = transaction.Info.EmailAddress;
            FirstName = transaction.Info.FirstName;
            LastName = transaction.Info.LastName;
            PhoneNumber = transaction.Info.PhoneNumber;
            ZipCode = transaction.Info.ZipCode;
            TaxTotal = transaction.Totals.TaxTotal;
            Total = transaction.Totals.Total;
            Tip = transaction.Totals.Tip;
            SubTotal = transaction.Totals.SubTotal;
            DeliveryCharge = transaction.Totals.DeliveryCharge;
            IsDelivery = transaction.IsDelivery;
        }
        public SqliteTransaction()
        {

        }
    }
}
