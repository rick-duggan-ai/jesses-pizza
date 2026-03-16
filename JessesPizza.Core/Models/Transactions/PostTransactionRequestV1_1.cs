using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Transactions
{
    public class PostTransactionRequestV1_1
    {

        public LocalTransactionV1_1 Transaction { get; set; }
        public CreditCard Card { get; set; }
        public PostTransactionRequestV1_1()
        {
                
        }
        public PostTransactionRequestV1_1(SqliteTransaction transaction, List<ShoppingCartItem> items)
        {
            Transaction = new LocalTransactionV1_1
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
        public PostTransactionRequestV1_1(LocalTransactionV1_1 transaction, CreditCard card)
        {
            Transaction = transaction;
            Card = card;
        }
    }
}
