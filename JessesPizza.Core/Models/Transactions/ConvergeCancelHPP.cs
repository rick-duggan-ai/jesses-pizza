using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models
{
    public class ConvergeCancelHPP
    {
        public string errorCode { get; set; }
        public string errorName { get; set; }
        public string errorMessage { get; set; }
        public string ssl_amount { get; set; }
        //public string ssl_approval_code{ get; set; }
        public string ssl_card_short_description { get; set; }

        public string ssl_token_response { get; set; }
        public string ssl_token { get; set; }
        public string ssl_add_token_response { get; set; }
        public string ssl_exp_date { get; set; }
        //public string ssl_txn_id { get; set; }
        public string ssl_transaction_type { get; set; }

        public string ssl_result { get; set; }
        //public string ssl_result_message { get; set; }
        public string ssl_card_number { get; set; }
        //public string ssl_cvv2_response { get; set; }

        public string ssl_txn_time { get; set; }
        public string ssl_last_name { get; set; }
        public string ssl_first_name { get; set; }

    }
}


