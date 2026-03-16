using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace JessesPizza.WebApp.Pages.Privacy
{
    public class PrivacyModel : PageModel
    {
        public string PrivacyString { get; set; }
        public AppUser AppUser { get; set; } = new AppUser();

        public void OnGet()
        {
        }
    }
}
