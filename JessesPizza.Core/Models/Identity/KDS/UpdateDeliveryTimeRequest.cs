using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Identity
{
    public class UpdateDeliveryTimeRequest
    {
        public string FirstName { get; set; }
        public string PhoneNumber { get; set; }
        public string Message { get; set; }
        public bool IsDelivery { get; set; }
    }
}
