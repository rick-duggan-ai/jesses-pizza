using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Transactions
{
    public class CreditCard
    {
        public Guid Id { get; set; }
        public string CardNumber { get; set; }
        public string ExpirationDate { get; set; }
        public string ShortDescription { get; set; }
        public ulong Token { get; set; }
    }
}
