using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Identity
{
    public class ForgotPasswordRequest
    {
        public string PhoneNumber { get; set; }
        public string DeviceId { get; set; }
    }
}
