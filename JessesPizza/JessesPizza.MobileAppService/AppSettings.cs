
using System;
using System.Collections.Generic;
using System.IO;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Builder;
using Serilog;

namespace JessesPizza.MobileAppService
{
    public class AppSettings
    {
        public string Secret { get; set; }
    }
}
