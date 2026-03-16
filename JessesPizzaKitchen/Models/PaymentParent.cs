using JessesPizza.Core.Models.Transactions;
using System;
using System.Runtime.InteropServices;

namespace JessesPizzaKitchen.Models
{
    public class PaymentParent
    {
        public Guid TransactionGuid { get; set; }
        public DateTime Date { get; set; }
        public string Name { get; set; }
        public string PhoneNumber { get; set; }
        public string Address1 { get; set; }
        public string Email { get; set; }
        public string City { get; set; }
        public string ZipCode { get; set; }
        public JessesPizza.Core.Models.TransactionState TransactionState { get; set; }
        public decimal TaxTotal { get; set; }
        public decimal DeliveryCharge { get; set; }
        public decimal SubTotal { get; set; }
        public decimal Total { get; set; }
        public decimal Tip { get; set; }
        public bool IsDelivery { get; set; }
        public bool NoContact { get; set; }
        public string SpecialInstructions { get; set; }
        public bool HasSpecialInstructions { get; set; }

        public string HPPToken { get; set; }
        public string ConvergeTransactionId { get; set; }
        public double Version { get; set; }
        public PaymentParent()
        {

        }
        public PaymentParent(JessesPizza.Core.Models.Transactions.MongoTransaction payment)
        {
                Name = payment.Name;
                ConvergeTransactionId = payment.ConvergeTransactionId;
                HPPToken = payment.HPPToken;
                Total = payment.Total;
                PhoneNumber = payment.PhoneNumber;
                DeliveryCharge = payment.DeliveryCharge;
                TimeZoneInfo pdt;
                //Get Time zone info on windows, if not use linux convention
                if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                    pdt = TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time");
                else
                    pdt = TimeZoneInfo.FindSystemTimeZoneById("America/Los_Angeles");

                Date = TimeZoneInfo.ConvertTimeFromUtc(payment.Date, pdt); Email = payment.Email;
                Address1 = payment.Address1;
                City = payment.City;
                SubTotal = payment.SubTotal;
                ZipCode = payment.ZipCode;
                TaxTotal = payment.TaxTotal;
                TransactionGuid = payment.TransactionGuid;
                TransactionState = payment.TransactionState;
                IsDelivery = payment.IsDelivery;
                NoContact = false;
                SpecialInstructions = null;
                HasSpecialInstructions = false;
                Version = 1.0;
        }
        public PaymentParent(MongoTransactionV1_1 payment,string version)
        {
            Name = payment.Name;
            ConvergeTransactionId = payment.ConvergeTransactionId;
            HPPToken = payment.HPPToken;
            Total = payment.Total;
            PhoneNumber = payment.PhoneNumber;
            DeliveryCharge = payment.DeliveryCharge;
            TimeZoneInfo pdt;
            //Get Time zone info on windows, if not use linux convention
            if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                pdt = TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time");
            else
                pdt = TimeZoneInfo.FindSystemTimeZoneById("America/Los_Angeles");

            Date = TimeZoneInfo.ConvertTimeFromUtc(payment.Date, pdt);
            //Date = payment.Date - TimeSpan.FromHours(8);
            Email = payment.Email;
            Address1 = payment.Address1;
            City = payment.City;
            SubTotal = payment.SubTotal;
            ZipCode = payment.ZipCode;
            TaxTotal = payment.TaxTotal;
            TransactionGuid = payment.TransactionGuid;
            TransactionState = payment.TransactionState;
            IsDelivery = payment.IsDelivery;
            NoContact = payment.NoContactDelivery;
            SpecialInstructions = payment.SpecialInstructionsForOrder;
            HasSpecialInstructions = !string.IsNullOrEmpty(payment.SpecialInstructionsForOrder);
            Version = 1.1;
        }
    }
}
