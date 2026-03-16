using System;
using System.Collections.Generic;

namespace JessesPizza.Core.Models.Transactions
{
    public class LocalTransactionV1_1 : LocalTransaction
    {
        public bool NoContactDelivery { get; set; }
        public string SpecialInstructions { get; set; }

        public LocalTransactionV1_1(SqliteTransaction transaction, List<ShoppingCartItem> items, OrderTotals totals)
        {
            Info = new CustomerInfoApp();
            Info.AddressLine1 = transaction.Address1;
            Info.City = transaction.City;
            Info.EmailAddress = transaction.Email;
            Info.FirstName = transaction.FirstName;
            Info.LastName = transaction.LastName;
            Info.PhoneNumber = transaction.PhoneNumber;
            Info.ZipCode = transaction.ZipCode;
            IsDelivery = transaction.IsDelivery;
            TransactionItems = items;
            Totals = totals;
            SpecialInstructions = totals.SpecialInstructions;

        }
        public LocalTransactionV1_1(SqliteTransaction transaction, List<ShoppingCartItem> items, OrderTotals totals, CustomerInfoApp info)
        {
            Info = new CustomerInfoApp();
            Info.AddressLine1 = info.AddressLine1;
            Info.City = info.City;
            Info.EmailAddress = info.EmailAddress;
            Info.FirstName = info.FirstName;
            Info.LastName = info.LastName;
            Info.PhoneNumber = info.PhoneNumber;
            Info.ZipCode = transaction.ZipCode;
            TransactionItems = items;
            Totals = totals;
            IsDelivery = transaction.IsDelivery;
            SpecialInstructions = totals.SpecialInstructions;
        }
        public LocalTransactionV1_1()
        {

        }
    }
}
