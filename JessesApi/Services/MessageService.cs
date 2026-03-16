using JessesApi.Views;
using JessesPizza.Data;
using SendGrid;
using SendGrid.Helpers.Mail;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Twilio;
using Twilio.Rest.Api.V2010.Account;

namespace JessesApi.Services
{
    public static class MessageService
    {
        public static async Task SendOrderCompleteEmailsAsync(OrderCompleteEmailModel model, string customerEmailAddress, string customerName,IPizzaRepo pizzaRepo, IRazorViewToStringRenderer razorViewToStringRenderer)
        {
            var settings = await pizzaRepo.GetSettings();
            string body = await razorViewToStringRenderer.RenderViewToStringAsync("/Views/OrderCompleteEmail.cshtml", model);
            string customerBody = await razorViewToStringRenderer.RenderViewToStringAsync("/Views/OrderCompleteEmailCustomer.cshtml", model);

            var client = new SendGridClient(settings.SendGridKey);
            var from = new EmailAddress("admin@codexposed.com", "Jesse's Pizza");
            var subject = "Jesse's Pizza: Order Completed";
            var to = new EmailAddress("mutlusean@gmail.com", "Sean");
            var customer = new EmailAddress(customerEmailAddress, customerName);
            var plainTextContent = "";
            var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, body);
            var customerMsg = MailHelper.CreateSingleEmail(from, customer, subject, plainTextContent, customerBody);

            var response = await client.SendEmailAsync(msg);
            await client.SendEmailAsync(customerMsg);
        }
        public static async Task SendText(string text, string phoneNumber)
        {
                const string accountSid = "ACde8dd5c7de4fe8e38244f633a788858e";
                const string authToken = "1b8915e12f81fa2a2992bc8ef7abbb15";
                TwilioClient.Init(accountSid, authToken);
                var message = MessageResource.Create(
                body: text,
                from: new Twilio.Types.PhoneNumber("+12073674787"),
                to: new Twilio.Types.PhoneNumber(phoneNumber)
                );
        }
    }
}
