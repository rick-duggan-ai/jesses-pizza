using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.ViewModels
{
    class MongoTransactionViewModel
    {

        public Guid TransactionGuid { get; set; }
        public DateTime Date { get; set; }
        public List<ShoppingCartItem> Items { get; set; }
        public string Name { get; set; }
        public string PhoneNumber { get; set; }
        public string Address1 { get; set; }
        public string Email { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
        public TransactionState TransactionState { get; set; }
        public decimal TaxTotal { get; set; }
        public decimal DeliveryCharge { get; set; }
        public decimal SubTotal { get; set; }
        public decimal Total { get; set; }
        public string HPPToken { get; set; }
        public string ItemsListString { get; set; }

        public MongoTransactionViewModel(MongoTransaction transaction)
        {
            TransactionGuid = transaction.TransactionGuid;
            Date = transaction.Date.ToLocalTime();
            Name = transaction.Name;
            PhoneNumber = transaction.PhoneNumber;
            Address1 = transaction.Address1;
            Email = transaction.Email;
            City = transaction.City;
            ZipCode = transaction.ZipCode;
            TransactionState = transaction.TransactionState;
            TaxTotal = transaction.TaxTotal;
            DeliveryCharge = transaction.DeliveryCharge;
            SubTotal = transaction.SubTotal;
            Total = transaction.Total;
            HPPToken = transaction.HPPToken;
            string temp = "";
            foreach (var item in transaction.Items)
            {
                temp = string.Concat(temp, "\u2022 ", item.Name, $"({item.SizeName})\n");
                if(item.Quantity != 1)
                    temp = string.Concat(temp, $"- Quantity: {item.Quantity}\n");
                if (item.RequiredChoicesEnabled)
                    temp = string.Concat(temp, $"- {item.RequiredChoices}\n");
                if (item.OptionalChoicesEnabled)
                    temp = string.Concat(temp, $"- {item.OptionalChoices}\n");
                if (item.InstructionsEnabled)
                    temp = string.Concat(temp, $"- Special Instructions: {item.Instructions}\n");

            }
            ItemsListString = temp;
        }
        public MongoTransactionViewModel(MongoTransactionV1_1 transaction)
        {
            TransactionGuid = transaction.TransactionGuid;
            Date = transaction.Date.ToLocalTime();
            Name = transaction.Name;
            PhoneNumber = transaction.PhoneNumber;
            Address1 = transaction.Address1;
            Email = transaction.Email;
            City = transaction.City;
            ZipCode = transaction.ZipCode;
            TransactionState = transaction.TransactionState;
            TaxTotal = transaction.TaxTotal;
            DeliveryCharge = transaction.DeliveryCharge;
            SubTotal = transaction.SubTotal;
            Total = transaction.Total;
            HPPToken = transaction.HPPToken;
            string temp = "";
            foreach (var item in transaction.Items)
            {
                temp = string.Concat(temp, "\u2022 ", item.Name, $"({item.SizeName})\n");
                if (item.Quantity != 1)
                    temp = string.Concat(temp, $"- Quantity: {item.Quantity}\n");
                if (item.RequiredChoicesEnabled)
                    temp = string.Concat(temp, $"- {item.RequiredChoices}\n");
                if (item.OptionalChoicesEnabled)
                    temp = string.Concat(temp, $"- {item.OptionalChoices}\n");
                if (item.InstructionsEnabled)
                    temp = string.Concat(temp, $"- Special Instructions: {item.Instructions}\n");

            }
            ItemsListString = temp;
        }
    }
}
