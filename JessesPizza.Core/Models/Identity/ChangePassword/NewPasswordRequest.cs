using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Identity
{
    public class NewPasswordRequest
    {
        public string PhoneNumber { get; set; }
        public string Password { get; set; }
    }
}
