using System;

namespace JessesPizza.Core.Models.Transactions
{
    public class TransactionValidationResponse
    {
        public Guid TransactionGuid { get; set; }
        public string Message { get; set; }
        public bool Succeeded { get; set; }
    }
}
