using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Identity
{
    public class SignUpRequest
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public CustomerInfo Info { get; set; }
    }
}
