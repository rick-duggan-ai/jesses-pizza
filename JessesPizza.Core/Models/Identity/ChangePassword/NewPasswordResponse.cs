using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models.Identity
{
    public class NewPasswordResponse
    {
        public string Message { get; set; }
        public bool Succeeded { get; set; }
        public string Token { get; set; }
        public DateTime? TokenExpires { get; set; }
    }
}
