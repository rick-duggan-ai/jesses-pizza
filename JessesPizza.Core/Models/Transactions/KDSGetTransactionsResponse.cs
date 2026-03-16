using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Transactions
{
    public class KDSGetTransactionsResponse
    {
        public List<MongoTransaction> Transactions { get; set; }
        public List<MongoTransactionV1_1> TransactionsV1_1 { get; set; }

    }
}
