using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Transactions
{
    public class GetOrdersResponseV1_1
    {
        public string Message { get; set; }
        public bool Succeeded { get; set; }
        public List<MongoTransactionV1_1> Transactions { get; set; }
    }
}
