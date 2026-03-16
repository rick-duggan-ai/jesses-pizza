using System;

namespace JessesPizza.Core.Models.Transactions
{
    public class UpdateTransactionStateRequest
    {
        public Guid TransactionGuid { get; set; }
        public TransactionState State { get; set; }
    }
}
