using JessesPizza.Core.Models.Transactions;
using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Identity
{
    public class GetAccountInfoResponse
    {
        public CustomerInfoApp Info {get;set;}
        public string Message { get; set; }
        public bool Succeeded { get; set; }

    }
}
