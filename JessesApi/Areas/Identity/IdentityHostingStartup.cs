using System;
using AspNetCore.Identity.MongoDbCore.Infrastructure;
using JessesApi.Areas.Identity.Data;
using JessesApi.Data;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

[assembly: HostingStartup(typeof(JessesApi.Areas.Identity.IdentityHostingStartup))]
namespace JessesApi.Areas.Identity
{
    public class IdentityHostingStartup : IHostingStartup
    {
        public void Configure(IWebHostBuilder builder)
        {
            builder.ConfigureServices((context, services) =>
            {
                //    services.AddDbContext<JessesApiContext>(options =>
                //        options.UseSqlServer(
                //            context.Configuration.GetConnectionString("JessesApiContextConnection")));

            //services.AddDefaultIdentity<JessesAppUser>(options => options.SignIn.RequireConfirmedAccount = true)
            //    .AddEntityFrameworkStores<JessesApiContext>();
            services.AddIdentity<JessesAppUser, JessesAppRole>()
                        .AddSignInManager()
                        //.AddMongoDbStores<JessesAppUser, JessesAppRole, Guid>
                        //(
                        //    "mongodb+srv://mert:Passw00rd@jessespizzaaws-4xeqz.mongodb.net/JessesPizzaDB?retryWrites=true&w=majority",
                        //    "MongoDBTest"
                        //)
                        .AddMongoDbStores<JessesAppUser, JessesAppRole, Guid>
                        (
                            Environment.GetEnvironmentVariable("MONGO_CONNECTION_STRING"),
                            "MongoDBTest"
                        )
                        
    .AddDefaultTokenProviders();
            });
        }
    }
}