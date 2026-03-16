using JessesPizza.Core.Models.Transactions;
using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Identity
{
    public class DeleteAccountResponse
    {
        public string Message { get; set; }
        public bool Succeeded { get; set; }

    }
}
