using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using JessesPizza.Data;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using JessesPizza.WebApp.Areas.Identity;
using JessesPizza.WebApp.Data;
using JessesPizza.Core.Models;
using Microsoft.Extensions.FileProviders;
using System.IO;
using Radzen;
using Serilog;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using JessesPizza.WebApp.Services;
using System.Diagnostics;
using Destructurama;
using Microsoft.Extensions.Logging;
using Serilog.Events;

namespace JessesPizza.WebApp
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
            Serilog.Debugging.SelfLog.Enable(msg => Debug.WriteLine(msg));
            //var logConfiguration = new LoggerConfiguration()
            //    .WriteTo.File("JessesWebLogs/JessesWebLog.log", rollingInterval: RollingInterval.Day)
            //    .WriteTo.Console()
            //    .Destructure.UsingAttributes()
            //    .ReadFrom.Configuration(Configuration);

            //Log.Logger = logConfiguration.CreateLogger();


            var outputTemplate = "[{Timestamp:hh:mm:ss tt}] [{Level:u3}] [{MemberName}:{LineNumber}] {Message} {NewLine}{Exception}";

            Serilog.Log.Logger = new LoggerConfiguration()
                        .MinimumLevel.Information()
                        .Enrich.FromLogContext()
                        .WriteTo.File("JessesWebLogs/JessesWebLog.log", Serilog.Events.LogEventLevel.Information, outputTemplate: outputTemplate, rollingInterval: RollingInterval.Day, retainedFileCountLimit: 30)
                        .WriteTo.Console(LogEventLevel.Warning, outputTemplate)
                        .CreateLogger();
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=398940
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddDbContext<ApplicationDbContext>(options =>
                options.UseSqlite(
                    Configuration.GetConnectionString("DefaultConnection")));
            services.AddDefaultIdentity<IdentityUser>(options => options.SignIn.RequireConfirmedAccount = true)
                .AddEntityFrameworkStores<ApplicationDbContext>();
            services.AddTransient<IEmailSender, EmailSender>();
            services.Configure<AuthMessageSenderOptions>(Configuration);
            services.AddRazorPages()
                 .AddRazorPagesOptions(options =>
                 {
                     options.Conventions.AuthorizePage("/mainmenuitems");
                     options.Conventions.AuthorizePage("/groupspage");
                     options.Conventions.AuthorizePage("/");
                     options.Conventions.AuthorizePage("/Index");
                     
                 });
            services.AddServerSideBlazor();
            services.AddTelerikBlazor();
            services.AddControllersWithViews();


            services.AddScoped<AuthenticationStateProvider, RevalidatingIdentityAuthenticationStateProvider<IdentityUser>>();
            services.AddScoped<IPizzaRepo, PizzaRepo>();
            services.AddScoped<DialogService>();
            services.AddSingleton<NotificationService>();
            services.ConfigureApplicationCookie(options =>
            {
                options.LoginPath = $"/Identity/Account/Login";
                options.LogoutPath = $"/Identity/Account/Logout";
                options.AccessDeniedPath = $"/Identity/Account/AccessDenied";
            });
            //services.AddSingleton<IEmailSender, EmailSender>();

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env, UserManager<IdentityUser> userManager)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseDatabaseErrorPage();
            }
            else
            {
                app.UseExceptionHandler("/Error");
                // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
                app.UseHsts();
            }

            //app.UseHttpsRedirection();
            app.UseStaticFiles();
            //app.UseStaticFiles(new StaticFileOptions
            //{
            //    FileProvider = new PhysicalFileProvider(
            //            Path.Combine(Directory.GetCurrentDirectory(), "MyStaticFiles")),
            //    RequestPath = "/StaticFiles",
            //    ServeUnknownFileTypes= true
            //});
            app.UseRouting();

            app.UseAuthentication();
            app.UseAuthorization();
            app.UseSerilogRequestLogging();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
                endpoints.MapBlazorHub();
                endpoints.MapFallbackToPage("/_Host");
            });
            ApplicationDbInitializer.SeedUsers(userManager);

        }
    }
}
