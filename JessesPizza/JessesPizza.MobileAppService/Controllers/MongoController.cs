using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Flurl;
using Flurl.Http;

using JessesPizza.Core.Models.Transactions;
using JessesPizza.Data;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using MongoDB.Bson;
using Swashbuckle.AspNetCore.Annotations;
using MongoDB.Driver;
using Flurl.Http.Xml;
using System.IO;
using System.Xml.Serialization;
using System.Globalization;
using txn = JessesPizza.Core.Models.Transactions.txn;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using TimeZoneConverter;
using System.Runtime.InteropServices;
using SendGrid;
using SendGrid.Helpers.Mail;
using JessesPizza.MobileAppService.Services;
using JessesPizza.MobileAppService.Views;

namespace JessesPizza.MobileAppService.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [SwaggerTag("MongoDb Related Actions")]
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    public class MongoController : Controller
    {
        private readonly IPizzaRepo _pizzaRepo;
        private readonly IHubContext<PizzaHub> _hubContext;
        private readonly ILogger<MongoController> _logger;
        private readonly IRazorViewToStringRenderer _razorViewToStringRenderer;

        public MongoController(IPizzaRepo pizzaRepo, IHubContext<PizzaHub> hubContext, ILogger<MongoController> logger, IRazorViewToStringRenderer razorViewToStringRenderer)
        {
            _pizzaRepo = pizzaRepo;
            _hubContext = hubContext;
            _logger = logger;
            _razorViewToStringRenderer = razorViewToStringRenderer;

        }
        [AllowAnonymous]
        [HttpGet(), Route("EmailTest")]
        public async Task<IActionResult> SendEmail()
        {
            try
            {
                var groups = await _pizzaRepo.GetAllGroups();
                var transactions = await _pizzaRepo.GetAllTransactions();
                var transaction = transactions.Where(x => x.Items.Count > 3).FirstOrDefault();
                var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                var model = new OrderCompleteEmailModel(transaction, groups, mainMenuItems) { };

                string body = await _razorViewToStringRenderer.RenderViewToStringAsync("/Views/OrderCompleteEmail.cshtml", model);
                var apiKey = "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";
                var client = new SendGridClient(apiKey);
                var from = new EmailAddress("admin@codexposed.com", "Jesse's Pizza");
                var subject = "Jesse's Pizza: Order Completed";
                var to = new EmailAddress("mutlusean@gmail.com", "Sean");
                var plainTextContent = "";
                var htmlContent = body;
                var msg = MailHelper.CreateSingleEmail(from, to, subject, plainTextContent, htmlContent);
                var response = await client.SendEmailAsync(msg);
                return Ok();
            }
            catch (Exception e)
            {
                _logger.LogError("Unable to retrieve MainMenuItems, because: {ExceptionMessage}", e);
                return StatusCode(500);
            }
        }
        private async Task SendOrderCompleteEmailsAsync(OrderCompleteEmailModel model, string customerEmailAddress, string customerName)
        {
            var settings = await _pizzaRepo.GetSettings();
            string body = await _razorViewToStringRenderer.RenderViewToStringAsync("/Views/OrderCompleteEmail.cshtml", model);
            string customerBody = await _razorViewToStringRenderer.RenderViewToStringAsync("/Views/OrderCompleteEmailCustomer.cshtml", model);

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

        #region Transactions
        [HttpGet("approval")]
        [Consumes("application/x-www-form-urlencoded")]
        [AllowAnonymous]
        public async Task<ContentResult> ApprovalHostedPaymentsPage([FromQuery] ConvergeHPPTokenResponse transaction)
        {
            string response = "";
            //Get the transaction we created previously
            var mongoTransaction = await _pizzaRepo.GetTransactionByGuid(new Guid(transaction.ssl_customer_code));
            var blankContentResponse = new ContentResult { ContentType = "text/html", Content = "" };
            try
            {
                //Make sure the token was sucessfully generated
                if (transaction.ssl_token_response != "SUCCESS")
                {
                    await _hubContext.Clients.All.SendAsync("HPPDecline", transaction.ssl_customer_code, "");
                    return blankContentResponse;
                }
                //check transaction state to make sure we haven't already processed it
                if (mongoTransaction.TransactionState == TransactionState.Authorized)
                {
                    await _hubContext.Clients.All.SendAsync("HPPCancel", transaction.ssl_customer_code, "");
                    return blankContentResponse;
                }
                //Build xml sale request
                var settings = await _pizzaRepo.GetSettings();
                var saleRequest = new ConvergeSaleRequest(transaction, settings, mongoTransaction);
                System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(saleRequest.GetType());
                var convergeUrl = "https://api.demo.convergepay.com/VirtualMerchantDemo/processxml.do";
                var xml = saleRequest.ToString();
                //Send Request to converge
                response = await convergeUrl.WithHeader("Content-Type", "application/x-www-form-urlencoded").PostStringAsync(xml).ReceiveString();
                var serializer = new XmlSerializer(typeof(txn));
                txn result;
                //Try to deserialize, if the payment was declined it will go to catch because xml bodies are different
                using (TextReader reader = new StringReader(response))
                {
                    result = (txn)serializer.Deserialize(reader);
                }
                // check if payment was approved
                if (result.ssl_result_message != "APPROVAL")
                {
                    await _hubContext.Clients.All.SendAsync("HPPDecline", transaction.ssl_customer_code, "");
                    return blankContentResponse;
                }
                // Payment was approved if we got here, grab what we want to store in Mongo from the converge response
                mongoTransaction.Date = DateTime.UtcNow;
                mongoTransaction.TransactionState = TransactionState.Authorized;
                //mongoTransaction.CardPreview = result.ssl_card_number;
                //mongoTransaction.ExpDate = result.ssl_exp_date.ToString();
                //mongoTransaction.CardShortDescription = result.ssl_card_short_description;
                mongoTransaction.ConvergeTransactionId = result.ssl_txn_id;
                // Update the transaction we already created
                await _pizzaRepo.UpdateTransaction(mongoTransaction);
                // Tell Client that they were approved
                await _hubContext.Clients.All.SendAsync("HPPApprove", transaction.ssl_customer_code, "");
                // Tell KDS that a new transaction was posted
                await _hubContext.Clients.All.SendAsync("ReceiveMessage", "Authorized", "");
                // Get data and send email
                var groups = await _pizzaRepo.GetAllGroups();
                var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                var model = new OrderCompleteEmailModel(mongoTransaction, groups, mainMenuItems) { };
                await SendOrderCompleteEmailsAsync(model,mongoTransaction.Email,mongoTransaction.Name);
                // return
                return blankContentResponse;
            }
            catch (Exception e)
            {
                try
                {
                    //xml bodies are different so a DECLINED response from converge will fall here and then we try to deserialize again
                    var serializer = new XmlSerializer(typeof(Core.Models.txn));
                    Core.Models.txn result;
                    using (TextReader reader = new StringReader(response))
                    {
                        result = (Core.Models.txn)serializer.Deserialize(reader);
                    }
                    // if the deserialize worked we know it is declined so tell the customer
                    await _hubContext.Clients.All.SendAsync("HPPDecline", transaction.ssl_customer_code, "");
                    // if the transaction exists on db flag as CANCELLED
                    if (mongoTransaction != null)
                    {
                        await _pizzaRepo.DeleteTransaction(mongoTransaction.TransactionGuid);
                    }
                }
                catch
                {
                    // if we got here something actually went wrong
                    _logger.LogError("Unable to authorize transaction: {@ConvergeHPPTokenResponse}, because {ExceptionMessage}", transaction, e);
                    await _hubContext.Clients.All.SendAsync("HPPCancel", transaction.ssl_customer_code, "");
                }
                return new ContentResult
                {
                    ContentType = "text/html",
                    Content = ""
                };
            }

        }

        //When user presses cancel on HPP Converge redirects to our API and we have to tell customer and we delete transaction
        [HttpGet("CancelPage")]
        [Consumes("application/x-www-form-urlencoded")]
        [AllowAnonymous]
        public async Task<ContentResult> CancelHostedPaymentsPage([FromQuery] ConvergeCancelHPP transaction)
        {
            try
            {
                await _hubContext.Clients.All.SendAsync("HPPCancel", transaction.ssl_customer_code, "");
                var mongoTransaction = await _pizzaRepo.GetTransactionByGuid(new Guid(transaction.ssl_customer_code));
                if (mongoTransaction != null)
                {
                    await _pizzaRepo.DeleteTransaction(mongoTransaction.TransactionGuid);
                }
                return new ContentResult
                {
                    ContentType = "text/html",
                    Content = ""
                };
            }
            catch (Exception e)
            {
                _logger.LogError("Unable to cancel transaction: {@ConvergeCancelHPP}, because {@ExceptionMessage}", transaction, e.Message);
                return null;
            }

        }
        [HttpPost(), Route("GetHPPToken")]
        public async Task<IActionResult> GetHPPToken([FromBody]LocalTransaction localTransaction)
        {
            try
            {
                // get settings for converge account info
                var settings = await _pizzaRepo.GetSettings();
                var convergeUrl = "https://api.demo.convergepay.com/hosted-payments/transaction_token";
                // generate a customerCode so we can keep track of the session
                var customerCode = Guid.NewGuid();
                // build request
                var convergeTokenRequest = new ConvergeHPPTokenRequest() { ssl_customer_code = customerCode.ToString(), ssl_merchant_id = settings.MerchantId, ssl_user_id = settings.UserId, ssl_amount = localTransaction.Totals.Total.ToString("0.00"), ssl_pin = settings.Pin, ssl_transaction_type = "ccgettoken" };
                // Try to get token for HPP page
                var response = await convergeUrl.SendUrlEncodedAsync(HttpMethod.Post, convergeTokenRequest).ReceiveString();

                if (!string.IsNullOrEmpty(response))
                {
                    // we got the token so build a new transaction save to db and return HPP Url to customer
                    var payment = new MongoTransaction(localTransaction);
                    payment.TransactionGuid = customerCode;
                    payment.HPPToken = response;
                    await _pizzaRepo.SaveNewTransaction(payment);
                    var encodedToken = System.Web.HttpUtility.UrlEncode(response);
                    payment.HPPToken = string.Concat("https://api.demo.convergepay.com/hosted-payments/?ssl_txn_auth_token=", encodedToken);
                    return StatusCode(200, payment);
                }
                else return StatusCode(500);
            }
            catch (Exception e)
            {
                _logger.LogError("HPP token request failed: {@LocalTransaction}, because: {@ExceptionMessage}", localTransaction, e);
                return StatusCode(500, false);
            }

        }
        [HttpPost("UpdateTransactionState")]
        public async Task<bool> UpdateTransactionState([FromBody] UpdateTransactionStateRequest request)
        {
            try
            {
                var payment = await _pizzaRepo.GetTransactionByGuid(request.TransactionGuid);
                payment.TransactionState = request.State;
                var updatePayment = await _pizzaRepo.UpdateTransactionState(payment);
                if (updatePayment.TransactionState == request.State)
                {
                    _logger.LogInformation("Updated transaction: {@AuthorizedPayment}", updatePayment);
                    return true;
                }
                _logger.LogError("Failed to update transaction state: {@AuthorizedPayment}", updatePayment);
                return false;
            }
            catch (Exception e)
            {
                _logger.LogError("Unable to update transaction state: {@UpdateTransactionStateRequest}, because {ExceptionMessage}", request, e);
                return false;
            }

        }
        [HttpPost("UpdateTransaction")]
        public async Task<MongoTransaction> UpdateTransaction([FromBody] MongoTransaction transaction)
        {
            try
            {
                var payment = await _pizzaRepo.UpdateTransaction(transaction);
                _logger.LogInformation("Updated transaction: {@AuthorizedPayment}", transaction);
                return payment;
            }
            catch (Exception e)
            {
                _logger.LogError("Unable to update transaction: {@AuthorizedPayment}, because {ExceptionMessage}", transaction, e);
                return null;
            }

        }
        [HttpGet(), Route("Privacy")]
        public IActionResult GetPrivacyPolicy()
        {
            try
            {
                var path = string.Concat(Directory.GetCurrentDirectory(), "/PrivacyPolicy/Privacy.txt");
                var privacyPolicy = System.IO.File.ReadAllLines(path);
                if (privacyPolicy != null)
                {
                    var blah = string.Join("\n", privacyPolicy);
                    return StatusCode(200, blah);
                }
                return NotFound();
            }
            catch (Exception e)
            {
                _logger.LogError("Unable to retrieve privacy policy, because {ExceptionMessage}", e.Message);
                return StatusCode(500);
            }
        }

        [HttpGet(), Route("Transactions/OrderInfo")]
        public async Task<IActionResult> GetOrderInfo()
        {
            try
            {
                var settings = await _pizzaRepo.GetSettings();
                if (settings != null)
                {
                    return StatusCode(200, settings);
                }
                return NotFound();
            }
            catch (Exception e)
            {
                _logger.LogError("Unable to retrieve orderInfo, because {ExceptionMessage}", e.Message);
                return StatusCode(500);
            }
        }
        [HttpGet(), Route("Transactions/{state}")]
        public async Task<IActionResult> GetTransactions(TransactionState state)
        {
            try
            {
                var transactions = await _pizzaRepo.GetTransactionsByState(state);
                if (transactions != null)
                {
                    // server is deployed in our time zone, mongo stores dates in utc ALWAYS, so we must go to local time; 
                    TimeZoneInfo pdt;
                    //Get Time zone info on windows, if not use linux convention
                    if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                        pdt = TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time");
                    else
                        pdt = TimeZoneInfo.FindSystemTimeZoneById("America/Los_Angeles");
                    // NOw use timezone info to determine todays date/time
                    var today = DateTime.UtcNow + pdt.GetUtcOffset(DateTime.Now);
                    // find todays transactions
                    var todaysTransactions = transactions.Where(x => (x.Date.Day == today.Day && x.Date.Year == today.Year && x.Date.Month == today.Month));
                    _logger.LogInformation("Returning todays transactions for state: {@TransactionState}", state);
                    return Ok(todaysTransactions);

                }
                return NotFound();
            }
            catch (Exception e)
            {
                _logger.LogError("Unable to retrieve transactions by state: {@TransactionState}, because {ExceptionMessage}", state, e);
                return StatusCode(500);
            }
        }
        [HttpGet(), Route("Transactions")]
        public async Task<IActionResult> GetAllTransactions()
        {
            try
            {
                var transactions = await _pizzaRepo.GetAllTransactions();
                if (transactions != null)
                {
                    _logger.LogInformation("Returning ALL transactions");
                    return Ok(transactions);
                }
                return NotFound();
            }
            catch (Exception e)
            {
                _logger.LogError("Unable to retrieve ALL transactions, because {ExceptionMessage}", e);
                return StatusCode(500);
            }
        }

        [HttpGet(), Route("TransactionGuid")]
        public async Task<IActionResult> GetTransactionByGuid(Guid transactionGuid)
        {
            try
            {
                var transaction = await _pizzaRepo.GetTransactionByGuid(transactionGuid);
                if (transaction != null)
                {
                    _logger.LogInformation("Returning transaction with {@Guid}", transactionGuid);
                    return Ok(transaction);
                }
                return NotFound();
            }
            catch (Exception e)
            {
                _logger.LogError("Failed to retrieve transaction with {@Guid}, because {ExceptionMessage}", transactionGuid, e);
                return StatusCode(500);
            }
        }

        [HttpPost("ValidateTransaction")]
        public async Task<TransactionValidationResponse> ValidateTransaction([FromBody] LocalTransaction transaction)
        {

            try
            {
                var settings = await _pizzaRepo.GetSettings();
                var day = settings.StoreHours.FirstOrDefault()?.Day.ToString();
                var hoursToday = settings.StoreHours.FirstOrDefault(x => x.Day.ToString() == DateTime.Now.DayOfWeek.ToString());
                var utc = DateTime.UtcNow;
                TimeZoneInfo pdt;
                //Get Time zone info on windows, if not use linux convention
                if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                    pdt = TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time");
                else
                    pdt = TimeZoneInfo.FindSystemTimeZoneById("America/Los_Angeles");
                DateTime pdtTime = TimeZoneInfo.ConvertTimeFromUtc(utc, pdt);

                if (!TimeBetween(pdtTime, hoursToday.OpeningTime.Value.TimeOfDay, hoursToday.ClosingTime.Value.TimeOfDay))
                {
                    return new TransactionValidationResponse() { Succeeded = false, Message = $"Store is not open. Hours today are from {hoursToday.OpeningTime.Value.ToString("h:mm tt")} to {hoursToday.ClosingTime.Value.ToString("h:mm tt")}" };
                }
                List<string> ZipCodes = new List<string>();
                foreach (var zipcode in settings.ZipCodes)
                {
                    ZipCodes.Add(zipcode.ZipCodeValue.ToString());
                }
                if (!ZipCodes.Contains(transaction.Info.ZipCode.ToString()))
                {
                    _logger.LogWarning("Zip Code out of range");
                    return new TransactionValidationResponse() { Succeeded = false, Message = "Zip Code out of range" };
                }
                if (transaction.Info.City.Trim().ToUpper() != "HENDERSON")
                {
                    _logger.LogWarning("City out of range");
                    return new TransactionValidationResponse() { Succeeded = false, Message = "City out of range" };
                }
                _logger.LogInformation("Validated transaction: {@LocalTransaction}", transaction);
                return new TransactionValidationResponse() { Succeeded = true, TransactionGuid = Guid.NewGuid() };
            }
            catch (Exception e)
            {
                _logger.LogError("Failed to validate transaction: {@LocalTransaction}, because: {@Exception.Message} with inner exception: {@Exception.Message}", transaction, e.Message, e.InnerException.Message);
                return new TransactionValidationResponse() { Succeeded = false, Message = "Validation Failed" };
            }

        }
        [HttpPost("ValidateTransactionAmount")]
        public async Task<TransactionValidationResponse> ValidateTransactionAmount([FromBody] decimal amount)
        {

            try
            {
                var settings = await _pizzaRepo.GetSettings();
                if (amount < settings.MinimumOrderAmount)
                {
                    _logger.LogWarning($"Total must be at least {settings.MinimumOrderAmount:C}");
                    return new TransactionValidationResponse() { Succeeded = false, Message = $"Total must be at least {string.Format("{0:$.00}", settings.MinimumOrderAmount)}" };
                }
                return new TransactionValidationResponse() { Succeeded = true, TransactionGuid = Guid.NewGuid() };
            }
            catch (Exception e)
            {
                return new TransactionValidationResponse() { Succeeded = false, Message = "Validation Failed" };
            }

        }
        private bool TimeBetween(DateTime datetime, TimeSpan start, TimeSpan end)
        {
            // convert datetime to a TimeSpan
            TimeSpan now = datetime.TimeOfDay;
            // see if start comes before end
            if (start < end)
                return start <= now && now <= end;
            // start is after end, so do the inverse comparison
            return !(end < now && now < start);
        }

        #endregion


        #region Groups

        [HttpGet(), Route("Groups")]
        public async Task<IActionResult> GetGroups()
        {
            try
            {
                var groups = await _pizzaRepo.GetAllGroups();
                _logger.LogInformation("Returning Groups");
                return Ok(groups);
            }
            catch (Exception e)
            {
                _logger.LogError("Unable to retrieve groups, because: {ExceptionMessage}", e);
                return StatusCode(500);
            }
        }
        #endregion

        [HttpGet(), Route("MainMenuItems")]
        public async Task<IActionResult> GetMainMenuItems()
        {
            try
            {
                var menuItems = await _pizzaRepo.GetAllMainMenuItems();
                _logger.LogInformation("Returning MainMenuItems");
                return Ok(menuItems);
            }
            catch (Exception e)
            {
                _logger.LogError("Unable to retrieve MainMenuItems, because: {ExceptionMessage}", e);
                return StatusCode(500);
            }
        }

    }
}