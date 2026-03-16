using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using Microsoft.AspNetCore.Mvc;
using Flurl.Http;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Data;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using Swashbuckle.AspNetCore.Annotations;
using MongoDB.Driver;
using System.IO;
using System.Xml.Serialization;
using txn = JessesPizza.Core.Models.Transactions.txn;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using System.Runtime.InteropServices;
using JessesApi.Services;
using JessesApi.Views;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using System.Security.Claims;
using JessesApi.Areas.Identity.Data;
using Microsoft.AspNetCore.Identity;
using JessesPizza.Core.Models.Identity;
using static Twilio.Rest.Api.V2010.Account.Call.FeedbackSummaryResource;
using Microsoft.AspNetCore.Identity.UI.Services;
using Newtonsoft.Json;
using System.ComponentModel;
using System.Globalization;
using Microsoft.AspNetCore.Http;
using System.Security.Cryptography;

namespace JessesApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [ApiVersion("1.0")]
    [ApiVersion("1.1")]
    [SwaggerTag("MongoDb Related Actions")]
    [Authorize(AuthenticationSchemes = JwtBearerDefaults.AuthenticationScheme)]
    public class MongoController : Controller
    {
        private readonly IPizzaRepo _pizzaRepo;
        private readonly IHubContext<PizzaHub> _hubContext;
        private readonly ILogger<MongoController> _logger;
        private readonly IRazorViewToStringRenderer _razorViewToStringRenderer;
        private readonly ICacheService _cache;
        public IEmailSender _emailSender { get; set; }
        //private static Serilog.ILogger Log => Serilog.Log.Logger.Here().ForContext<MongoController>();

        public UserManager<JessesAppUser> _userManager { get; }

        public MongoController(IPizzaRepo pizzaRepo, IHubContext<PizzaHub> hubContext, ILogger<MongoController> logger, IRazorViewToStringRenderer razorViewToStringRenderer, UserManager<JessesAppUser> userManager, ICacheService cache, IEmailSender emailSender)
        {
            _pizzaRepo = pizzaRepo;
            _hubContext = hubContext;
            _logger = logger;
            _razorViewToStringRenderer = razorViewToStringRenderer;
            _userManager = userManager;
            _cache = cache;
            _emailSender = emailSender;
        }
        /// <summary>
        /// Returns menu items from Jesse's Pizza
        /// </summary>
        [HttpGet(), Route("MainMenuItems")]
        public async Task<IActionResult> GetMainMenuItems()
        {
            try
            {
                var menuItems = await _pizzaRepo.GetAllMainMenuItems();
                Serilog.Log.Logger.Here().Information("Returning MainMenuItems");
                return Ok(menuItems);
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to retrieve MainMenuItems, because: {@Exception}", e);
                return StatusCode(500);
            }
        }
        /// <summary>
        /// Checks the store hours
        /// </summary>
        [HttpGet("CheckHours")]
        public async Task<bool> CheckHours()
        {

            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the CheckHours method");
                var settings = await _pizzaRepo.GetSettings();
                //var day = settings.StoreHours.FirstOrDefault()?.Day.ToString();
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
                    Serilog.Log.Logger.Here().Information($"{pdtTime} was not between {hoursToday.OpeningTime.Value.TimeOfDay} and {hoursToday.ClosingTime.Value.TimeOfDay} ");
                    return false;
                }

                return true;
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Failed to check store hours, because: {@Exception}", e);
                return false;
            }

        }
        /// <summary>
        /// Gets previous orders associated with account V1.1
        /// </summary>
        [MapToApiVersion("1.1")]
        [HttpGet(), Route("GetOrders")]
        public async Task<IActionResult> GetOrdersV1_1()
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the GetOrdersV1_1 method");
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                var normalizedEmail = email.ToUpper();
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.Email.ToUpper() == normalizedEmail);
                if (user != null)
                {
                    if (user.TransactionIds != null)
                    {
                        if (user.TransactionIds.Count() != 0)
                        {
                            var transactions = await _pizzaRepo.GetTransactionsForUserV1_1(user.TransactionIds);
                            Serilog.Log.Logger.Here().Information($"Returning transactions for user : {user.Email}");
                            return Ok(new GetOrdersResponseV1_1() { Transactions = transactions, Succeeded = true }); ;
                        }
                        else
                            return Ok(new GetOrdersResponseV1_1() { Transactions = new List<MongoTransactionV1_1>(), Succeeded = true }); ;

                    }
                    return Ok(new GetOrdersResponseV1_1() { Transactions = new List<MongoTransactionV1_1>(), Succeeded = true });

                }
                {
                    Serilog.Log.Logger.Here().Error($"Token provided with email address: {email} did not match any accounts on the database in GetOrdersV1_1");
                    return Ok(new GetOrdersResponseV1_1() { Transactions = new List<MongoTransactionV1_1>(), Succeeded = false, Message = "Unable to retrieve orders" });
                }

            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to retrieve orders, because: {ExceptionMessage}", e);
                return Ok(new GetOrdersResponseV1_1() { Succeeded = false, Message = "Something went wrong" });
            }
        }
        /// <summary>
        /// Gets previous orders associated with account
        /// </summary>
        [MapToApiVersion("1.0")]
        [HttpGet(), Route("GetOrders")]
        public async Task<IActionResult> GetOrders()
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the GetOrders method");
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                var normalizedEmail = email.ToUpper();
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.Email.ToUpper() == normalizedEmail);
                if (user != null)
                {
                    if (user.TransactionIds != null)
                    {
                        if (user.TransactionIds.Count() != 0)
                        {
                            var transactions = await _pizzaRepo.GetTransactionsForUser(user.TransactionIds);
                            Serilog.Log.Logger.Here().Information($"Returning transactions for user : {user.Email}");
                            return Ok(new GetOrdersResponse() { Transactions = transactions, Succeeded = true }); ;
                        }
                        else
                            return Ok(new GetOrdersResponse() { Transactions = new List<MongoTransaction>(), Succeeded = true }); ;

                    }
                    return Ok(new GetOrdersResponse() { Transactions = new List<MongoTransaction>(), Succeeded = true });

                }
                Serilog.Log.Logger.Here().Error($"Token provided with email address: {email} did not match any accounts on the database in GetOrders");
                return Ok(new GetOrdersResponse() { Transactions = new List<MongoTransaction>(), Succeeded = false, Message = "Unable to retrieve orders" });
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to retrieve orders, because: {ExceptionMessage}", e);
                return Ok(new GetOrdersResponse() { Succeeded = false, Message = "Something went wrong" });
            }
        }
        private async Task SendOrderCompleteEmailsAsync(OrderCompleteEmailModel model, CustomerEmailModel customerModel, string customerEmailAddress, string customerName)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the SendOrderCompleteEmails method");
                var settings = await _pizzaRepo.GetSettings();
                string body = await _razorViewToStringRenderer.RenderViewToStringAsync("/Views/OrderCompleteEmail.cshtml", model);
                string customerBody = await _razorViewToStringRenderer.RenderViewToStringAsync("/Views/OrderCompleteEmailCustomer.cshtml", customerModel);
                string subject = "Jesse's Pizza: Order Complete";
                if (model.Transaction != null)
                {
                    if (model.Transaction.IsDelivery)
                        subject = "Jesse's Pizza: A new order has been placed for Delivery";
                    else if (model.NoContact)
                        subject = "Jesse's Pizza: A new order has been placed for NO CONTACT Delivery";
                    else
                        subject = "Jesse's Pizza: A new order has been placed for Pickup";
                }
                var customerSubject = "Your order from Jesse's Pizza is being processed";
                Serilog.Log.Logger.Here().Information($"SendOrderCompleteEmails to customer {customerEmailAddress} and admin {settings.AdminEmail}");
                await _emailSender.SendEmailAsync(customerEmailAddress, customerSubject, customerBody);
                await _emailSender.SendEmailAsync(settings.AdminEmail, subject, body);
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error($"Failed to SendOrderCompleteEmails because {e.Message}");
            }
        }
        private async Task SendOrderFailedEmailAsync(OrderFailedEmailModel model)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the SendOrderFailedEmail method");
                var settings = await _pizzaRepo.GetSettings();
                string body = await _razorViewToStringRenderer.RenderViewToStringAsync("/Views/OrderFailedEmail.cshtml", model);
                var subject = "Jesse's Pizza: Failed to process transaction";
                await _emailSender.SendEmailAsync(settings.AdminEmail, subject, body);
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error($"Failed to SendOrderFailedEmails because {e.Message}");
            }
        }
        private async Task SendOrderFailedEmailAsync(ConvergeHPPTokenResponse transaction, MongoTransaction mongoTransaction,txn result)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the SendOrderFailedEmail method");
                var settings = await _pizzaRepo.GetSettings();
                string body = $"Xml request to Elavon was not successful for transaction:" +
                    $"\r\n{JsonConvert.SerializeObject(transaction)} \r\n " +
                    $"and on db" +
                    $" \r\n{JsonConvert.SerializeObject(mongoTransaction)}," +
                    $" \r\nElavon responded with:" +
                    $"\r\n{JsonConvert.SerializeObject(result)}";
                var subject = "Jesse's Pizza: Failed to process transaction";
                await _emailSender.SendEmailAsync(settings.AdminEmail, subject, body);
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error($"Failed to SendOrderFailedEmails because {e.Message}");
            }
        }
        
        #region CreditCards
        /// <summary>
        /// Post a transaction with a card previously used 
        /// </summary>
        [MapToApiVersion("1.0")]
        [HttpPost(), Route("PostTransaction")]
        public async Task<IActionResult> PostTransactionWithCreditCard([FromBody]PostTransactionRequest request)
        {
            string response = "";
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the PostTransactionWithCreditCard method");
                //get account info
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                {
                    Serilog.Log.Logger.Here().Error($"Claim was null while trying to PostTransactionWithCreditCard");
                    return NotFound();
                }
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.ToUpper());
                if (user == null)
                {
                    Serilog.Log.Logger.Here().Error($"User with claim {email} came back null trying to PostTransactionWithCreditCard");
                    return Ok(new PostTransactionResponse() { Succeeded = false, Message = "Something went wrong" });
                }
                Serilog.Log.Logger.Here().Information("Processing transaction {@MongoTransaction} for user: {@user}", request.Transaction, user);
                var card = user.CreditCards.Where(x => x.Id == request.Card.Id).FirstOrDefault();
                if (card == null)
                {
                    Serilog.Log.Logger.Here().Information($"Cards were null for app user: {user}");
                    return Ok(new PostTransactionResponse() { Succeeded = false, Message = "Card not found on server" });
                }
                //build Transaction in Mongo
                MongoTransaction mongoTransaction;
                CustomerInfo info = new CustomerInfo()
                {
                    Address = user.Info.Address,
                    City = user.Info.City,
                    Email = user.Info.Email,
                    FirstName = user.Info.FirstName,
                    LastName = user.Info.LastName,
                    PhoneNumber = user.PhoneNumber,
                    State = user.Info.State,
                    ZipCode = user.Info.ZipCode
                };
                mongoTransaction = new MongoTransaction(request.Transaction, info);
                mongoTransaction.Name = string.Concat(char.ToUpper(user.Info.FirstName[0]) + user.Info.FirstName.Substring(1), " ", char.ToUpper(user.Info.LastName[0]) + user.Info.LastName.Substring(1));
                mongoTransaction.PhoneNumber = user.Info.PhoneNumber;
                mongoTransaction.Email = user.Info.Email;
                mongoTransaction.Claim = email;
                mongoTransaction = new MongoTransaction(request.Transaction, info);
                mongoTransaction.TransactionGuid = Guid.NewGuid();
                mongoTransaction.CardPreview = card.CardNumber;
                mongoTransaction.CardShortDescription = card.ShortDescription;
                mongoTransaction.ExpDate = card.ExpirationDate;
                if (user != null)
                {
                    if (user.TransactionIds == null)
                        user.TransactionIds = new List<Guid>();
                    user.TransactionIds.Add(mongoTransaction.TransactionGuid);
                    await _userManager.UpdateAsync(user);

                }
                // get settings for converge account info
                var settings = await _pizzaRepo.GetSettings();
                // build request
                var saleRequest = new ConvergeSaleRequest(card, settings, mongoTransaction, user.Email);
                System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(saleRequest.GetType());
                var xml = saleRequest.ToString();
                //Send Request to converge\
                string convergeUrl;
                if (settings.UseDemoEndpoints)
                {
                    Serilog.Log.Logger.Here().Information("Using demo endpoint to post transaction with credit card");
                    convergeUrl = "https://api.demo.convergepay.com/VirtualMerchantDemo/processxml.do";
                }
                else
                {
                    Serilog.Log.Logger.Here().Information("Using production endpoint to post transaction with credit card");
                    convergeUrl = "https://api.convergepay.com/VirtualMerchant/processxml.do";
                }
                response = await convergeUrl.WithHeader("Content-Type", "application/x-www-form-urlencoded").PostStringAsync(xml).ReceiveString();
                Serilog.Log.Logger.Here().Information($"PostTransactionWithCreditCard received the response from Elavon: {response} for user'{email}'");
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

                    if (result.ssl_result_message == "DECLINED")
                    {
                        mongoTransaction.TransactionState = TransactionState.Declined;
                        mongoTransaction.Date = DateTime.Now;
                        await _pizzaRepo.SaveNewTransaction(mongoTransaction);
                        Serilog.Log.Logger.Here().Error("PostTransactionWithCreditCard got declined by Elavon with request: {@ConvergeSaleRequest} and response: {response}, deserialized as: {@txn} for app user: {@JessesAppUser}", saleRequest,response,result,user);
                        return Ok(new PostTransactionResponse() { Succeeded = false, Message = "Card declined, check funds and try again" });

                    }
                    mongoTransaction.TransactionState = TransactionState.Declined;
                    mongoTransaction.Date = DateTime.Now;
                    await _pizzaRepo.SaveNewTransaction(mongoTransaction);
                    Serilog.Log.Logger.Here().Error("PostTransactionWithCreditCard FAILED when sent to Elavon with request: {@ConvergeSaleRequest} and response: {response}, deserialized as: {@txn} for app user: {@JessesAppUser}", saleRequest, response, result, user);
                    return Ok(new PostTransactionResponse() { Succeeded = false, Message = "Failed to process transaction, please try again" });
                }
                // Payment was approved if we got here, grab what we want to store in Mongo from the converge response
                Serilog.Log.Logger.Here().Information("PostTransactionWithCreditCard was successful with request: {@ConvergeSaleRequest} and response: {response}, deserialized as: {@txn} for app user: {@JessesAppUser}", saleRequest, response, result, user);
                mongoTransaction.Date = DateTime.UtcNow;
                mongoTransaction.TransactionState = TransactionState.Authorized;
                mongoTransaction.ConvergeTransactionId = result.ssl_txn_id;
                var saveResult = await _pizzaRepo.SaveNewTransaction(mongoTransaction);
                if(!saveResult)
                {
                    Serilog.Log.Logger.Here().Error("PostTransactionWithCreditCard failed to save transaction after a successful response from Elavon with request: {@ConvergeSaleRequest} and response: {response}, deserialized as: {result} for transaction: {@MongoTransaction}", saleRequest, response, result, mongoTransaction);
                    var failedGroups = await _pizzaRepo.GetAllGroups();
                    var failedMainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                    var failedModel = new OrderFailedEmailModel(mongoTransaction, failedGroups, failedMainMenuItems, mongoTransaction.IsDelivery) { };
                    await SendOrderFailedEmailAsync(failedModel);
                }
                // Tell KDS that a new transaction was posted
                await _hubContext.Clients.All.SendAsync("ReceiveMessage", "Authorized", "");
                // Get data and send email
                var groups = await _pizzaRepo.GetAllGroups();
                var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                var model = new OrderCompleteEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery) { };
                var customerModel = new CustomerEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery);
                await SendOrderCompleteEmailsAsync(model, customerModel, user.Email, mongoTransaction.Name);
                Serilog.Log.Logger.Here().Information("PostTransactionWithCreditCard successfully saved transaction and sent emails: {@MongoTransaction} for app user: {user.Email}",mongoTransaction,user.Email);
                var encodedToken = System.Web.HttpUtility.UrlEncode(response);
                return Ok(new PostTransactionResponse() { Succeeded = true });
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Failed to process transaction posted with credit card because: {@Exception}", e);
                    return Ok(new PostTransactionResponse() { Succeeded = false, Message = "Failed to process transaction at this time" });
            }

        }
        /// <summary>
        /// Post a transaction with a card previously used Version 1.1
        /// </summary>
        [MapToApiVersion("1.1")]
        [HttpPost(), Route("PostTransaction")]
        public async Task<IActionResult> PostTransactionWithCreditCardV1_1([FromBody]PostTransactionRequestV1_1 request)
        {
            string response = "";
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the PostTransactionWithCreditCardV1_1 method");
                //get account info
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                {
                    Serilog.Log.Logger.Here().Error($"Claim was null while trying to PostTransactionWithCreditCardV1_1");
                    return NotFound();
                }
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.ToUpper());
                if (user == null)
                {
                    Serilog.Log.Logger.Here().Error($"User with claim: '{email}' came back null trying to PostTransactionWithCreditCard");
                    return Ok(new PostTransactionResponse() { Succeeded = false, Message = "Something went wrong" });
                }
                Serilog.Log.Logger.Here().Information("Processing transaction: {@MongoTransaction} for user: {@JessesAppUser}", request.Transaction, user);
                var card = user.CreditCards.Where(x => x.Id == request.Card.Id).FirstOrDefault();
                if (card == null)
                {
                    Serilog.Log.Logger.Here().Information("Cards were null for app user: {@JessesAppUser}", user);
                    return Ok(new PostTransactionResponse() { Succeeded = false, Message = "Card not found on server" });
                }
                //build Transaction in Mongo
                MongoTransactionV1_1 mongoTransaction;
                CustomerInfo info = new CustomerInfo()
                {
                    Address = user.Info.Address,
                    City = user.Info.City,
                    Email = user.Info.Email,
                    FirstName = user.Info.FirstName,
                    LastName = user.Info.LastName,
                    PhoneNumber = user.PhoneNumber,
                    State = user.Info.State,
                    ZipCode = user.Info.ZipCode
                };
                mongoTransaction = new MongoTransactionV1_1(request.Transaction, info);
                mongoTransaction.Name = string.Concat(char.ToUpper(user.Info.FirstName[0]) + user.Info.FirstName.Substring(1), " ", char.ToUpper(user.Info.LastName[0]) + user.Info.LastName.Substring(1));
                mongoTransaction.PhoneNumber = user.Info.PhoneNumber;
                mongoTransaction.Email = user.Info.Email;
                mongoTransaction.Claim = email;
                mongoTransaction.TransactionGuid = Guid.NewGuid();
                mongoTransaction.CardPreview = card.CardNumber;
                mongoTransaction.CardShortDescription = card.ShortDescription;
                mongoTransaction.ExpDate = card.ExpirationDate;
                mongoTransaction.NoContactDelivery = request.Transaction.NoContactDelivery;
                if (user != null)
                {
                    if (user.TransactionIds == null)
                        user.TransactionIds = new List<Guid>();
                    user.TransactionIds.Add(mongoTransaction.TransactionGuid);
                    await _userManager.UpdateAsync(user);

                }
                // get settings for converge account info
                var settings = await _pizzaRepo.GetSettings();
                // build request
                var saleRequest = new ConvergeSaleRequest(card, settings, mongoTransaction, user.Email);
                //Still Getting an error on this field being too long
                if (saleRequest.ssl_last_name.Length > 20)
                    saleRequest.ssl_last_name = saleRequest.ssl_last_name.Substring(0, 20);
                System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(saleRequest.GetType());
                var xml = saleRequest.ToString();
                //Send Request to converge\
                string convergeUrl;
                Serilog.Log.Logger.Here().Information("Attempting to post transaction: {@string}", saleRequest.ToString());

                if (settings.UseDemoEndpoints)
                {
                    Serilog.Log.Logger.Here().Information($"Using demo endpoint to post transaction with credit card for user: '{email}'");
                    convergeUrl = "https://api.demo.convergepay.com/VirtualMerchantDemo/processxml.do";
                }
                else
                {
                    Serilog.Log.Logger.Here().Information($"Using production endpoint to post transaction with credit card for user: '{email}'");
                    convergeUrl = "https://api.convergepay.com/VirtualMerchant/processxml.do";
                }
                response = await convergeUrl.WithHeader("Content-Type", "application/x-www-form-urlencoded").PostStringAsync(xml).ReceiveString();
                Serilog.Log.Logger.Here().Information($"PostTransactionWithCreditCard received the response from Elavon: {response} for user'{email}'"); 
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
                    if (result.ssl_result_message == "DECLINED")
                    {
                        mongoTransaction.TransactionState = TransactionState.Declined;
                        mongoTransaction.Date = DateTime.Now;
                        await _pizzaRepo.SaveNewTransaction(mongoTransaction);
                        Serilog.Log.Logger.Here().Error("PostTransactionWithCreditCard got declined by Elavon with request: {@ConvergeSaleRequest} and response: {response}, deserialized as: {result} for app user: {@JessesAppUser}", saleRequest, response, result, user);
                        return Ok(new PostTransactionResponse() { Succeeded = false, Message = "Card declined, check funds and try again" });

                    }
                    mongoTransaction.TransactionStateV1_1 = TransactionStateV1_1.Failed;
                    mongoTransaction.Date = DateTime.Now;
                    await _pizzaRepo.SaveNewTransaction(mongoTransaction);
                    Serilog.Log.Logger.Here().Error("PostTransactionWithCreditCard FAILED when sent to Elavon with request: {@ConvergeSaleRequest} and response: {response}, deserialized as: {result} for app user: {@JessesAppUser}", saleRequest, response, result, user);
                    return Ok(new PostTransactionResponse() { Succeeded = false, Message = "Failed to process transaction, please try again" });
                }
                // Payment was approved if we got here, grab what we want to store in Mongo from the converge response
                Serilog.Log.Logger.Here().Information("PostTransactionWithCreditCard was successful with request: {@ConvergeSaleRequest} and response: {response}, deserialized as: {result} for app user: {@JessesAppUser}", saleRequest, response, result, user);

                mongoTransaction.Date = DateTime.UtcNow;
                mongoTransaction.TransactionState = TransactionState.Authorized;
                mongoTransaction.ConvergeTransactionId = result.ssl_txn_id;
                await _pizzaRepo.SaveNewTransactionV1_1(mongoTransaction);
                // Tell KDS that a new transaction was posted
                await _hubContext.Clients.All.SendAsync("ReceiveMessage", "Authorized", "");
                // Get data and send email
                var groups = await _pizzaRepo.GetAllGroups();
                var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                var model = new OrderCompleteEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery) { };
                var customerModel = new CustomerEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery);
                await SendOrderCompleteEmailsAsync(model, customerModel, user.Email, mongoTransaction.Name);
                Serilog.Log.Logger.Here().Information("PostTransactionWithCreditCard successfully saved transaction and sent emails: {@MongoTransaction} for app user: {user.Email}",mongoTransaction,user.Email);
                var encodedToken = System.Web.HttpUtility.UrlEncode(response);
                return Ok(new PostTransactionResponse() { Succeeded = true });
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Failed to process transaction posted with credit card because: {@Exception}", e);
                return Ok(new PostTransactionResponse() { Succeeded = false, Message = "Failed to process transaction at this time" });
            }

        }

        [HttpGet(), Route("CreditCards")]
        public async Task<IActionResult> GetCreditCards()
        {
            try
            {
                Serilog.Log.Logger.Here().Information("Entered the GetCreditCards method");

                //Log.Info($"Entered the GetCreditCards method");
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                {
                    Serilog.Log.Logger.Here().Error($"Claim was null while trying to GetCreditCards");
                    return NotFound();
                }
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.Normalize().ToUpper());
                if (user == null)
                {
                    Serilog.Log.Logger.Here().Error($"User with claim '{email}' came back null trying to GetCreditCards");
                    return Ok(new PostTransactionResponse() { Succeeded = false, Message = "Something went wrong" });
                }
                if (user.CreditCards == null)
                {
                    Serilog.Log.Logger.Here().Information($"User with claim '{email}' came back with no GetCreditCards");
                    return Ok(new GetCreditCardsResponse() { CreditCards = new List<CreditCard>(), Succeeded = true });
                }
                if (user.CreditCards.Count() != 0)
                {
                    return Ok(new GetCreditCardsResponse() { CreditCards = user.CreditCards, Succeeded = true });
                }
                return Ok(new GetCreditCardsResponse() { CreditCards = new List<CreditCard>(), Succeeded = true });
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to retrieve credit cards, because: {@Exception}", e);
                return Ok(new GetCreditCardsResponse() { Succeeded = false, Message = "Something went wrong" });
            }
        }
        [HttpPost(), Route("SaveCreditCard")]
        public async Task<IActionResult> SaveCreditCard([FromBody] CreditCard card)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the SaveCreditCard method");
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                {
                    Serilog.Log.Logger.Here().Error($"Claim was null while trying to SaveCreditCard");
                    return NotFound();
                }
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.Normalize().ToUpper());
                if (user == null)
                {
                    Serilog.Log.Logger.Here().Information($"User with claim {email} came back null trying to SaveCreditCard");
                    return Ok(false);
                }
                if (user.CreditCards == null)
                    user.CreditCards = new List<CreditCard>();
                if (card.Id == Guid.Empty || card.Id == null)
                    card.Id = Guid.NewGuid();
                if (card.ExpirationDate.Length == 3)
                    card.ExpirationDate = string.Concat("0", card.ExpirationDate);
                user.CreditCards.Add(card);
                Serilog.Log.Logger.Here().Information($"Credit card saved for user: '{email}'");
                await _userManager.UpdateAsync(user);
                return Ok(true);
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to save credit card, because: {@Exception}", e);
                return Ok(false);
            }
        }
        [HttpPost(), Route("DeleteCard")]
        public async Task<IActionResult> DeleteCreditCard(DeleteCreditCardRequest request)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the DeleteCreditCard method");
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                {
                    Serilog.Log.Logger.Here().Error($"Claim was null while trying to DeleteCreditCard");
                    return NotFound();
                }
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.Normalize().ToUpper());
                if (user == null)
                {
                    Serilog.Log.Logger.Here().Information($"User with claim {email} came back null trying to DeleteCreditCard");
                    return Ok(false);
                }
                if (user.CreditCards == null)
                    return Ok(new DeleteCreditCardResponse() { Succeeded = false, Message = "Unable to remove card" });

                var existing = user.CreditCards.FirstOrDefault(x => x.Id == request.CreditCardId);
                if (existing != null)
                    user.CreditCards.Remove(existing);
                else
                    return Ok(new DeleteCreditCardResponse() { Succeeded = false, Message = "Unable to remove card" });
                await _userManager.UpdateAsync(user);
                Serilog.Log.Logger.Here().Information($"Deleted card for user with claim {email}");
                return Ok(new DeleteCreditCardResponse() { Succeeded = true });
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to remove card for a user, because: {@Exception}", e);
                return Ok(new SaveAddressResponse() { Succeeded = false, Message = "Something went wrong" });
            }
        }
        #endregion
        #region Addresses
        [HttpGet(), Route("Addresses")]
        public async Task<IActionResult> GetAddresses()
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the GetAddresses method");
                GetAddressesResponse response = new GetAddressesResponse() { Addresses = new List<Address>() { } };
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                    return NotFound();
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.ToUpper());

                if (user != null)
                {
                    response.Succeeded = true;
                    if (user.Addresses == null)
                    {
                        Serilog.Log.Logger.Here().Information("Addresses were null for user:{@JessesAppUser}, exiting",user);
                        return Ok(new GetAddressesResponse() { Addresses = new List<Address>(), Succeeded = false, Message = "No Addresses  found" });
                    }
                    else
                    {
                        if (user.Addresses.Count() != 0)
                        {
                            foreach (var address in user.Addresses)
                            {
                                response.Addresses.Add(address);
                            }
                        }
                    }
                    Serilog.Log.Logger.Here().Information("Exiting GetAddresses method");
                    return Ok(response);

                }
                Serilog.Log.Logger.Here().Error("Unable to retrieve addresses for a user, email: {email} did not mention any accounts on server", email);
                return Ok(new GetAddressesResponse() { Addresses = new List<Address>(), Succeeded = false, Message = "Something went wrong" });
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to retrieve addresses for a user, because: {@Excpetion}", e);
                return Ok(new GetAddressesResponse() { Succeeded = false, Message = "Something went wrong" });
            }
        }
        [HttpGet(), Route("GetAccountInfo")]
        public async Task<IActionResult> GetAccountInfo()
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the GetAccountInfo method");
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                {
                    Serilog.Log.Logger.Here().Information($"Claim was null in GetAccountInfo method, returning not found");
                    return NotFound();
                }
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.ToUpper());

                if (user != null)
                {
                    if (user.Info == null)
                    {
                        Serilog.Log.Logger.Here().Information($"user.info was null in GetAccountInfo method, returning not found");
                        return Ok(new GetAccountInfoResponse() { Succeeded = false, Message = "No Info  found" });

                    }
                    else
                    {
                        var info = new CustomerInfoApp()
                        {
                            AddressLine1 = user.Info.Address,
                            City = user.Info.City,
                            EmailAddress = user.Email.ToLower(),
                            FirstName = user.Info.FirstName,
                            LastName = user.Info.LastName,
                            PhoneNumber = user.Info.PhoneNumber,
                            ZipCode = user.Info.ZipCode
                        };
                        return Ok(new GetAccountInfoResponse() { Succeeded = true, Info = info });

                    }

                }
                Serilog.Log.Logger.Here().Error("Unable to GetAccountINfo for a user, email: {email} did not mention any accounts on server", email);
                return Ok(new GetAccountInfoResponse() { Succeeded = false, Message = "Something went wrong" });
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to retrieve addresses for a user, because: {@Exception}", e);
                return Ok(new GetAccountInfoResponse() { Succeeded = false, Message = "Something went wrong" });
            }
        }
        [HttpPost(), Route("DeleteAddress")]
        public async Task<IActionResult> DeleteAddress(DeleteAddressRequest request)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the DeleteAddress method");
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                    return NotFound();
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.ToUpper());

                if (user != null)
                {
                    if (user.Addresses == null)
                        return Ok(new DeleteAddressResponse() { Succeeded = false, Message = "No Addresses found" });
                    else
                    {
                        var existing = user.Addresses.FirstOrDefault(x => x.Id == request.Address.Id);
                        if (existing != null)
                            user.Addresses.Remove(existing);
                        else
                            return Ok(new DeleteAddressResponse() { Succeeded = false, Message = "No Address found" });
                        await _userManager.UpdateAsync(user);
                    }
                    return Ok(new SaveAddressResponse() { Succeeded = true });

                }
                Serilog.Log.Logger.Here().Error("Unable to DeleteAddress for a user, email: {email} did not mention any accounts on server", email);
                return Ok(new SaveAddressResponse() { Succeeded = false, Message = "Something went wrong" });
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to delete address for a user, because: {@Exception}", e);
                return Ok(new SaveAddressResponse() { Succeeded = false, Message = "Something went wrong" });
            }
        }
        [HttpPost(), Route("SaveAddress")]
        public async Task<IActionResult> SaveAddress(SaveAddressRequest request)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the SaveAddress method");
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                    return NotFound();
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.ToUpper());

                if (user != null)
                {
                    if (user.Addresses == null)
                        return Ok(new SaveAddressResponse() { Succeeded = false, Message = "No Addresses  found" });
                    else
                    {
                        var result = await ValidateAddress(request.Address);
                        if (!result.Succeeded)
                            return Ok(result);
                        var existing = user.Addresses.FirstOrDefault(x => x.Id == request.Address.Id);
                        if (existing != null)
                            user.Addresses.Remove(existing);
                        user.Addresses.Add(request.Address);
                        await _userManager.UpdateAsync(user);
                    }
                    return Ok(new SaveAddressResponse() { Succeeded = true });

                }
                Serilog.Log.Logger.Here().Error("Unable to SaveAddress for a user, email: {email} did not mention any accounts on server", email);
                return Ok(new SaveAddressResponse() { Succeeded = false, Message = "Something went wrong" });
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to save addresses for a user, because: {@Exception}", e);
                return Ok(new SaveAddressResponse() { Succeeded = false, Message = "Something went wrong" });
            }
        }
        private async Task<SaveAddressResponse> ValidateAddress(Address address)
        {

            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the ValidateAddress method");
                var settings = await _pizzaRepo.GetSettings();
                if (address.City.Trim().ToUpper() != "HENDERSON")
                {
                    _logger.LogWarning("City out of range");
                    return new SaveAddressResponse() { Succeeded = false, Message = "City out of range" };
                }
                List<string> ZipCodes = new List<string>();
                foreach (var zipcode in settings.ZipCodes)
                {
                    ZipCodes.Add(zipcode.ZipCodeValue.ToString());
                }
                if (!ZipCodes.Contains(address.ZipCode.ToString()))
                {
                    _logger.LogWarning("Zip Code out of range");
                    return new SaveAddressResponse() { Succeeded = false, Message = "Zip Code out of range" };
                }
                Serilog.Log.Logger.Here().Information("Validated address: {@address}", address);
                return new SaveAddressResponse() { Succeeded = true };
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Failed to validate address: {@Address}, because: {@Exception} ", address, e);
                return new SaveAddressResponse() { Succeeded = false, Message = "Validation Failed" };
            }

        }
        #endregion

        #region Transactions
        [HttpGet("approval")]
        [Consumes("application/x-www-form-urlencoded")]
        [AllowAnonymous]
        public async Task<ContentResult> ApprovalHostedPaymentsPage([FromQuery] ConvergeHPPTokenResponse transaction)
        {

            try
            {
                Serilog.Log.Logger.Here().Information("Entered the ApprovalHPP method with response: {@ConvergeHPPTokenResponse} and url: {@string}", transaction,Request.QueryString);
                //Make sure there are no errors in response
                var transactionGuid = GuidConvert.Base64ToGuid(transaction.ssl_last_name).ToString();
                if (!string.IsNullOrEmpty(transaction.errorCode) || !string.IsNullOrEmpty(transaction.errorMessage) || !string.IsNullOrEmpty(transaction.errorName))
                {
                    Serilog.Log.Logger.Here().Error("ApprovalHPP receieved an error from Elavon with response: '{@ConvergeHPPTokenResponse}'", transaction);
                    await _hubContext.Clients.All.SendAsync("HPPFailed", transactionGuid, "Unable to post transaction");
                    return new ContentResult { ContentType = "text/html", Content = "" };
                }
                //This is where we store the GUID for the transaction on mongo, if it is empty something went wwrong
                if (string.IsNullOrEmpty(transaction.ssl_last_name))
                {
                    Serilog.Log.Logger.Here().Error("Customer code was null in ApprovalHPP for transaction: '{@ConvergeHPPTokenResponse}'", transaction);
                    return new ContentResult { ContentType = "text/html", Content = "" };
                }
                //Cache the guid to make sure we have NOT began processing transaction, if code exists already it is being or was processed
                var code = await _cache.GetCacheValue(string.Concat(transactionGuid, "TransactionCode"));
                if (!string.IsNullOrEmpty(code))
                {
                    Serilog.Log.Logger.Here().Information("Code was NOT null or empty in ApprovalHostedPaymentsPage for transaction: {@ConvergeHPPTokenResponse}", transaction);
                    return new ContentResult { ContentType = "text/html", Content = "" };
                }
                await _cache.SetCacheValue(string.Concat(transactionGuid, "TransactionCode"), transactionGuid);
                //Try to find transaction on Mongo
                MongoTransaction mongoTransaction = await _pizzaRepo.GetTransactionByGuid(new Guid(transactionGuid));
            if (mongoTransaction == null)
            {
                //Transaction is either V1.1 or nul;
                MongoTransactionV1_1 mongoTransactionV1_1 = await _pizzaRepo.GetTransactionByGuidV1_1(new Guid(transactionGuid));
                if (mongoTransactionV1_1 == null)
                {
                    await _hubContext.Clients.All.SendAsync("HPPCancel", transactionGuid, "");
                    return new ContentResult { ContentType = "text/html", Content = "" }; ;
                }
                else
                    return await ProcessTransactionV1_1(transaction, mongoTransactionV1_1, transactionGuid); // transaction was V1.1 so process it
            }
            //If V1 transaction was not null process it  
            return await ProcessTransaction(transaction, mongoTransaction,transactionGuid);
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to process transaction: {@ConvergeHPPTokenResponse}, because {e}", Request.Query.ToString(), e);
                return new ContentResult { ContentType = "text/html", Content = "" }; ;
            }
        }
        private async Task<ContentResult> ProcessTransactionV1_1(ConvergeHPPTokenResponse transaction, MongoTransactionV1_1 mongoTransaction, string transactionGuid)
        {
            Serilog.Log.Logger.Here().Information("Entered the ProcessTransactionV1_1 method with transaction: {@MongoTransaction}",mongoTransaction);
            var blankContentResponse = new ContentResult { ContentType = "text/html", Content = "" };
            string response = ""; //Prepare a content response, using an HTTP GET from converge so we must return html content
            string claim = mongoTransaction.Claim;
            if (string.IsNullOrEmpty(claim))
            {
                Serilog.Log.Logger.Here().Error("Claim was null while trying to ProcessTransactionV1_1 method with transaction: {@MongoTransaction}",mongoTransaction);
                await _hubContext.Clients.All.SendAsync("HPPCancel", transactionGuid, "");
                return blankContentResponse;
            }
            Serilog.Log.Logger.Here().Information("Began processing transaction V1.1 '{@ConvergeHPPTokenResponse}' for user: '{claim}'", transaction,claim);

            try
            {
                //Make sure the token was sucessfully generated
                if (transaction.ssl_token_response != "SUCCESS")
                {
                    Serilog.Log.Logger.Here().Error("Token was not successfully generated ProcessTransactionV1_1 method with transaction from Elavon: '{@ConvergeHPPTokenResponse}', and on database: '{@MongoTransaction}'",transaction,mongoTransaction);
                    await _hubContext.Clients.All.SendAsync("HPPFailed", transactionGuid, "Unable to post transaction");
                    return blankContentResponse;
                }
                //check transaction state to make sure we haven't already processed it
                if (mongoTransaction.TransactionState != TransactionState.Validated)
                {
                    Serilog.Log.Logger.Here().Warning("Transaction already began processing: {@ConvergeHPPTokenResponse} for user: {claim}", transaction,claim);
                    return blankContentResponse;
                }
                //Build xml sale request
                var settings = await _pizzaRepo.GetSettings();
                var saleRequest = new ConvergeSaleRequest(transaction, settings, mongoTransaction);
                System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(saleRequest.GetType());
                string convergeUrl;
                if (settings.UseDemoEndpoints)
                {
                    Serilog.Log.Logger.Here().Information("Using demo endpoint to post transaction");
                    convergeUrl = "https://api.demo.convergepay.com/VirtualMerchantDemo/processxml.do";
                }
                else
                {
                    Serilog.Log.Logger.Here().Information("Using production endpoint to post transaction");
                    convergeUrl = "https://api.convergepay.com/VirtualMerchant/processxml.do";
                }
                var xml = saleRequest.ToString();
                Serilog.Log.Logger.Here().Information($"HPP Approval, sending xml request: {xml}");
                if (mongoTransaction.Claim != "Guest")
                {
                    JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == claim.ToUpper());
                    if (user == null)
                    {
                        Serilog.Log.Logger.Here().Error($"Unable to find user to ProcessTransactionV1_1: '{mongoTransaction.Claim}' didn't match any users");
                        await _hubContext.Clients.All.SendAsync("HPPFailed", transactionGuid, "Unable to post transaction");
                        return blankContentResponse;
                    }
                }
                //Send Request to converge, we have the user and transaction 
                response = await convergeUrl.WithHeader("Content-Type", "application/x-www-form-urlencoded").PostStringAsync(xml).ReceiveString();
                Serilog.Log.Logger.Here().Information($"Sent xml request and received: '{response}'");
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
                    if (result.ssl_result_message == "DECLINED")
                    {
                        Serilog.Log.Logger.Here().Error("Xml request to Elavon was DECLINED for transaction: {@ConvergeHPPTokenResponse} and on db {@MongoTransaction}", transaction,mongoTransaction);
                        await _hubContext.Clients.All.SendAsync("HPPDecline", transaction.ssl_last_name, "");
                        mongoTransaction.TransactionStateV1_1 = TransactionStateV1_1.Declined;
                    }
                    else
                    {
                        Serilog.Log.Logger.Here().Error("Xml request to Elavon was not successful for transaction: {@ConvergeHPPTokenResponse} and on db {@MongoTransaction}, Elavon responded with: {@result}", transaction,mongoTransaction,result);
                        await _hubContext.Clients.All.SendAsync("HPPFailed", transaction.ssl_last_name, result.errorMessage);
                        mongoTransaction.TransactionStateV1_1 = TransactionStateV1_1.Failed;
                    }
                    mongoTransaction.Date = DateTime.Now;
                    await _pizzaRepo.UpdateTransaction(mongoTransaction);
                    var groups = await _pizzaRepo.GetAllGroups();
                    var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                    var model = new OrderFailedEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery) { };
                    await SendOrderFailedEmailAsync(model);
                    return blankContentResponse;
                }
                // Payment was approved if we got here, grab what we want to store in Mongo from the converge response
                mongoTransaction.Date = DateTime.UtcNow;
                mongoTransaction.TransactionState = TransactionState.Authorized;
                mongoTransaction.ConvergeTransactionId = result.ssl_txn_id;
                mongoTransaction.CardPreview = result.ssl_card_number;
                mongoTransaction.CardShortDescription = result.ssl_card_short_description;
                mongoTransaction.ExpDate = result.ssl_exp_date.ToString();
                Serilog.Log.Logger.Here().Information("TransactionV1.1 successfully processed: '{@MongoTransaction}'",mongoTransaction);
                // Update the transaction we already created
                await _pizzaRepo.UpdateTransaction(mongoTransaction);
                // Tell Client that they were approved
                HPPApprovalMessage message;
                bool isGuest = false;
                if (mongoTransaction.Claim == "Guest")
                {
                    isGuest = true;
                    message = new HPPApprovalMessage()
                    {
                        IsGuest = isGuest,
                        Card = null,
                        IsCardSaved = false,
                        TransactionGuid = mongoTransaction.TransactionGuid
                    };
                    // Get data and send email
                    var groups = await _pizzaRepo.GetAllGroups();
                    var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                    var model = new OrderCompleteEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery) { };
                    var customerModel = new CustomerEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery);
                    await SendOrderCompleteEmailsAsync(model, customerModel, mongoTransaction.Email, mongoTransaction.Name);
                    Serilog.Log.Logger.Here().Information("Authorized transaction{@MongoTransaction}, and sent confirmation email to guest :{mongoTransaction.Email}",mongoTransaction,mongoTransaction.Email);
                }
                else
                {
                    JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == claim.ToUpper());
                    if (user == null)
                    {
                        Serilog.Log.Logger.Here().Error($"User with claim {claim.ToUpper()} came back null trying to ProcessTransactionV1.1");
                        message = new HPPApprovalMessage()
                        {
                            IsGuest = isGuest,
                            Card = null,
                            IsCardSaved = false,
                            TransactionGuid = mongoTransaction.TransactionGuid
                        };
                        // Get data and send email
                        var userGroups = await _pizzaRepo.GetAllGroups();
                        var userMainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                        var userModel = new OrderCompleteEmailModel(mongoTransaction, userGroups, userMainMenuItems, mongoTransaction.IsDelivery) { };
                        var userCustomerModel = new CustomerEmailModel(mongoTransaction, userGroups, userMainMenuItems, mongoTransaction.IsDelivery);
                        await SendOrderCompleteEmailsAsync(userModel, userCustomerModel, mongoTransaction.Email, mongoTransaction.Name);
                        Serilog.Log.Logger.Here().Error("User was null but ProcessedTransactionV1.1: {@MongoTransaction}, and sent confirmation email to guest :{mongoTransaction.Email}",mongoTransaction,mongoTransaction.Email);
                        return blankContentResponse;
                    }

                    var isCardSaved = user.CreditCards?.Where(x => x.Token == result.ssl_token).Any();
                    if (isCardSaved == null)
                        isCardSaved = false;
                    message = new HPPApprovalMessage()
                    {
                        Card = new CreditCard()
                        {
                            Token = result.ssl_token,
                            CardNumber = result.ssl_card_number,
                            ExpirationDate = result.ssl_exp_date.ToString(),
                            ShortDescription = result.ssl_card_short_description,
                            Id = Guid.NewGuid()
                        },
                        IsGuest = false,
                        TransactionGuid = mongoTransaction.TransactionGuid,
                        IsCardSaved = (bool)isCardSaved
                    };
                    if (user.TransactionIds == null)
                        user.TransactionIds = new List<Guid>();
                    user.TransactionIds.Add(mongoTransaction.TransactionGuid);
                    await _userManager.UpdateAsync(user);
                    // Get data and send email
                    var groups = await _pizzaRepo.GetAllGroups();
                    var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                    var model = new OrderCompleteEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery) { };
                    var customerModel = new CustomerEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery);
                    await SendOrderCompleteEmailsAsync(model, customerModel, user.Email, mongoTransaction.Name);
                    Serilog.Log.Logger.Here().Information("Authorized transaction{@MongoTransaction}, and sent confirmation email to user: '{user}'",mongoTransaction,user);
                }
                // Tell app user that that the transaction was posted successfully

                await _hubContext.Clients.All.SendAsync("HPPApprove", transactionGuid, message);

                // Tell KDS that a new transaction was posted
                await _hubContext.Clients.All.SendAsync("ReceiveMessage", "Authorized", "");
                Serilog.Log.Logger.Here().Information($"ProcessTransactionV1.1 exited with no errors");
                return blankContentResponse;
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to process transaction: {@ConvergeHPPTokenResponse}, because {e}, transaction on database: {@MongoTransaction}", transaction,e,mongoTransaction);
                await _hubContext.Clients.All.SendAsync("HPPFailed", transactionGuid, "");
                var groups = await _pizzaRepo.GetAllGroups();
                var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                var model = new OrderFailedEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery) { };
                await SendOrderFailedEmailAsync(model);
                return new ContentResult
                {
                    ContentType = "text/html",
                    Content = ""
                };
            }
        }
        private async Task<ContentResult> ProcessTransaction(ConvergeHPPTokenResponse transaction, MongoTransaction mongoTransaction, string transactionGuid)
        {
            Serilog.Log.Logger.Here().Information("Entered the ProcessTransaction method with transaction: {@MongoTransaction}",mongoTransaction);
            var blankContentResponse = new ContentResult { ContentType = "text/html", Content = "" };
            string response = ""; //Prepare a content response, using an HTTP GET from converge so we must return html content
            string claim = mongoTransaction.Claim; //This is either 'Guest' or username for user
            if (string.IsNullOrEmpty(claim))
            {
                Serilog.Log.Logger.Here().Error("Claim was null while trying to ProcessTransaction method with transaction: {@MongoTransaction}",mongoTransaction);
                await _hubContext.Clients.All.SendAsync("HPPCancel", transactionGuid, "");
                return blankContentResponse;
            }
            Serilog.Log.Logger.Here().Information($"Began ProcessingTransaction '{transaction}' for user: '{claim}'");

            try
            {
                //Make sure the token was sucessfully generated
                if (transaction.ssl_token_response != "SUCCESS")
                {
                    Serilog.Log.Logger.Here().Error("Token was not successfully generated ProcessTransaction method with transaction from Elavon: '{@ConvergeHPPTokenResponse}', and on database: '{@MongoTransaction}'", transaction, mongoTransaction);
                    mongoTransaction.TransactionState = TransactionState.Failed;
                    await _pizzaRepo.UpdateTransaction(mongoTransaction);
                    await _hubContext.Clients.All.SendAsync("HPPFailed", transactionGuid, "Unable to post transaction");
                    return blankContentResponse;
                }
                //check transaction state to make sure we haven't already processed it
                if (mongoTransaction.TransactionState != TransactionState.Validated)
                {
                    Serilog.Log.Logger.Here().Warning("Transaction already began processing: {@ConvergeHPPTokenResponse} for user: {claim}", transaction, claim);
                    return blankContentResponse;
                }
                //Build xml sale request
                var settings = await _pizzaRepo.GetSettings();
                var saleRequest = new ConvergeSaleRequest(transaction, settings, mongoTransaction);
                System.Xml.Serialization.XmlSerializer x = new System.Xml.Serialization.XmlSerializer(saleRequest.GetType());
                string convergeUrl;
                convergeUrl = GetEndpoints(settings);
                var xml = saleRequest.ToString();
                Serilog.Log.Logger.Here().Information($"HPP Approval, sending xml request: {xml}");
                if (mongoTransaction.Claim != "Guest") //if transaction is not for a guest find the user
                {
                    JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == claim.ToUpper());
                    if (user == null)
                    {
                        Serilog.Log.Logger.Here().Error($"Unable to find user to ProcessTransaction: '{mongoTransaction.Claim}' didn't match any users");
                        await _hubContext.Clients.All.SendAsync("HPPFailed", transactionGuid, "Unable to post transaction");
                        mongoTransaction.TransactionState = TransactionState.Failed;
                        await _pizzaRepo.UpdateTransaction(mongoTransaction);
                        return blankContentResponse;
                    }
                }
                //Send Request to converge, we have the user and transaction 
                response = await convergeUrl.WithHeader("Content-Type", "application/x-www-form-urlencoded").PostStringAsync(xml).ReceiveString();
                Serilog.Log.Logger.Here().Information($"Sent xml request to Converge and received: '{response}'");
                var serializer = new XmlSerializer(typeof(txn));
                txn result;
                //Try to deserialize, if the payment was declined it will go to catch because xml bodies are different
                using (TextReader reader = new StringReader(response))
                {
                    result = (txn)serializer.Deserialize(reader);
                }
                // check if payment was approved
                if (result.ssl_result_message != "APPROVAL" || !string.IsNullOrEmpty(result.errorMessage))
                {
                    if (string.IsNullOrEmpty(result.ssl_result_message))
                    {
                        Serilog.Log.Logger.Here().Error("Xml request to Elavon was not successful for transaction: {@ConvergeHPPTokenResponse} and on db {@MongoTransaction}, Elavon responded with: {result}", transaction, mongoTransaction, result);
                        await _hubContext.Clients.All.SendAsync("HPPCancel", transactionGuid, "Unable to process transaction at this time");
                        mongoTransaction.TransactionState = TransactionState.Cancelled;
                        mongoTransaction.Date = DateTime.Now;
                        await _pizzaRepo.UpdateTransaction(mongoTransaction);
                        var errorGroups = await _pizzaRepo.GetAllGroups();
                        var errorMainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                        await SendOrderFailedEmailAsync(transaction, mongoTransaction, result);
                        return blankContentResponse;
                    }
                    if (result.ssl_result_message == "DECLINED")
                    {
                        Serilog.Log.Logger.Here().Error("Xml request to Elavon was DECLINED for transaction: {@ConvergeHPPTokenResponse} and on db {@MongoTransaction}", transaction, mongoTransaction);
                        await _hubContext.Clients.All.SendAsync("HPPDecline", transactionGuid, "");
                        mongoTransaction.TransactionState = TransactionState.Declined;
                    }
                    else
                    {
                        Serilog.Log.Logger.Here().Error("Xml request to Elavon was not successful for transaction: {@ConvergeHPPTokenResponse} and on db {@MongoTransaction}, Elavon responded with: {result}", transaction, mongoTransaction, result);
                        await _hubContext.Clients.All.SendAsync("HPPCancel", transactionGuid, "Unable to process transaction at this time");
                        mongoTransaction.TransactionState = TransactionState.Cancelled;
                    }
                    mongoTransaction.Date = DateTime.Now;
                    await _pizzaRepo.UpdateTransaction(mongoTransaction);
                    var groups = await _pizzaRepo.GetAllGroups();
                    var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                    var model = new OrderFailedEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery) { };
                    await SendOrderFailedEmailAsync(transaction, mongoTransaction, result);
                    return blankContentResponse;
                }
                // Payment was approved if we got here, grab what we want to store in Mongo from the converge response
                mongoTransaction.Date = DateTime.UtcNow;
                mongoTransaction.TransactionState = TransactionState.Authorized;
                mongoTransaction.ConvergeTransactionId = result.ssl_txn_id;
                mongoTransaction.CardPreview = result.ssl_card_number;
                mongoTransaction.CardShortDescription = result.ssl_card_short_description;
                mongoTransaction.ExpDate = result.ssl_exp_date.ToString();

                // Update the transaction we already created
                await _pizzaRepo.UpdateTransaction(mongoTransaction);
                // Tell Client that they were approved
                HPPApprovalMessage message;
                bool isGuest = false;
                if (mongoTransaction.Claim == "Guest")
                {
                    isGuest = true;
                    message = new HPPApprovalMessage()
                    {
                        IsGuest = isGuest,
                        Card = null,
                        IsCardSaved = false,
                        TransactionGuid = mongoTransaction.TransactionGuid
                    };
                    // Get data and send email
                    var groups = await _pizzaRepo.GetAllGroups();
                    var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                    var model = new OrderCompleteEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery) { };
                    var customerModel = new CustomerEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery);
                    await SendOrderCompleteEmailsAsync(model, customerModel, mongoTransaction.Email, mongoTransaction.Name);
                    Serilog.Log.Logger.Here().Information("Authorized transaction{@MongoTransaction}, and sent confirmation email to guest :{mongoTransaction.Email}", mongoTransaction, mongoTransaction.Email);
                }
                else
                {
                    JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == claim.ToUpper());
                    var isCardSaved = user.CreditCards?.Where(x => x.Token == result.ssl_token).Any();
                    if (isCardSaved == null)
                        isCardSaved = false;
                    message = new HPPApprovalMessage()
                    {
                        Card = new CreditCard()
                        {
                            Token = result.ssl_token,
                            CardNumber = result.ssl_card_number,
                            ExpirationDate = result.ssl_exp_date.ToString(),
                            ShortDescription = result.ssl_card_short_description,
                            Id = Guid.NewGuid()
                        },
                        IsGuest = false,
                        TransactionGuid = mongoTransaction.TransactionGuid,
                        IsCardSaved = (bool)isCardSaved
                    };
                    if (user.TransactionIds == null)
                        user.TransactionIds = new List<Guid>();
                    user.TransactionIds.Add(mongoTransaction.TransactionGuid);
                    await _userManager.UpdateAsync(user);
                    // Get data and send email
                    var groups = await _pizzaRepo.GetAllGroups();
                    var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                    var model = new OrderCompleteEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery) { };
                    var customerModel = new CustomerEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery);
                    await SendOrderCompleteEmailsAsync(model, customerModel, user.Email, mongoTransaction.Name);
                    Serilog.Log.Logger.Here().Information("Authorized transaction{@MongoTransaction}, and sent confirmation email to user: '{@JessesPizzaAppUser}'", mongoTransaction, user);
                }
                // Tell app user that that the transaction was posted successfully

                await _hubContext.Clients.All.SendAsync("HPPApprove", transactionGuid, message);

                // Tell KDS that a new transaction was posted
                await _hubContext.Clients.All.SendAsync("ReceiveMessage", "Authorized", "");
                Serilog.Log.Logger.Here().Information($"ProcessTransaction exited with no errors");
                return blankContentResponse;
            }
            catch (Exception e)
            {
                // if we got here something actually went wrong
                Serilog.Log.Logger.Here().Error("Unable to process transaction: {@ConvergeHPPTokenResponse}, because {@Exception}, transaction on database: {@MongoTransaction}", transaction,e,mongoTransaction);
                await _hubContext.Clients.All.SendAsync("HPPCancel", transactionGuid, "Something went wrong");
                var groups = await _pizzaRepo.GetAllGroups();
                var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
                var model = new OrderFailedEmailModel(mongoTransaction, groups, mainMenuItems, mongoTransaction.IsDelivery) { };
                await SendOrderFailedEmailAsync(model);
                return blankContentResponse;
            }
        }

        private static string GetEndpoints(JessesPizzaSettings settings)
        {
            string convergeUrl;
            if (settings.UseDemoEndpoints)
            {
                Serilog.Log.Logger.Here().Information("Using demo endpoint to post transaction");
                convergeUrl = "https://api.demo.convergepay.com/VirtualMerchantDemo/processxml.do";
            }
            else
            {
                Serilog.Log.Logger.Here().Information("Using production endpoint to post transaction");
                convergeUrl = "https://api.convergepay.com/VirtualMerchant/processxml.do";
            }

            return convergeUrl;
        }

        //When app user presses cancel on HPP Converge redirects to our API and we have to tell the app user and we delete transaction
        [HttpGet("CancelPage")]
        [Consumes("application/x-www-form-urlencoded")]
        [AllowAnonymous]
        public async Task<ContentResult> CancelHostedPaymentsPage([FromQuery] ConvergeCancelHPP transaction)
        {
            try
            {
                Serilog.Log.Logger.Here().Information("Entered the CancelHostedPaymentsPage method with transaction: {@ConvergeCancelHPP}", transaction);
                var transactionGuid = GuidConvert.Base64ToGuid(transaction.ssl_last_name).ToString();

                await _hubContext.Clients.All.SendAsync("HPPCancel", transactionGuid, "");
                var mongoTransaction = await _pizzaRepo.GetTransactionByGuid(new Guid(transactionGuid));
                if (mongoTransaction != null)
                {
                    Serilog.Log.Logger.Here().Information("HPP canceled, deleting transaction: {@ConvergeCancelHPP}", transaction);
                    await _pizzaRepo.DeleteTransaction(mongoTransaction.TransactionGuid);
                }
                else
                {
                    var mongoTransactionV1_1 = await _pizzaRepo.GetTransactionByGuidV1_1(new Guid(transactionGuid));
                    if (mongoTransactionV1_1 != null)
                    {
                        Serilog.Log.Logger.Here().Information("HPP canceled, deleting transactionV1.1: {@ConvergeCancelHPP}", transaction);
                        await _pizzaRepo.DeleteTransactionV1_1(mongoTransactionV1_1.TransactionGuid);
                    }
                }
                return new ContentResult
                {
                    ContentType = "text/html",
                    Content = ""
                };
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to cancel transaction: {@ConvergeCancelHPP}, because {@Exception}", transaction,e);
                return new ContentResult
                {
                    ContentType = "text/html",
                    Content = ""
                };
            }

        }
        [MapToApiVersion("1.1")]
        [HttpPost(), Route("GetHPPToken")]
        public async Task<IActionResult> GetHPPToken([FromBody]LocalTransactionV1_1 localTransaction)
        {
            try
            {
                Serilog.Log.Logger.Here().Information("Entered the GetHPPTokenV1.1 method with LocalTransaction: {@LocalTransactionV1_1}",localTransaction);
                //get account info 
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                {
                    Serilog.Log.Logger.Here().Error($"Claim was null while trying to GetHPPTokenV1.1");
                    return NotFound();
                }
                string firstName;
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.ToUpper());
                if (user == null && email != "Guest")
                {
                    Serilog.Log.Logger.Here().Error($"User with claim {email} came back null trying to GetHPPTokenV1.1");
                    return NotFound();
                }
                // get settings for converge account info
                var settings = await _pizzaRepo.GetSettings();
                string convergeUrl;

                if (settings.UseDemoEndpoints)
                {
                    Serilog.Log.Logger.Here().Information("Using demo endpoint for HPP");
                    convergeUrl = "https://api.demo.convergepay.com/hosted-payments/transaction_token";
                }
                else
                {
                    Serilog.Log.Logger.Here().Information("Using production endpoint for HPP");
                    convergeUrl = "https://api.convergepay.com/hosted-payments/transaction_token";
                }
                // generate a customerCode so we can keep track of the session
                var customerCode = Guid.NewGuid();
                // build request
                var convergeTokenRequest = new ConvergeHPPTokenRequest() {ssl_first_name = email.Substring(0, Math.Min(email.Length, 20)), ssl_last_name = GuidConvert.GuidToBase64(customerCode), ssl_merchant_id = settings.MerchantId, ssl_user_id = settings.UserId, ssl_amount = localTransaction.Totals.Total.ToString("0.00"), ssl_pin = settings.Pin, ssl_transaction_type = "ccgettoken" };
                //if (localTransaction.Info.FirstName.Length > 20)
                //    convergeTokenRequest.ssl_first_name = localTransaction.Info.FirstName.Substring(0, 20);
                //else
                //    convergeTokenRequest.ssl_first_name = localTransaction.Info.FirstName;
                Serilog.Log.Logger.Here().Information("Sending HPP token request V1.1 to Converge: {@ConvergeHPPTokenRequest}", convergeTokenRequest);

                // Try to get token for HPP page
                var response = await convergeUrl.SendUrlEncodedAsync(HttpMethod.Post, convergeTokenRequest).ReceiveString();
                Serilog.Log.Logger.Here().Information("Converge responded to HppTokenRequestV1.1 with: {@ConvergeHPPTokenRequest}", response);

                if (!string.IsNullOrEmpty(response))
                {
                    // we got the token so build a new transaction save to db and return HPP Url to customer
                    var payment = new MongoTransactionV1_1(localTransaction);
                    if (user != null)
                    {
                        payment.Email = user.Email;
                        payment.PhoneNumber = user.PhoneNumber;
                        payment.Name = String.Concat(user.Info.FirstName, " ", user.Info.LastName);
                        if (localTransaction.IsDelivery)
                        {
                            payment.Address1 = localTransaction.Info.AddressLine1;
                            payment.City = localTransaction.Info.City;
                            payment.ZipCode = localTransaction.Info.ZipCode;
                            payment.IsDelivery = true;
                            payment.NoContactDelivery = false;
                        }
                        else if (localTransaction.NoContactDelivery)
                        {
                            payment.Address1 = localTransaction.Info.AddressLine1;
                            payment.City = localTransaction.Info.City;
                            payment.ZipCode = localTransaction.Info.ZipCode;
                            payment.IsDelivery = false;
                            payment.NoContactDelivery = true;
                        }
                        else
                        {
                            payment.Address1 = user.Info.Address;
                            payment.City = user.Info.City;
                            payment.ZipCode = user.Info.ZipCode;
                            payment.IsDelivery = false;
                            payment.NoContactDelivery = false;
                        }
                    }
                    else
                    {
                        payment.Email = localTransaction.Info.EmailAddress;
                        payment.PhoneNumber = localTransaction.Info.PhoneNumber;
                        payment.Name = String.Concat(localTransaction.Info.FirstName, " ", localTransaction.Info.LastName);
                    }
                    payment.TransactionGuid = customerCode;
                    payment.HPPToken = response;
                    payment.Claim = email;
                    payment.Date = DateTime.Now;
                    await _pizzaRepo.SaveNewTransactionV1_1(payment);
                    var encodedToken = System.Web.HttpUtility.UrlEncode(response);
                    string returnUrl;

                    if (settings.UseDemoEndpoints)
                    {
                        returnUrl = "https://api.demo.convergepay.com/hosted-payments/?ssl_txn_auth_token=";
                    }
                    else
                    {
                        returnUrl = "https://api.convergepay.com/hosted-payments/?ssl_txn_auth_token=";
                    }
                    payment.HPPToken = string.Concat(returnUrl, encodedToken);
                    Serilog.Log.Logger.Here().Information($"Successfully retrieved HPPTokenV1.1");
                    return StatusCode(200, payment);
                }
                return StatusCode(500);
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("HPP token request failed: {@LocalTransactionV1_1}, because: {@Exception}", localTransaction, e);
                return StatusCode(500, false);
            }

        }
        [MapToApiVersion("1.0")]
        [HttpPost(), Route("GetHPPToken")]
        public async Task<IActionResult> GetHPPToken([FromBody]LocalTransaction localTransaction)
        {
            try
            {
                Serilog.Log.Logger.Here().Information("Entered the GetHPPToken method with LocalTransaction: {@LocalTransaction}", localTransaction);
                //get account info 
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                {
                    Serilog.Log.Logger.Here().Error($"Claim was null while trying to GetHPPTokenV1.1");
                    return NotFound();
                }
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.ToUpper());
                if (user == null && email != "Guest")
                {
                    Serilog.Log.Logger.Here().Error($"User with claim {email} came back null trying to GetHPPTokenV1.1");
                    return NotFound();
                }
                // get settings for converge account info
                var settings = await _pizzaRepo.GetSettings();
                string convergeUrl;

                if (settings.UseDemoEndpoints)
                {
                    Serilog.Log.Logger.Here().Information("Using demo endpoint for HPP");
                    convergeUrl = "https://api.demo.convergepay.com/hosted-payments/transaction_token";
                }
                else
                {
                    Serilog.Log.Logger.Here().Information("Using production endpoint for HPP");
                    convergeUrl = "https://api.convergepay.com/hosted-payments/transaction_token";
                }
                // generate a customerCode so we can keep track of the session
                var customerCode = Guid.NewGuid();
                // build request
                var convergeTokenRequest = new ConvergeHPPTokenRequest() { ssl_first_name = email.Substring(0, Math.Min(email.Length, 20)), ssl_last_name = GuidConvert.GuidToBase64(customerCode), ssl_merchant_id = settings.MerchantId, ssl_user_id = settings.UserId, ssl_amount = localTransaction.Totals.Total.ToString("0.00"), ssl_pin = settings.Pin, ssl_transaction_type = "ccgettoken" };

                Serilog.Log.Logger.Here().Information("Sending HPP token request to Converge: {@ConvergeHPPTokenRequest}", convergeTokenRequest);

                // Try to get token for HPP page
                var response = await convergeUrl.SendUrlEncodedAsync(HttpMethod.Post, convergeTokenRequest).ReceiveString();
                Serilog.Log.Logger.Here().Information("Converge responded to HppTokenRequest with: {@ConvergeHPPTokenRequest}", response);
                if (!string.IsNullOrEmpty(response))
                {
                    // we got the token so build a new transaction save to db and return HPP Url to customer
                    var payment = new MongoTransaction(localTransaction);
                    if (user != null)
                    {
                        payment.Email = user.Email;
                        payment.PhoneNumber = user.PhoneNumber;
                        payment.Name = String.Concat(user.Info.FirstName, " ", user.Info.LastName);
                        if (localTransaction.IsDelivery)
                        {
                            payment.Address1 = localTransaction.Info.AddressLine1;
                            payment.City = localTransaction.Info.City;
                            payment.ZipCode = localTransaction.Info.ZipCode;
                        }
                        else
                        {
                            payment.Address1 = user.Info.Address;
                            payment.City = user.Info.City;
                            payment.ZipCode = user.Info.ZipCode;
                        }
                    }
                    else
                    {
                        payment.Email = localTransaction.Info.EmailAddress;
                        payment.PhoneNumber = localTransaction.Info.PhoneNumber;
                        payment.Name = String.Concat(localTransaction.Info.FirstName, " ", localTransaction.Info.LastName);
                    }
                    payment.TransactionGuid = customerCode;
                    payment.Claim = email;
                    payment.Date = DateTime.Now;
                    await _pizzaRepo.SaveNewTransaction(payment);
                    var encodedToken = System.Web.HttpUtility.UrlEncode(response);
                    string returnUrl;

                    if (settings.UseDemoEndpoints)
                    {
                        returnUrl = "https://api.demo.convergepay.com/hosted-payments/?ssl_txn_auth_token=";
                    }
                    else
                    {
                        returnUrl = "https://api.convergepay.com/hosted-payments/?ssl_txn_auth_token=";
                    }
                    payment.HPPToken = string.Concat(returnUrl, encodedToken);
                    Serilog.Log.Logger.Here().Information($"Successfully retrieved HPPToken");
                    return StatusCode(200, payment);
                }
                else return StatusCode(500);
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("HPP token request failed: {@LocalTransaction}, because: {@Exception}", localTransaction, e);
                return StatusCode(500, false);
            }

        }
        [MapToApiVersion("1.0")]
        [HttpPost(), Route("UpdateTransactionState")]
        public async Task<IActionResult> UpdateTransactionState([FromBody] UpdateTransactionStateRequest request)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the UpdateTransactionState method");
                var payment = await _pizzaRepo.GetTransactionByGuid(request.TransactionGuid);
                if (payment == null)
                {
                    Serilog.Log.Logger.Here().Error("Failed to update transaction state, no transaction found with provided GUID");
                    return Ok(false);

                }
                payment.TransactionState = request.State;
                var updatePayment = await _pizzaRepo.UpdateTransactionState(payment);
                if (updatePayment.TransactionState == request.State)
                {
                    Serilog.Log.Logger.Here().Information($"Updated transactionV1_1: {updatePayment.TransactionGuid} to state: {updatePayment.TransactionState}");
                    return Ok(true);
                }
                Serilog.Log.Logger.Here().Error("Failed to update transaction state: {@MongoTransaction}", updatePayment);
                return Ok(false);
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to update transaction state: {@UpdateTransactionStateRequest}, because {@Exception}", request, e);
                return Ok(false);
            }

        }
        [MapToApiVersion("1.1")]
        [HttpPost(), Route("UpdateTransactionState")]
        public async Task<IActionResult> UpdateTransactionStateV1_1([FromBody] UpdateTransactionStateRequest request)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the UpdateTransactionStateV1.1 method");
                var payment = await _pizzaRepo.GetTransactionByGuidV1_1(request.TransactionGuid);
                if (payment == null)
                {
                    Serilog.Log.Logger.Here().Error("Failed to update transaction state, no transaction found with provided GUID");
                    return Ok(false);

                }
                payment.TransactionState = request.State;
                var updatePayment = await _pizzaRepo.UpdateTransactionStateV1_1(payment);
                if (updatePayment.TransactionState == request.State)
                {
                    Serilog.Log.Logger.Here().Information($"Updated transactionV1_1: {updatePayment.TransactionGuid} to state: {updatePayment.TransactionStateV1_1}");
                    return Ok(true);
                }
                Serilog.Log.Logger.Here().Error("Failed to update transaction stateV1_1: {@AuthorizedPayment}", updatePayment);
                return Ok(false);
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to update transaction stateV1_1: {@UpdateTransactionStateRequest}, because {ExceptionMessage}", request, e);
                return Ok(false);
            }

        }
        [HttpPost("UpdateTransaction")]
        public async Task<MongoTransaction> UpdateTransaction([FromBody] MongoTransaction transaction)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the UpdateTransaction method");
                var payment = await _pizzaRepo.UpdateTransaction(transaction);
                Serilog.Log.Logger.Here().Information("Updated transaction: {transaction}",transaction);
                return payment;
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to update transaction: {transaction}, because {e}",transaction,e);
                return null;
            }

        }
        [AllowAnonymous]
        [HttpGet(), Route("Privacy")]
        public IActionResult GetPrivacyPolicy()
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the GetPrivacyPolicy method");
                var path = string.Concat(Directory.GetCurrentDirectory(), "/PrivacyPolicy/Privacy.txt");
                var privacyPolicy = System.IO.File.ReadAllLines(path);
                if (privacyPolicy != null)
                {
                    var blah = string.Join("\n", privacyPolicy);
                    return StatusCode(200, blah);
                }
                Serilog.Log.Logger.Here().Error("Unable to find privacy policy");
                return NotFound();
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to retrieve privacy policy, because {ExceptionMessage}", e);
                return StatusCode(500);
            }
        }

        [HttpGet(), Route("OrderInfo")]
        public async Task<IActionResult> GetOrderInfo()
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the GetOrderInfo method");
                var settings = await _pizzaRepo.GetSettings();
                if (settings != null)
                {
                    return StatusCode(200, settings);
                }
                Serilog.Log.Logger.Here().Error("Unable to retrieve settings");
                return NotFound();
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to retrieve orderInfo, because {ExceptionMessage}", e);
                return StatusCode(500);
            }
        }
        [MapToApiVersion("1.0")]
        [HttpGet(), Route("Transactions/{state}")]
        public async Task<IActionResult> GetTransactions(TransactionState state)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the GetTransactions method");
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
                    DateTime startDateTime = new DateTime(today.Year, today.Month, today.Day, 0, 0, 0, 0, DateTimeKind.Local); //Today at 00:00:00
                   
                    DateTime endDateTime = new DateTime(today.Year, today.Month, today.Day, 23, 59, 59, 59, DateTimeKind.Local); //Today at 23:59:59
                    // find todays transactions
                    //var todaysTransactions = transactions.Where(x => (x.Date - TimeSpan.FromHours(8)).Day == today.Day && (x.Date - TimeSpan.FromHours(8)).Year == today.Year && (x.Date - TimeSpan.FromHours(8)).Month == today.Month);
                    var todaysTransactions = transactions.Where(x => TimeZoneInfo.ConvertTimeFromUtc( x.Date,pdt) > startDateTime && TimeZoneInfo.ConvertTimeFromUtc(x.Date, pdt) < endDateTime);
                    //List <MongoTransaction> TodaysTransactions = new List<MongoTransaction>();
                    //foreach (var tt in transactions)
                    //{
                    //    var day = (tt.Date - TimeSpan.FromHours(8)).Day;
                    //    var month = (tt.Date - TimeSpan.FromHours(8)).Month;
                    //    var year = (tt.Date - TimeSpan.FromHours(8)).Year;
                    //    if (day == today.Day && month == today.Month && year == today.Year)
                    //        TodaysTransactions.Add(tt);
                    //}

                    Serilog.Log.Logger.Here().Information($"Returning {todaysTransactions.Count()} todays transactions for state: {state}");
                    return Ok(todaysTransactions);
                }
                return NotFound();
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error($"Unable to retrieve transactions by state: {state}, because {e}");
                return StatusCode(500);
            }
        }
        [MapToApiVersion("1.1")]
        [HttpGet(), Route("Transactions/{state}")]
        public async Task<IActionResult> GetTransactionsV1_1(TransactionState state)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the GetTransactionsV1_1 method");
                var transactions = await _pizzaRepo.GetTransactionsByStateV1_1(state);
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
                    var todaysTransactions = transactions.Where(x => (x.Date - TimeSpan.FromHours(8)).Day == today.Day && (x.Date - TimeSpan.FromHours(8)).Year == today.Year && (x.Date - TimeSpan.FromHours(8)).Month == today.Month);
                    List<MongoTransactionV1_1> TodaysTransactions = new List<MongoTransactionV1_1>();
                    foreach (var tt in transactions)
                    {
                        var day = (tt.Date - TimeSpan.FromHours(8)).Day;
                        var month = (tt.Date - TimeSpan.FromHours(8)).Month;
                        var year = (tt.Date - TimeSpan.FromHours(8)).Year;
                        if (day == today.Day && month == today.Month && year == today.Year)
                            TodaysTransactions.Add(tt);
                    }

                    Serilog.Log.Logger.Here().Information($"Returning {TodaysTransactions.Count()} todays transactionsV1.1 for state: {state}");
                    return Ok(todaysTransactions);
                }
                return NotFound();
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error($"Unable to retrieve transactions by state: {state}, because {e}");
                return StatusCode(500);
            }
        }
        [HttpGet(), Route("RefreshTransactions")]
        public async Task<IActionResult> GetTransactionsForKDS()
        {
            try
            {
                
                List<MongoTransaction> todaysTransactions = new List<MongoTransaction>();
                List<MongoTransactionV1_1> todaysTransactionsV1_1 = new List<MongoTransactionV1_1>();
                var transactions = await _pizzaRepo.GetAllTransactions();
                var transactionsV1_1 = await _pizzaRepo.GetAllTransactionsV1_1();
                // server is deployed in our time zone, mongo stores dates in utc ALWAYS, so we must go to local time; 
                TimeZoneInfo pdt;
                //Get Time zone info on windows, if not use linux convention
                if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                    pdt = TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time");
                else
                    pdt = TimeZoneInfo.FindSystemTimeZoneById("America/Los_Angeles");
                // NOw use timezone info to determine todays date/time

                var today = DateTime.UtcNow + pdt.GetUtcOffset(DateTime.Now);
                DateTime startDateTime = new DateTime(today.Year, today.Month, today.Day, 0, 0, 0, 0, DateTimeKind.Local); //Today at 00:00:00

                DateTime endDateTime = new DateTime(today.Year, today.Month, today.Day, 23, 59, 59, 59, DateTimeKind.Local); //Today at 23:59:59

                if (transactions != null)
                {
                     todaysTransactions = transactions.Where(x => TimeZoneInfo.ConvertTimeFromUtc(x.Date, pdt) > startDateTime && TimeZoneInfo.ConvertTimeFromUtc(x.Date, pdt) < endDateTime && x.TransactionState != TransactionState.Declined && x.TransactionState != TransactionState.Failed && x.TransactionState != TransactionState.Validated && x.TransactionState != TransactionState.Cancelled).ToList();
                }
                if (transactionsV1_1 != null)
                {
                    todaysTransactionsV1_1 = transactionsV1_1.Where(x => TimeZoneInfo.ConvertTimeFromUtc(x.Date, pdt) > startDateTime && TimeZoneInfo.ConvertTimeFromUtc(x.Date, pdt) < endDateTime && x.TransactionState != TransactionState.Declined && x.TransactionState != TransactionState.Failed && x.TransactionState != TransactionState.Validated && x.TransactionState != TransactionState.Cancelled).ToList();
                }
                return Ok(new KDSGetTransactionsResponse() { Transactions = todaysTransactions, TransactionsV1_1 = todaysTransactionsV1_1 });
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to retrieve transactions for KDS, because {@Exception}",e);
                return StatusCode(500);
            }
        }

        [HttpGet(), Route("Transactions")]
        public async Task<IActionResult> GetAllTransactions()
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the GetAllTransactions method");
                var transactions = await _pizzaRepo.GetAllTransactions();
                if (transactions != null)
                {
                    Serilog.Log.Logger.Here().Information("Returning ALL transactions");
                    return Ok(transactions);
                }
                return NotFound();
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error($"Unable to retrieve ALL transactions, because {e}");
                return StatusCode(500);
            }
        }
        [MapToApiVersion("1.0")]
        [HttpGet(), Route("TransactionGuid")]
        public async Task<IActionResult> GetTransactionByGuid(Guid transactionGuid)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the GetTransactionByGuid method");
                var transaction = await _pizzaRepo.GetTransactionByGuid(transactionGuid);
                if (transaction != null)
                {
                    Serilog.Log.Logger.Here().Information("Returning transaction with {@Guid}", transactionGuid);
                    return Ok(transaction);
                }
                Serilog.Log.Logger.Here().Warning($"No transaction found with guid: {transactionGuid}");
                return NotFound();
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Failed to retrieve transaction with {@Guid}, because {ExceptionMessage}", transactionGuid, e);
                return StatusCode(500);
            }
        }
        [MapToApiVersion("1.1")]
        [HttpGet(), Route("TransactionGuid")]
        public async Task<IActionResult> GetTransactionByGuidV1_1(Guid transactionGuid)
        {
            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the GetTransactionByGuidV1.1 method");
                var transaction = await _pizzaRepo.GetTransactionByGuidV1_1(transactionGuid);
                if (transaction != null)
                {
                    Serilog.Log.Logger.Here().Information("Returning V1.1 transaction with {@Guid}", transactionGuid);
                    return Ok(transaction);
                }
                Serilog.Log.Logger.Here().Warning($"No V1.1 transaction found with guid: {transactionGuid}");
                return NotFound();
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Failed to retrieve transaction with {@Guid}, because {ExceptionMessage}", transactionGuid, e);
                return StatusCode(500);
            }
        }
        [MapToApiVersion("1.1")]
        [HttpPost("ValidateTransaction")]
        public async Task<TransactionValidationResponse> ValidateTransaction([FromBody] LocalTransactionV1_1 transaction)
        {

            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the ValidateTransactionV1.1 method");
                var settings = await _pizzaRepo.GetSettings();
                var utc = DateTime.UtcNow;
                //Get Time zone info on windows, if not use linux convention
                TimeZoneInfo pdt;
                if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                    pdt = TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time");
                else
                    pdt = TimeZoneInfo.FindSystemTimeZoneById("America/Los_Angeles");
                DateTime pdtTime = TimeZoneInfo.ConvertTimeFromUtc(utc, pdt);
                var hoursToday = settings.StoreHours.FirstOrDefault(x => x.Day.ToString() == pdtTime.DayOfWeek.ToString());
                if (!TimeBetween(pdtTime, hoursToday.OpeningTime.Value.TimeOfDay, hoursToday.ClosingTime.Value.TimeOfDay))
                {
                    return new TransactionValidationResponse() { Succeeded = false, Message = $"Store is not open. Hours today are from {hoursToday.OpeningTime.Value.ToString("h:mm tt")} to {hoursToday.ClosingTime.Value.ToString("h:mm tt")}" };
                }
                if (transaction.IsDelivery || transaction.NoContactDelivery)
                {
                    List<string> ZipCodes = new List<string>();
                    foreach (var zipcode in settings.ZipCodes)
                    {
                        ZipCodes.Add(zipcode.ZipCodeValue.ToString());
                    }
                    if (string.IsNullOrEmpty(transaction.Info.ZipCode))
                    {
                        Serilog.Log.Logger.Here().Information($"Zip Code was null for transaction: {transaction}");
                        return new TransactionValidationResponse() { Succeeded = false, Message = "Zip Code was empty" };
                    }
                    if (!ZipCodes.Contains(transaction.Info.ZipCode.ToString()))
                    {
                        Serilog.Log.Logger.Here().Information($"Zip Code out of range for transaction: {transaction}");
                        return new TransactionValidationResponse() { Succeeded = false, Message = "Zip Code out of range" };
                    }
                    if (transaction.Info.City.Trim().ToUpper() != "HENDERSON")
                    {
                        Serilog.Log.Logger.Here().Information($"City out of range for transaction: {transaction}");
                        return new TransactionValidationResponse() { Succeeded = false, Message = "City out of range" };
                    }
                }
                Serilog.Log.Logger.Here().Information("Validated transaction: {@LocalTransaction}", transaction);
                return new TransactionValidationResponse() { Succeeded = true, TransactionGuid = Guid.NewGuid() };
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Failed to validate transaction: {@LocalTransaction}, because: {@Exception.Message} with inner exception: {@Exception.Message}", transaction, e.Message, e.InnerException.Message);
                return new TransactionValidationResponse() { Succeeded = false, Message = "Validation Failed" };
            }

        }
        [MapToApiVersion("1.0")]
        [HttpPost("ValidateTransaction")]
        public async Task<TransactionValidationResponse> ValidateTransaction([FromBody] LocalTransaction transaction)
        {

            try
            {
                Serilog.Log.Logger.Here().Information($"Entered the ValidateTransaction method");
                var settings = await _pizzaRepo.GetSettings();
                var utc = DateTime.UtcNow;
                //Get Time zone info on windows, if not use linux convention
                TimeZoneInfo pdt;
                if (RuntimeInformation.IsOSPlatform(OSPlatform.Windows))
                    pdt = TimeZoneInfo.FindSystemTimeZoneById("Pacific Standard Time");
                else
                    pdt = TimeZoneInfo.FindSystemTimeZoneById("America/Los_Angeles");
                DateTime pdtTime = TimeZoneInfo.ConvertTimeFromUtc(utc, pdt);
                var hoursToday = settings.StoreHours.FirstOrDefault(x => x.Day.ToString() == pdtTime.DayOfWeek.ToString());
                if (!TimeBetween(pdtTime, hoursToday.OpeningTime.Value.TimeOfDay, hoursToday.ClosingTime.Value.TimeOfDay))
                {
                    return new TransactionValidationResponse() { Succeeded = false, Message = $"Store is not open. Hours today are from {hoursToday.OpeningTime.Value.ToString("h:mm tt")} to {hoursToday.ClosingTime.Value.ToString("h:mm tt")}" };
                }
                if (transaction.IsDelivery)
                {
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
                }
                Serilog.Log.Logger.Here().Information("Validated transaction: {@LocalTransaction}", transaction);
                return new TransactionValidationResponse() { Succeeded = true, TransactionGuid = Guid.NewGuid() };
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Failed to validate transaction: {@LocalTransaction}, because: {@Exception.Message} with inner exception: {@Exception.Message}", transaction, e.Message, e.InnerException.Message);
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
                Serilog.Log.Logger.Here().Information("Returning Groups");
                return Ok(groups);
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to retrieve groups, because: {ExceptionMessage}", e);
                return StatusCode(500);
            }
        }
        #endregion


        #region KDS
        [HttpPost(), Route("UpdateDeliveryTime")]
        public async Task<IActionResult> UpdateDeliveryTime(UpdateDeliveryTimeRequest request)
        {
            try
            {
                var settings = await _pizzaRepo.GetSettings();
                var succeeded = await SendText(request.Message, request.PhoneNumber, settings.TwilioAccountSid, settings.TwilioAuthToken, settings.TwilioPhoneNumber);
                if (succeeded)
                    return Ok(new UpdateDeliveryTimeResponse() { Succeeded = true });
                else
                    return Ok(new UpdateDeliveryTimeResponse() { Succeeded = false, Message = "Unable to send text" });
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to delete address for a user, because: {ExceptionMessage}", e);
                return Ok(new SaveAddressResponse() { Succeeded = false, Message = "Something went wrong" });
            }
        }

        private async Task<bool> SendText(string text, string phoneNumber, string accountSid, string authToken, string twilioPhoneNumber)
        {
            try
            {
                TwilioClient.Init(accountSid, authToken);
                var message = MessageResource.Create(
                body: $"{text}",
                from: new Twilio.Types.PhoneNumber(twilioPhoneNumber),
                to: new Twilio.Types.PhoneNumber(phoneNumber)
                );
                if (message.Status == StatusEnum.Failed)
                    return false;
                else
                    return true;
            }
            catch (Exception e)
            {
                Serilog.Log.Logger.Here().Error("Unable to send SMS, because: {ExceptionMessage}", e);
                return false;
            }
        }
        #endregion

        [AllowAnonymous]
        [HttpGet(), Route("EmailTest")]
        public async Task<IActionResult> SendEmail()
        {
           try
           {
               var subject = "Test Email";
               await _emailSender.SendEmailAsync("triston@conciergecode.com", subject, "Test EMAIL FROM ASP NET CORE");
               return Ok();
           }
           catch (Exception e)
           {
               Serilog.Log.Logger.Here().Error("Unable to retrieve MainMenuItems, because: {ExceptionMessage}", e);
               return StatusCode(500);
           }
        }
        //[HttpGet("SendText")]
        //[Produces("application/json", Type = typeof(DeleteAccountResponse))]
        //[AllowAnonymous]
        //public async Task<IActionResult> SendText()
        //{
        //    try
        //    {
        //        var settings = await _pizzaRepo.GetSettings();
        //        await SendText("blah", "9515950240", settings.TwilioAccountSid, settings.TwilioAuthToken, settings.TwilioPhoneNumber);
        //    }

        //    catch (Exception exception)
        //    {
        //        Serilog.Log.Logger.Here().Error(exception, "Something terrible happened while logging in, because: {message}", exception.Message);
        //    }

        //    return BadRequest("Failed to login");
        //}
    }
}