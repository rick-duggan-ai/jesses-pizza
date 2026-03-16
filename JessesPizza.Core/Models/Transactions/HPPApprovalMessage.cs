using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Transactions
{
    public class HPPApprovalMessage
    {
        public Guid TransactionGuid { get; set; }
        public bool IsGuest { get; set; }
        public bool IsCardSaved { get; set; }

        public CreditCard Card { get; set; }
    }
}
