using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Identity
{
    public class ConfirmPasswordChangeRequest
    {
        public string Code { get; set; }
        public string PhoneNumber { get; set; }
    }
}
