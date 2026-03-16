using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Identity
{
    public class ConfirmPasswordChangeResponse
    {
        public string Message { get; set; }
        public bool Succeeded { get; set; }
    }
}
