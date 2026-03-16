using System;
using SendGrid;
using SendGrid.Helpers.Mail;
using Xunit;

namespace JessesPizza.WebApp.Tests
{
    public class EmailTest
    {
        [Fact]
        static async void SendEmail()
        {
            var apiKey = "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";
            var client = new SendGridClient(apiKey);
            var from = new EmailAddress("admin@codexposed.com", "Example User");
            var subject = "Sending with SendGrid is Fun";
            var to = new EmailAddress("mutlusean@gmail.com", "Example User");
            var plainTextContent = "and easy to do anywhere, even with C#";
            var htmlContent = "<strong>and easy to do anywhere, even with C#</strong>";
            var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);
            var response = await client.SendEmailAsync(msg);
        }
        [Fact]
        static async void SettingsTest()
        {
        }

    }
}
