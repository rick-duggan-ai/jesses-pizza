using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Transactions
{
    public class GetOrdersResponse
    {
        public string Message { get; set; }
        public bool Succeeded { get; set; }
        public List<MongoTransaction> Transactions { get; set; }
    }
}
