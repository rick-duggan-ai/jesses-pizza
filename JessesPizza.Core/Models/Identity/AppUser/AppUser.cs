using JessesPizza.Core.Models.Identity;
using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models
{
    public class AppUser
    {
        public string Token { get; set; }
        public DateTime? TokenExpires { get; set; }

        public bool IsGuest { get; set; }
    }
    public class AppSecret
    {
        public string Secret { get; set; }
        public string DeviceId { get; set; }

    }
}
