using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Transactions
{
    public class PostTransactionRequest
    {

        public LocalTransaction Transaction { get; set; }
        public CreditCard Card { get; set; }
        public PostTransactionRequest()
        {
                
        }
        public PostTransactionRequest(SqliteTransaction transaction, List<ShoppingCartItem> items)
        {
            Transaction = new LocalTransaction
            {
                Info = new CustomerInfoApp()
                { 
                    AddressLine1 = transaction.Address1,
                    City = transaction.City,
                    //EmailAddress = transaction.Email,
                    //FirstName = transaction.FirstName,
                    //LastName = transaction.LastName,
                    //PhoneNumber = transaction.PhoneNumber,
                    ZipCode = transaction.ZipCode
                },
                Totals = new OrderTotals()
                {
                    DeliveryCharge = transaction.DeliveryCharge,
                    SubTotal = transaction.SubTotal,
                    TaxTotal = transaction.TaxTotal,
                    Tip = transaction.Tip,
                    Total = transaction.Total

                },
                TransactionItems = items
            };
        }
        public PostTransactionRequest(LocalTransaction transaction, CreditCard card)
        {
            Transaction = transaction;
            Card = card;
        }
    }
}
