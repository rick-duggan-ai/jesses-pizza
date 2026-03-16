using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Transactions
{
    public class ConvergeHPPTokenRequest
    {
        public string ssl_merchant_id { get; set; }
        public string ssl_user_id { get; set; }
        public string ssl_pin { get; set; }
        public string ssl_transaction_type { get; set; }
        public string ssl_amount { get; set; }

        public string ssl_last_name { get; set; }
        public string ssl_first_name { get; set; }

    }
}
