using System;
using System.Collections.Generic;
using JessesPizza.Core.Models.Identity;
using MongoDB.Bson.Serialization.Attributes;
using Destructurama.Attributed;
namespace JessesPizza.Core.Models.Transactions
{
    public class MongoTransaction
    {
        [BsonId]
        public Guid TransactionGuid { get; set; }
        [BsonElement("date")]
        public DateTime Date { get; set; }
        [NotLogged]
        [BsonElement("shoppingCartItems")]
        public List<ShoppingCartItem> Items { get; set; }
        [BsonElement("name")]
        public string Name { get; set; }
        [BsonElement("phoneNumber")]
        public string PhoneNumber { get; set; }
        [BsonElement("address")]
        public string Address1 { get; set; }
        [BsonElement("email")]
        public string Email { get; set; }
        [BsonElement("city")]
        public string City { get; set; }
        [BsonElement("zipCode")]
        public string ZipCode { get; set; }
        [BsonElement("transactionState")]
        public TransactionState TransactionState { get; set; }
        [BsonElement("taxTotal")]
        public decimal TaxTotal { get; set; }
        [BsonElement("deliveryCharge")]
        public decimal DeliveryCharge { get; set; }
        [BsonElement("tip")]
        public decimal Tip { get; set; }
        [BsonElement("subTotal")]
        public decimal SubTotal { get; set; }
        [BsonElement("total")]
        public decimal Total { get; set; }
        [BsonElement("hppToken")]
        public string HPPToken { get; set; }
        [BsonElement("convergeTransactionId")]
        public string ConvergeTransactionId { get; set; }
        public string Claim { get; set; }
        
        public bool IsDelivery { get; set; }

        [BsonElement("cardPreview")]
        public string CardPreview { get; set; }
        [BsonElement("expDate")]
        public string ExpDate { get; set; }
        [BsonElement("cardShortDescription")]
        public string CardShortDescription { get; set; }
        public MongoTransaction(LocalTransaction localTransaction, CustomerInfo info)
        {
            Items = localTransaction.TransactionItems;
            Name = string.Concat(info.FirstName, " ", info.LastName);
            PhoneNumber = info.PhoneNumber;
            Address1 = info.Address;
            Email = localTransaction.Info.EmailAddress;
            Claim = info.Email;
            City = info.City;
            ZipCode = localTransaction.Info.ZipCode;
            TransactionState = TransactionState.Validated;
            TaxTotal = localTransaction.Totals.TaxTotal;
            DeliveryCharge = localTransaction.Totals.DeliveryCharge;
            SubTotal = localTransaction.Totals.SubTotal;
            Total = localTransaction.Totals.Total;
            Tip = localTransaction.Totals.Tip;
            IsDelivery= localTransaction.IsDelivery;
        }

        public MongoTransaction(LocalTransaction localTransaction)
        {
            Items = localTransaction.TransactionItems;
            Address1 = localTransaction.Info.AddressLine1;
            City = localTransaction.Info.City;
            ZipCode = localTransaction.Info.ZipCode;
            TransactionState = TransactionState.Validated;
            TaxTotal = localTransaction.Totals.TaxTotal;
            DeliveryCharge = localTransaction.Totals.DeliveryCharge;
            SubTotal = localTransaction.Totals.SubTotal;
            Total = localTransaction.Totals.Total;
            Tip = localTransaction.Totals.Tip;
            IsDelivery = localTransaction.IsDelivery;
            Claim = "Guest";
            Email = localTransaction.Info.EmailAddress;
            PhoneNumber = localTransaction.Info.PhoneNumber;
           
        }
        public MongoTransaction()
        {

        }
    }
}
