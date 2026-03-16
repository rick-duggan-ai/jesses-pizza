using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Transactions
{


    // NOTE: Generated code may require at least .N ET Framework 4.5 or .NET Core/Standard 2.0.
    /// <remarks/>
    [System.SerializableAttribute()]
    [System.ComponentModel.DesignerCategoryAttribute("code")]
    [System.Xml.Serialization.XmlTypeAttribute(AnonymousType = true)]
    [System.Xml.Serialization.XmlRootAttribute(Namespace = "", IsNullable = false)]
    public partial class txn
    {

        private string ssl_merchant_initiated_unscheduledField;

        private byte ssl_issuer_responseField;

        private string ssl_card_numberField;

        private object ssl_departure_dateField;

        private string ssl_oar_dataField;

        private byte ssl_resultField;

        private string ssl_txn_idField;

        private object ssl_avs_responseField;

        private string ssl_approval_codeField;

        private decimal ssl_amountField;

        private string ssl_txn_timeField;

        private object ssl_descriptionField;

        private ushort ssl_exp_dateField;

        private decimal ssl_base_amountField;

        private object ssl_get_tokenField;

        private object ssl_completion_dateField;

        private string ssl_card_short_descriptionField;

        private string ssl_token_responseField;

        private object ssl_tip_amountField;

        private string ssl_card_typeField;

        private string ssl_transaction_typeField;

        private decimal ssl_account_balanceField;

        private string ssl_ps2000_dataField;

        private string ssl_result_messageField;

        private object ssl_serverField;

        private object ssl_invoice_numberField;

        private object ssl_cvv2_responseField;

        private ulong ssl_tokenField;

        private byte ssl_partner_app_idField;
        private ushort errorCodeField;

        private string errorNameField;

        private string errorMessageField;

        /// <remarks/>
        public ushort errorCode
        {
            get
            {
                return this.errorCodeField;
            }
            set
            {
                this.errorCodeField = value;
            }
        }

        /// <remarks/>
        public string errorName
        {
            get
            {
                return this.errorNameField;
            }
            set
            {
                this.errorNameField = value;
            }
        }

        /// <remarks/>
        public string errorMessage
        {
            get
            {
                return this.errorMessageField;
            }
            set
            {
                this.errorMessageField = value;
            }
        }

        /// <remarks/>
        public string ssl_merchant_initiated_unscheduled
        {
            get
            {
                return this.ssl_merchant_initiated_unscheduledField;
            }
            set
            {
                this.ssl_merchant_initiated_unscheduledField = value;
            }
        }

        /// <remarks/>
        public byte ssl_issuer_response
        {
            get
            {
                return this.ssl_issuer_responseField;
            }
            set
            {
                this.ssl_issuer_responseField = value;
            }
        }

        /// <remarks/>
        public string ssl_card_number
        {
            get
            {
                return this.ssl_card_numberField;
            }
            set
            {
                this.ssl_card_numberField = value;
            }
        }

        /// <remarks/>
        public object ssl_departure_date
        {
            get
            {
                return this.ssl_departure_dateField;
            }
            set
            {
                this.ssl_departure_dateField = value;
            }
        }

        /// <remarks/>
        public string ssl_oar_data
        {
            get
            {
                return this.ssl_oar_dataField;
            }
            set
            {
                this.ssl_oar_dataField = value;
            }
        }

        /// <remarks/>
        public byte ssl_result
        {
            get
            {
                return this.ssl_resultField;
            }
            set
            {
                this.ssl_resultField = value;
            }
        }

        /// <remarks/>
        public string ssl_txn_id
        {
            get
            {
                return this.ssl_txn_idField;
            }
            set
            {
                this.ssl_txn_idField = value;
            }
        }

        /// <remarks/>
        public object ssl_avs_response
        {
            get
            {
                return this.ssl_avs_responseField;
            }
            set
            {
                this.ssl_avs_responseField = value;
            }
        }

        /// <remarks/>
        public string ssl_approval_code
        {
            get
            {
                return this.ssl_approval_codeField;
            }
            set
            {
                this.ssl_approval_codeField = value;
            }
        }

        /// <remarks/>
        public decimal ssl_amount
        {
            get
            {
                return this.ssl_amountField;
            }
            set
            {
                this.ssl_amountField = value;
            }
        }

        /// <remarks/>
        public string ssl_txn_time
        {
            get
            {
                return this.ssl_txn_timeField;
            }
            set
            {
                this.ssl_txn_timeField = value;
            }
        }

        /// <remarks/>
        public object ssl_description
        {
            get
            {
                return this.ssl_descriptionField;
            }
            set
            {
                this.ssl_descriptionField = value;
            }
        }

        /// <remarks/>
        public ushort ssl_exp_date
        {
            get
            {
                return this.ssl_exp_dateField;
            }
            set
            {
                this.ssl_exp_dateField = value;
            }
        }

        /// <remarks/>
        public decimal ssl_base_amount
        {
            get
            {
                return this.ssl_base_amountField;
            }
            set
            {
                this.ssl_base_amountField = value;
            }
        }

        /// <remarks/>
        public object ssl_get_token
        {
            get
            {
                return this.ssl_get_tokenField;
            }
            set
            {
                this.ssl_get_tokenField = value;
            }
        }

        /// <remarks/>
        public object ssl_completion_date
        {
            get
            {
                return this.ssl_completion_dateField;
            }
            set
            {
                this.ssl_completion_dateField = value;
            }
        }

        /// <remarks/>
        public string ssl_card_short_description
        {
            get
            {
                return this.ssl_card_short_descriptionField;
            }
            set
            {
                this.ssl_card_short_descriptionField = value;
            }
        }

        /// <remarks/>
        public string ssl_token_response
        {
            get
            {
                return this.ssl_token_responseField;
            }
            set
            {
                this.ssl_token_responseField = value;
            }
        }

        /// <remarks/>
        public object ssl_tip_amount
        {
            get
            {
                return this.ssl_tip_amountField;
            }
            set
            {
                this.ssl_tip_amountField = value;
            }
        }

        /// <remarks/>
        public string ssl_card_type
        {
            get
            {
                return this.ssl_card_typeField;
            }
            set
            {
                this.ssl_card_typeField = value;
            }
        }

        /// <remarks/>
        public string ssl_transaction_type
        {
            get
            {
                return this.ssl_transaction_typeField;
            }
            set
            {
                this.ssl_transaction_typeField = value;
            }
        }

        /// <remarks/>
        public decimal ssl_account_balance
        {
            get
            {
                return this.ssl_account_balanceField;
            }
            set
            {
                this.ssl_account_balanceField = value;
            }
        }

        /// <remarks/>
        public string ssl_ps2000_data
        {
            get
            {
                return this.ssl_ps2000_dataField;
            }
            set
            {
                this.ssl_ps2000_dataField = value;
            }
        }

        /// <remarks/>
        public string ssl_result_message
        {
            get
            {
                return this.ssl_result_messageField;
            }
            set
            {
                this.ssl_result_messageField = value;
            }
        }

        /// <remarks/>
        public object ssl_server
        {
            get
            {
                return this.ssl_serverField;
            }
            set
            {
                this.ssl_serverField = value;
            }
        }

        /// <remarks/>
        public object ssl_invoice_number
        {
            get
            {
                return this.ssl_invoice_numberField;
            }
            set
            {
                this.ssl_invoice_numberField = value;
            }
        }

        /// <remarks/>
        public object ssl_cvv2_response
        {
            get
            {
                return this.ssl_cvv2_responseField;
            }
            set
            {
                this.ssl_cvv2_responseField = value;
            }
        }

        /// <remarks/>
        public ulong ssl_token
        {
            get
            {
                return this.ssl_tokenField;
            }
            set
            {
                this.ssl_tokenField = value;
            }
        }

        /// <remarks/>
        public byte ssl_partner_app_id
        {
            get
            {
                return this.ssl_partner_app_idField;
            }
            set
            {
                this.ssl_partner_app_idField = value;
            }
        }
    }

}
