using System;
using System.Collections.Generic;
using JessesPizza.Core.Models.Identity;
using MongoDB.Bson.Serialization.Attributes;
namespace JessesPizza.Core.Models.Transactions
{
    public class MongoTransactionV1_1 :MongoTransaction
    {
        public bool NoContactDelivery { get; set; }
        public string SpecialInstructionsForOrder { get; set; }
        public TransactionStateV1_1 TransactionStateV1_1 { get; set; }

        public MongoTransactionV1_1(LocalTransaction localTransaction, CustomerInfo info)
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
        public MongoTransactionV1_1(LocalTransactionV1_1 localTransaction, CustomerInfo info)
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
            IsDelivery = localTransaction.IsDelivery;
            SpecialInstructionsForOrder = localTransaction.SpecialInstructions;
        }

        public MongoTransactionV1_1(LocalTransaction localTransaction)
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
        public MongoTransactionV1_1(LocalTransactionV1_1 localTransaction)
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
            NoContactDelivery = localTransaction.NoContactDelivery;
            SpecialInstructionsForOrder = localTransaction.SpecialInstructions;

        }
        public MongoTransactionV1_1()
        {

        }
        public MongoTransactionV1_1(MongoTransaction transaction)
        {
            Items = transaction.Items;
            Address1 = transaction.Address1;
            City = transaction.City;
            ZipCode = transaction.ZipCode;
            TransactionStateV1_1 = (TransactionStateV1_1)transaction.TransactionState;
            TaxTotal = transaction.TaxTotal;
            DeliveryCharge = transaction.DeliveryCharge;
            SubTotal = transaction.SubTotal;
            Total = transaction.Total;
            Tip = transaction.Tip;
            IsDelivery = transaction.IsDelivery;
            Claim = transaction.Claim;
            Email = transaction.Email;
            PhoneNumber = transaction.PhoneNumber;
            NoContactDelivery = false;
            SpecialInstructionsForOrder = "";
            Name = transaction.Name;
            Date = transaction.Date;
            ConvergeTransactionId = transaction.ConvergeTransactionId;
        }
    }
}
