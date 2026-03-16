using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace JessesPizza.WebApp.Data
{
    public static class ApplicationDbInitializer
    {
        public static void SeedUsers(UserManager<IdentityUser> userManager)
        {
            //if (userManager.FindByEmailAsync("darren@jessespizza.com").Result == null)
            //{
            //    IdentityUser user = new IdentityUser
            //    {
            //        UserName = "darren@jessespizza.com",
            //        Email = "darren@jessespizza.com",
            //        EmailConfirmed=true
            //    };

            //    IdentityResult result = userManager.CreateAsync(user, "P@ssw0rd").Result;

            //}
            if (userManager.FindByEmailAsync("darren@jessespizza.com").Result == null)
            {
                IdentityUser user = new IdentityUser
                {
                    UserName = "darren@jessespizza.com",
                    Email = "darren@jessespizza.com",
                    EmailConfirmed = true
                };
                IdentityResult result = userManager.CreateAsync(user, "P@ssw0rd").Result;
            }
            if (userManager.FindByEmailAsync("admin@codexposed.com").Result == null)
            {
                IdentityUser admin = new IdentityUser
                {
                    UserName = "admin@codexposed.com",
                    Email = "admin@codexposed.com",
                    EmailConfirmed = true
                };
                var adminResult = userManager.CreateAsync(admin, "P@ssw0rd").Result;
            }

        }
    }
}
