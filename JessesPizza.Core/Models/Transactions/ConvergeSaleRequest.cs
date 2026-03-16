using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Transactions
{
    public class ConvergeSaleRequest
    {
        public string ssl_merchant_id { get; set; }
        public string ssl_user_id { get; set; }
        public string ssl_pin { get; set; }
        public string ssl_test_mode { get; set; }
        public string ssl_transaction_type { get; set; }

        public string ssl_token { get; set; }
        public string ssl_exp_date { get; set; }

        public string ssl_amount { get; set; }

        public string ssl_last_name { get; set; }
        public string ssl_first_name { get; set; }


        public ConvergeSaleRequest()
        {

        }
        public ConvergeSaleRequest(ConvergeHPPTokenResponse tokenResponse, JessesPizzaSettings settings,MongoTransaction transaction)
        {
            ssl_transaction_type = "ccsale";
            ssl_test_mode = "false";
            ssl_token = tokenResponse.ssl_token;
            ssl_exp_date = tokenResponse.ssl_exp_date;
            ssl_amount = tokenResponse.ssl_amount;
            ssl_last_name = tokenResponse.ssl_last_name;
            ssl_merchant_id = settings.MerchantId;
            ssl_user_id = settings.UserId;
            ssl_pin = settings.Pin;
            if (transaction.Name.Length > 20)
                ssl_first_name = transaction.Name.Substring(0, 20);
            else
                ssl_first_name = transaction.Name;
        }
        public ConvergeSaleRequest(ConvergeHPPTokenResponse tokenResponse, JessesPizzaSettings settings, MongoTransactionV1_1 transaction)
        {
            ssl_transaction_type = "ccsale";
            ssl_test_mode = "false";
            ssl_token = tokenResponse.ssl_token;
            ssl_exp_date = tokenResponse.ssl_exp_date;
            ssl_amount = tokenResponse.ssl_amount;
            ssl_last_name = tokenResponse.ssl_last_name;
            ssl_merchant_id = settings.MerchantId;
            ssl_user_id = settings.UserId;
            ssl_pin = settings.Pin;
            if (transaction.Name.Length > 20)
                ssl_first_name = transaction.Name.Substring(0, 20);
            else
                ssl_first_name = transaction.Name;
        }
        public ConvergeSaleRequest(CreditCard card, JessesPizzaSettings settings, MongoTransaction transaction,string CustomerCode)
        {
            ssl_transaction_type = "ccsale";
            ssl_test_mode = "false";
            ssl_token = card.Token.ToString();
            ssl_exp_date = card.ExpirationDate;
            ssl_amount = transaction.Total.ToString("0.##");
            if (CustomerCode.Length > 20)
                ssl_last_name = CustomerCode.Substring(0, 20);
            else
                ssl_last_name = CustomerCode;
            ssl_merchant_id = settings.MerchantId;
            ssl_user_id = settings.UserId;
            ssl_pin = settings.Pin;
            if (transaction.Name.Length > 20)
                ssl_first_name = transaction.Name.Substring(0, 20);
            else
                ssl_first_name = transaction.Name;
        }
        public override string ToString()
        {
            return string.Concat($"<txn>\r\n<ssl_merchant_id>{ssl_merchant_id}</ssl_merchant_id>\r\n<ssl_user_id>{ssl_user_id}</ssl_user_id>\r\n<ssl_pin>{ssl_pin}</ssl_pin>\r\n<ssl_transaction_type>{ssl_transaction_type}</ssl_transaction_type>\r\n<ssl_test_mode>false</ssl_test_mode>\r\n<ssl_token>{ssl_token}</ssl_token>\r\n<ssl_exp_date>{ssl_exp_date}</ssl_exp_date>\r\n<ssl_amount>{ssl_amount}</ssl_amount>\r\n<ssl_last_name>{ssl_last_name}</ssl_last_name>\r\n<ssl_first_name>{ssl_first_name}</ssl_first_name>\r\n</txn>");
            
        }
    }
}
