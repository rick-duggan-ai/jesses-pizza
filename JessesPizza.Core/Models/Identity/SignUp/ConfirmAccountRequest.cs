using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Identity
{
    public class ConfirmAccountRequest
    {
        public string Code { get; set; }
        public string Email { get; set; }
    }
}
