using JessesPizza.Core.Models;
using System;

namespace JessesPizzaKitchen.Models
{
    public class UpdateTransactionStateRequest
    {
        public Guid TransactionGuid;
        public TransactionState State;  
    }
}
