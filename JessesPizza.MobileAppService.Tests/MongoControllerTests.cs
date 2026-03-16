using Flurl.Http;
using Flurl.Http.Xml;
using Flurl;
using JessesPizza.Core.Models.Transactions;
using System;
using System.Collections.Generic;
using System.Net.Http;
using Xunit;
using System.Xml.Serialization;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Xml;
using SendGrid;
using SendGrid.Helpers.Mail;
using JessesPizza.Core.Models;
using System.Threading.Tasks;
using JessesPizza.Data;
using Moq;
using FluentAssertions;
using JessesPizza.Core.Helpers;
using JessesPizza.MobileAppService.Controllers;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.SignalR;
using Amazon;
using Amazon.S3;
using Amazon.S3.Model;
using JessesPizza.MobileAppService.Services;
using Microsoft.AspNetCore.Mvc.Razor;

namespace JessesPizza.MobileAppService.Tests
{
    public class MongoControllerTests
    {
        private  readonly Mock<IPizzaRepo> _pizzaRepo;
        private readonly Mock<IHubContext<PizzaHub>>  _pizzaHub;
        private readonly Mock<ILogger<MongoController>> _logger;
        private readonly Mock<IRazorViewToStringRenderer> _renderer;
        readonly MongoController _controller;

        public MongoControllerTests()
        {
            _pizzaRepo = new Mock<IPizzaRepo>();
            _pizzaHub = new Mock<IHubContext<PizzaHub>>();
            _logger = new Mock<ILogger<MongoController>>();
            _renderer = new Mock<IRazorViewToStringRenderer>();

            _controller = new MongoController(_pizzaRepo.Object,
                _pizzaHub.Object,
                _logger.Object,
                _renderer.Object
            );

            _controller.ControllerContext = new ControllerContext
            {
                HttpContext = new DefaultHttpContext
                {
                    User = new ClaimsPrincipal(new ClaimsIdentity(new Claim[]
                    {
                        new Claim(ClaimTypes.Name, "username")
                    }, "someAuthTypeName"))
                }
            };
        }

        #region MainMenuItems


        [Fact]
        public async void GetMainMenuItems_ShouldReturnMainMenuItems()
        {
            var items = new List<JessesMenuItem>() { new JessesMenuItem() { Name = "Item 1", ImageUrl = "blah", Description = "description", Id = IdHelper.GetUniqueId().ToLower(), Sizes = new List<JessesItemSize>() } };
            var mainMenuItem = new MainMenuItem() { Id = IdHelper.GetUniqueId().ToLower(), ImageUrl = "blah", Name = "jessesItem", MenuItems = items };
            var items1 = new List<JessesMenuItem>() { new JessesMenuItem() { Name = "Item 2", ImageUrl = "blah1", Description = "description1", Id = IdHelper.GetUniqueId().ToLower(), Sizes = new List<JessesItemSize>() } };
            var mainMenuItem1 = new MainMenuItem() { Id = IdHelper.GetUniqueId().ToLower(), ImageUrl = "blah1", Name = "jessesItem1", MenuItems = items1 };
            var list = new List<MainMenuItem>() { mainMenuItem, mainMenuItem1 };
            _pizzaRepo.Setup(repo => repo.GetAllMainMenuItems())
                .ReturnsAsync(list);
            var result = await _controller.GetMainMenuItems();
            var objectResult = Assert.IsType<OkObjectResult>(result);
            objectResult.Value.Should().BeEquivalentTo(list);
        }
        [Fact]
        public async void GetMainMenuItems_ShouldNotReturnMainMenuItems()
        {
            _pizzaRepo.Setup(repo => repo.GetAllMainMenuItems())
                .ThrowsAsync(new Exception());
            var result = await _controller.GetMainMenuItems();
            var objectResult = Assert.IsType<StatusCodeResult>(result);
            objectResult.StatusCode.Should().Be(500);
        }

        #endregion

        #region Groups
        [Fact]
        public async void GetGroups_ShouldReturnGroups()
        {
            var items = new List<GroupItem>() { new GroupItem() { Name = "Item 1", ImageUrl = "blah", Id = IdHelper.GetUniqueId().ToLower(), Sizes = new List<ItemSize>() } };
            var group = new Group() { Id = IdHelper.GetUniqueId().ToLower(), ImageUrl = "blah", Name = "jessesItem", Items = items, Max = 2, Min = 1, GroupType = 2, Type = GroupType.MinMax, IsRequired = false };
            var items1 = new List<GroupItem>() { new GroupItem() { Name = "Item 2", ImageUrl = "blah1", Id = IdHelper.GetUniqueId().ToLower(), Sizes = new List<ItemSize>() { new ItemSize() { Price = 10M, Default = true, Name = "size1" } }, Sides = new List<ItemSide>() { new ItemSide() { Price = 10M, Name = "size1", Icon = "Blah", IsDefault = true } } } };
            var group1 = new Group() { Id = IdHelper.GetUniqueId().ToLower(), ImageUrl = "blah1", Name = "jessesItem1", Items = items1 };
            var list = new List<Group>() { group, group1 };
            _pizzaRepo.Setup(repo => repo.GetAllGroups())
                .ReturnsAsync(list);
            var result = await _controller.GetGroups();
            var objectResult = Assert.IsType<OkObjectResult>(result);
            objectResult.Value.Should().BeEquivalentTo(list);
        }
        [Fact]
        public async void GetGroups_ShouldNotReturnGroups()
        {
            _pizzaRepo.Setup(repo => repo.GetAllGroups())
                .ThrowsAsync(new Exception());
            var result = await _controller.GetGroups();
            var objectResult = Assert.IsType<StatusCodeResult>(result);
            objectResult.StatusCode.Should().Be(500);
        }
        #endregion


        #region ValidateTransactionAmount
        [Fact]
        public async void ValidateTransactionAmount_shouldReturnTrue()
        {
            var settings = new JessesPizzaSettings() { MinimumOrderAmount = 10M };
            _pizzaRepo.Setup(repo => repo.GetSettings())
                .ReturnsAsync(settings);
            var result = await _controller.ValidateTransactionAmount(15M);
            var objectResult = Assert.IsType<TransactionValidationResponse>(result);
            objectResult.Succeeded.Should().BeTrue();
        }
        [Fact]
        public async void ValidateTransactionAmount_ShouldReturnFalse()
        {
            var settings = new JessesPizzaSettings() { MinimumOrderAmount = 100M };
            _pizzaRepo.Setup(repo => repo.GetSettings())
                .ReturnsAsync(settings);
            var result = await _controller.ValidateTransactionAmount(15M);
            var objectResult = Assert.IsType<TransactionValidationResponse>(result);

            objectResult.Should().BeEquivalentTo(new TransactionValidationResponse() { Succeeded = false, Message = $"Total must be at least {settings.MinimumOrderAmount.ToString("C")}" });
        }
        [Fact]
        public async void ValidateTransactionAmount_ShouldReturnFalse_when_exception_thrown()
        {
            _pizzaRepo.Setup(repo => repo.GetSettings())
                .ThrowsAsync(new Exception());
            var result = await _controller.ValidateTransactionAmount(100M);
            var objectResult = Assert.IsType<TransactionValidationResponse>(result);
            objectResult.Should().BeEquivalentTo(new TransactionValidationResponse() { Succeeded = false, Message = "Validation Failed" });
        }


        #endregion

        [Fact]
        public async void TemplateTest()
        {


            try
            {
            }
            catch (Exception e)
            {
            }
        }

        [Fact]
        public async void S3Test()
        {
            const string bucketName = "jessesimages";
            //implicity the example creates two objects from the same file.
            //pecify key names for these objects.
            const string keyName1 = "image2";
            const string keyName2 = "*** key name for second object created ***";
            const string filePath = @"*** file path ***";
            RegionEndpoint bucketRegion = RegionEndpoint.USWest1;
            IAmazonS3 client;

            try
            {
                client = new AmazonS3Client(bucketRegion);
                var putRequest1 = new PutObjectRequest
                {
                    BucketName = bucketName,
                    Key = keyName1,
                    FilePath = string.Concat(Directory.GetCurrentDirectory(), "/logo.jpg")
                };
                PutObjectResponse response1 = await client.PutObjectAsync(putRequest1);

            }
            catch (Exception e)
            {
            }
        }

        [Fact]
        public async void ConvergeAPI()
        {
            try
            {
                var convergeUrl = "https://api.demo.convergepay.com/hosted-payments/transaction_token";
                var customerCode = Guid.NewGuid();
                var convergeTokenRequest = new ConvergeHPPTokenRequest() { ssl_customer_code = customerCode.ToString(), ssl_merchant_id = "011449", ssl_user_id = "webpage", ssl_amount = "10.50", ssl_pin = "WXHNJM", ssl_transaction_type = "ccgettoken" };
                var response = await convergeUrl.SendUrlEncodedAsync(HttpMethod.Post, convergeTokenRequest).ReceiveString();

                if (!string.IsNullOrEmpty(response))
                {
                    var payment = new MongoTransaction();
                    payment.TransactionGuid = customerCode;
                    payment.HPPToken = response;
                    var encodedToken = System.Web.HttpUtility.UrlEncode(response);
                    payment.HPPToken = string.Concat("https://api.demo.convergepay.com/hosted-payments/?ssl_txn_auth_token=", encodedToken);
                }
            }
            catch (Exception e)
            {
            }
        }

        #region ValidateTransaction

        [Fact]
        public async void ValidateTransaction_should_fail_when_store_is_not_open()
        {
            var storeHours = new List<StoreHours>() { new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Monday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Tuesday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Wednesday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Thursday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Friday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Saturday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Sunday },};
            var settings = new JessesPizzaSettings() { StoreHours = storeHours, Id = IdHelper.GetUniqueId().ToLower(), MerchantId = "blah", MinimumOrderAmount = 12M, AboutText = "about jesses", DeliveryCharge = 12M, Pin = "blah", TaxRate = 8.23M, UserId = "blah", ZipCodes = new List<ZipCode>() { new ZipCode() { ZipCodeValue = "90993" }, new ZipCode() { ZipCodeValue = "90922" } } };
            var localTransaction = new LocalTransaction()
            {
                    Info = new CustomerInfoApp()
                    {
                        PhoneNumber = "blah",
                        AddressLine1 = "blah",
                        City = "blah",
                        EmailAddress = "mutlusean@gmail.com",
                        FirstName = "sean",
                        LastName = "blah",
                        ZipCode = "12345"
                    }
                ,
                Totals = new OrderTotals()
                {
                    TaxTotal = 10M,
                    DeliveryCharge = 20M,
                    SubTotal = 120M,
                    Total = 150M,
                    Id = 122334,
                    Tip = 10M
                },
                TransactionId = Guid.NewGuid(),
                TransactionItems = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                }
            };
            _pizzaRepo.Setup(repo => repo.GetSettings())
                .ReturnsAsync(settings);
            var hoursToday = settings.StoreHours.FirstOrDefault(x => x.Day.ToString() == DateTime.Now.DayOfWeek.ToString());

            var result = await _controller.ValidateTransaction(localTransaction);
            var objectResult = Assert.IsType<TransactionValidationResponse>(result);
            objectResult.Should().BeEquivalentTo(new TransactionValidationResponse() { Succeeded = false, Message = $"Store is not open. Hours Today are from {hoursToday.OpeningTime.Value.ToString("h:mm tt")} to {hoursToday.ClosingTime.Value.ToString("h:mm tt")}" });
        }
        [Fact]
        public async void ValidateTransaction_should_fail_when_ZipCode_is_not_in_range()
        {
            var storeHours = new List<StoreHours>() { new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Monday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Tuesday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Wednesday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Thursday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Friday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Saturday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Sunday },};
            var settings = new JessesPizzaSettings() { StoreHours = storeHours, Id = IdHelper.GetUniqueId().ToLower(), MerchantId = "blah", MinimumOrderAmount = 12M, AboutText = "about jesses", DeliveryCharge = 12M, Pin = "blah", TaxRate = 8.23M, UserId = "blah", ZipCodes = new List<ZipCode>() { new ZipCode() { ZipCodeValue = "90993" }, new ZipCode() { ZipCodeValue = "90922" } } };
            var localTransaction = new LocalTransaction()
            {
                    Info = new CustomerInfoApp()
                    {
                        PhoneNumber = "blah",
                        AddressLine1 = "blah",
                        City = "blah",
                        EmailAddress = "mutlusean@gmail.com",
                        FirstName = "sean",
                        LastName = "blah",
                        ZipCode = "12345"
                    
                },
                Totals = new OrderTotals()
                {
                    TaxTotal = 10M,
                    DeliveryCharge = 20M,
                    SubTotal = 120M,
                    Total = 150M,
                    Id = 122334,
                    Tip = 10M
                },
                TransactionId = Guid.NewGuid(),
                TransactionItems = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                }
            };
            _pizzaRepo.Setup(repo => repo.GetSettings())
                .ReturnsAsync(settings);
            var result = await _controller.ValidateTransaction(localTransaction);
            var objectResult = Assert.IsType<TransactionValidationResponse>(result);
            objectResult.Should().BeEquivalentTo(new TransactionValidationResponse() { Succeeded = false, Message = "Zip Code out of range" });
        }
        [Fact]
        public async void ValidateTransaction_should_fail_when_City_is_not_in_range()
        {
            var storeHours = new List<StoreHours>() { new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Monday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Tuesday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Wednesday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Thursday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Friday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Saturday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Sunday },};
            var settings = new JessesPizzaSettings() { StoreHours = storeHours, Id = IdHelper.GetUniqueId().ToLower(), MerchantId = "blah", MinimumOrderAmount = 12M, AboutText = "about jesses", DeliveryCharge = 12M, Pin = "blah", TaxRate = 8.23M, UserId = "blah", ZipCodes = new List<ZipCode>() { new ZipCode() { ZipCodeValue = "90993" }, new ZipCode() { ZipCodeValue = "90922" } } };
            var localTransaction = new LocalTransaction()
            {
                Info = new CustomerInfoApp()
                {
                    PhoneNumber = "blah",
                    AddressLine1 = "blah",
                    City = "blah",
                    EmailAddress = "mutlusean@gmail.com",
                    FirstName = "sean",
                    LastName = "blah",
                    ZipCode = "90922"
                }
                ,
                Totals = new OrderTotals()
                {
                    TaxTotal = 10M,
                    DeliveryCharge = 20M,
                    SubTotal = 120M,
                    Total = 150M,
                    Id = 122334,
                    Tip = 10M
                },
                TransactionId = Guid.NewGuid(),
                TransactionItems = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                }
            };
            _pizzaRepo.Setup(repo => repo.GetSettings())
                .ReturnsAsync(settings);
            var result = await _controller.ValidateTransaction(localTransaction);
            var objectResult = Assert.IsType<TransactionValidationResponse>(result);
            objectResult.Should().BeEquivalentTo(new TransactionValidationResponse() { Succeeded = false, Message = "City out of range" });
        }
        [Fact]
        public async void ValidateTransaction_should_succeed_when_command_valid()
        {
            var storeHours = new List<StoreHours>() { new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Monday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Tuesday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Wednesday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Thursday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Friday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Saturday },
                new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Sunday },};
            var settings = new JessesPizzaSettings() { StoreHours = storeHours, Id = IdHelper.GetUniqueId().ToLower(), MerchantId = "blah", MinimumOrderAmount = 12M, AboutText = "about jesses", DeliveryCharge = 12M, Pin = "blah", TaxRate = 8.23M, UserId = "blah", ZipCodes = new List<ZipCode>() { new ZipCode() { ZipCodeValue = "90993" }, new ZipCode() { ZipCodeValue = "90922" } } };
            var localTransaction = new LocalTransaction()
            {
                    Info = new CustomerInfoApp()
                    {
                        PhoneNumber = "blah",
                        AddressLine1 = "blah",
                        City = "Henderson",
                        EmailAddress = "mutlusean@gmail.com",
                        FirstName = "sean",
                        LastName = "blah",
                        ZipCode = "90922"
                    }
                ,
                Totals = new OrderTotals()
                {
                    TaxTotal = 10M,
                    DeliveryCharge = 20M,
                    SubTotal = 120M,
                    Total = 150M,
                    Id = 122334,
                    Tip = 10M
                },
                TransactionId = Guid.NewGuid(),
                TransactionItems = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                }
            };
            _pizzaRepo.Setup(repo => repo.GetSettings())
                .ReturnsAsync(settings);
            var result = await _controller.ValidateTransaction(localTransaction);
            var objectResult = Assert.IsType<TransactionValidationResponse>(result);
            objectResult.Succeeded.Should().BeTrue();
        }
        [Fact]
        public async void ValidateTransaction_should_fail_when_exception_thrown()
        {
            _pizzaRepo.Setup(repo => repo.GetSettings())
                .ThrowsAsync(new Exception());
            var result = await _controller.ValidateTransaction(new LocalTransaction());
            var objectResult = Assert.IsType<TransactionValidationResponse>(result);
            objectResult.Should().BeEquivalentTo(new TransactionValidationResponse() { Succeeded = false, Message = "Validation Failed" });
        }


        #endregion

        #region GetTransactionByGuid

        [Fact]
        public async void GetTransactionByGuid_should_return_transaction_when_command_valid()
        {
            var guid = Guid.NewGuid();
            var transaction = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu",
                City = "henderson",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "94519490",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid
            };
            _pizzaRepo.Setup(repo => repo.GetTransactionByGuid(guid))
                .ReturnsAsync(transaction);
            var result = await _controller.GetTransactionByGuid(guid);
            var objectResult = Assert.IsType<OkObjectResult>(result);
            objectResult.Value.Should().BeEquivalentTo(transaction);
        }
        [Fact]
        public async void GetTransactionByGuid_should_fail_when_exception_thrown()
        {
            var guid = Guid.NewGuid();
            var transaction = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu",
                City = "henderson",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "94519490",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid
            };
            _pizzaRepo.Setup(repo => repo.GetTransactionByGuid(guid))
                .ThrowsAsync(new Exception());
            var result = await _controller.GetTransactionByGuid(guid);
            var objectResult = Assert.IsType<StatusCodeResult>(result);
            objectResult.StatusCode.Should().Be(500);
        }
        [Fact]
        public async void GetTransactionByGuid_should_return_notfound_when_no_transactions()
        {
            var guid = Guid.NewGuid();
            _pizzaRepo.Setup(repo => repo.GetTransactionByGuid(guid))
                .ReturnsAsync((MongoTransaction)null);
            var result = await _controller.GetTransactionByGuid(guid);
            var objectResult = Assert.IsType<NotFoundResult>(result);

        }
        #endregion

        #region GetAllTransactions

        [Fact]
        public async void GetAllTransactions_should_fail_when_exception_thrown()
        {
            _pizzaRepo.Setup(repo => repo.GetAllTransactions())
                .ThrowsAsync(new Exception());
            var result = await _controller.GetAllTransactions();
            var objectResult = Assert.IsType<StatusCodeResult>(result);
            objectResult.StatusCode.Should().Be(500);
        }
        [Fact]
        public async void GetAllTransactions_should_return_transactions_when_command_valid()
        {
            var guid = Guid.NewGuid();
            var guid1 = Guid.NewGuid();

            var transaction = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu",
                City = "henderson",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "94519490",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid
            };
            var transaction1 = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah1",
                        SelectedSizeId = "blah1",
                        ImageUrl = "www.blah1.com",
                        Price = 10m,
                        MenuItemId = "Blah1",
                        SizeName = "name1",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luechees1e",
                        RequiredDelimitedString = "blue/chees1e",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranc1h",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah1",
                        Description = "food1",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu1",
                City = "henderson1",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "945194901",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean1@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara temecula",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid1
            };
            var list = new List<MongoTransaction>() { transaction1, transaction };
            _pizzaRepo.Setup(repo => repo.GetAllTransactions())
                .ReturnsAsync(list);
            var result = await _controller.GetAllTransactions();
            var objectResult = Assert.IsType<OkObjectResult>(result);
            objectResult.Value.Should().BeEquivalentTo(list);
        }
        [Fact]
        public async void GetAllTransactions_should_return_notfound_when_no_transactions()
        {
            _pizzaRepo.Setup(repo => repo.GetAllTransactions())
                .ReturnsAsync((IEnumerable<MongoTransaction>)null);
            var result = await _controller.GetAllTransactions();
            var objectResult = Assert.IsType<NotFoundResult>(result);

        }

        #endregion

        #region GetTransactionsByState
        [Fact]
        public async void GetTransactionsByState_should_return_transactions_when_command_valid()
        {
            var guid = Guid.NewGuid();
            var guid1 = Guid.NewGuid();

            var transaction = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu",
                City = "henderson",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "94519490",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid
            };
            var transaction1 = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah1",
                        SelectedSizeId = "blah1",
                        ImageUrl = "www.blah1.com",
                        Price = 10m,
                        MenuItemId = "Blah1",
                        SizeName = "name1",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luechees1e",
                        RequiredDelimitedString = "blue/chees1e",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranc1h",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah1",
                        Description = "food1",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu1",
                City = "henderson1",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "945194901",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean1@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara temecula",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid1
            };
            var list = new List<MongoTransaction>() { transaction1, transaction };
            _pizzaRepo.Setup(repo => repo.GetTransactionsByState(TransactionState.Authorized))
                .ReturnsAsync(list);
            var result = await _controller.GetTransactions(TransactionState.Authorized);
            var objectResult = Assert.IsType<OkObjectResult>(result);
            objectResult.Value.Should().BeEquivalentTo(list);
        }
        [Fact]
        public async void GetTransactionsByState_should_return_notfound_when_no_transactions()
        {
            _pizzaRepo.Setup(repo => repo.GetTransactionsByState(TransactionState.Authorized))
                .ReturnsAsync((List<MongoTransaction>)null);
            var result = await _controller.GetTransactions(TransactionState.Authorized);
            var objectResult = Assert.IsType<NotFoundResult>(result);

        }
        [Fact]
        public async void GetTransactionsByState_should_return_500_when_exception_thrown()
        {
            _pizzaRepo.Setup(repo => repo.GetTransactionsByState(TransactionState.Authorized))
                .ThrowsAsync(new Exception());
            var result = await _controller.GetTransactions(TransactionState.Authorized);
            var objectResult = Assert.IsType<StatusCodeResult>(result);
            objectResult.StatusCode.Should().Be(500);

        }


        #endregion

        #region UpdateTransaction

        [Fact]
        public async void updatetransaction_should_update_transaction()
        {
            var guid = Guid.NewGuid();

            var transaction = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu",
                City = "henderson",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "94519490",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid
            };
            var transaction1 = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah1",
                        SelectedSizeId = "blah1",
                        ImageUrl = "www.blah1.com",
                        Price = 10m,
                        MenuItemId = "Blah1",
                        SizeName = "name1",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luechees1e",
                        RequiredDelimitedString = "blue/chees1e",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranc1h",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah1",
                        Description = "food1",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu1",
                City = "henderson1",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "945194901",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean1@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara temecula",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid
            };
            _pizzaRepo.Setup(repo => repo.UpdateTransaction(transaction))
                .ReturnsAsync(transaction1);
            var result = await _controller.UpdateTransaction(transaction);
            var objectResult = Assert.IsType<MongoTransaction>(result);
            objectResult.Should().BeEquivalentTo(transaction1);



        }

        [Fact]
        public async void updatetransaction_should_not_update_transaction_when_exception_thrown()
        {
            var guid = Guid.NewGuid();

            var transaction = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu",
                City = "henderson",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "94519490",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid
            };
            _pizzaRepo.Setup(repo => repo.UpdateTransaction(transaction))
                .ThrowsAsync(new Exception());
            var result = await _controller.UpdateTransaction(transaction);
            result.Should().BeEquivalentTo((MongoTransaction)null);



        }

        #endregion

        #region UpdateTransactionState

        [Fact]
        public async void updatetransactionstate_should_update_transactionstate()
        {
            var guid = Guid.NewGuid();

            var transaction = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu",
                City = "henderson",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "94519490",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid
            };
            _pizzaRepo.Setup(repo => repo.GetTransactionByGuid(guid))
                .ReturnsAsync(transaction);
            _pizzaRepo.Setup(repo => repo.UpdateTransactionState(transaction))
                .ReturnsAsync(new MongoTransaction(){TransactionGuid = guid, TransactionState = TransactionState.InKitchen});
            var result = await _controller.UpdateTransactionState(new UpdateTransactionStateRequest(){State = TransactionState.InKitchen,TransactionGuid = guid});
            var objectResult = Assert.IsType<bool>(result);
            objectResult.Should().BeTrue();



        }

        [Fact]
        public async void updatetransactionstate_should_not_update_transactionstate_when_exception_thrown()
        {
            var guid = Guid.NewGuid();

            var transaction = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu",
                City = "henderson",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "94519490",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid
            };
            _pizzaRepo.Setup(repo => repo.GetTransactionByGuid(guid))
                .ThrowsAsync(new Exception());
            var result = await _controller.UpdateTransactionState(new UpdateTransactionStateRequest() { State = TransactionState.InKitchen, TransactionGuid = guid });
            var objectResult = Assert.IsType<bool>(result);
            objectResult.Should().BeFalse();



        }

        [Fact]
        public async void updatetransactionstate_should_return_false_when_transactionstate_is_not_updated()
        {
            var guid = Guid.NewGuid();

            var transaction = new MongoTransaction()
            {
                Items = new List<ShoppingCartItem>()
                {
                    new ShoppingCartItem()
                    {
                        Name = "blah",
                        SelectedSizeId = "blah",
                        ImageUrl = "www.blah.com",
                        Price = 10m,
                        MenuItemId = "Blah",
                        SizeName = "name",
                        RequiredChoicesEnabled = true,
                        RequiredChoices = "luecheese",
                        RequiredDelimitedString = "blue/cheese",
                        OptionalChoicesEnabled = true,
                        OptionalChoices = "ranch",
                        OptionalDelimitedString = "ranch/20x",
                        Quantity = 2,
                        InstructionsEnabled = true,
                        Instructions = "blah",
                        Description = "food",
                        Id = 123456
                    }
                },
                Name = "sean Mutlu",
                City = "henderson",
                ZipCode = 12345,
                DeliveryCharge = 10M,
                SubTotal = 20M,
                Total = 45M,
                PhoneNumber = "94519490",
                TransactionState = TransactionState.Authorized,
                TaxTotal = 5M,
                Email = "mutlusean@gmail.com",
                Date = DateTime.UtcNow,
                Address1 = "40535 calle tiara",
                HPPToken = "231245",
                ConvergeTransactionId = Guid.NewGuid().ToString(),
                TransactionGuid = guid
            };
            _pizzaRepo.Setup(repo => repo.GetTransactionByGuid(guid))
                .ReturnsAsync(transaction);
            _pizzaRepo.Setup(repo => repo.UpdateTransactionState(transaction))
                .ReturnsAsync(new MongoTransaction() { TransactionGuid = guid, TransactionState = TransactionState.Authorized });
            var result = await _controller.UpdateTransactionState(new UpdateTransactionStateRequest() { State = TransactionState.InKitchen, TransactionGuid = guid });
            var objectResult = Assert.IsType<bool>(result);
            objectResult.Should().BeFalse();



        }
        #endregion

        #region GetOrderInfo
        [Fact]
        public async void GetOrderInfo_should_return_notfound_when_no_settings()
        {

            _pizzaRepo.Setup(repo => repo.GetSettings())
                .ReturnsAsync((JessesPizzaSettings)null);
            var result = await _controller.GetOrderInfo();
            var objectResult = Assert.IsType<NotFoundResult>(result);

        }
        [Fact]
        public async void GetOrderInfo_should_return_500_when_exception_thrown()
        {
            _pizzaRepo.Setup(repo => repo.GetSettings())
                .ThrowsAsync(new Exception());
            var result = await _controller.GetOrderInfo();
            var objectResult = Assert.IsType<StatusCodeResult>(result);
            objectResult.StatusCode.Should().Be(500);

        }
        [Fact]
        public async void GetOrderInfo_should_return_settings_when_command_valid()
        {
            var storeHours = new List<StoreHours>() { new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Monday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Tuesday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Wednesday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Thursday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Friday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Saturday },
                new StoreHours() {ClosingTime= DateTime.Now-TimeSpan.FromHours(1),OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Sunday },};
            var settings = new JessesPizzaSettings() { StoreHours = storeHours, Id = IdHelper.GetUniqueId().ToLower(), MerchantId = "blah", MinimumOrderAmount = 12M, AboutText = "about jesses", DeliveryCharge = 12M, Pin = "blah", TaxRate = 8.23M, UserId = "blah", ZipCodes = new List<ZipCode>() { new ZipCode() { ZipCodeValue = "90993" }, new ZipCode() { ZipCodeValue = "90922" } } };
            _pizzaRepo.Setup(repo => repo.GetSettings())
                .ReturnsAsync(settings);
            var result = await _controller.GetOrderInfo();
            var objectResult = Assert.IsType<ObjectResult>(result);
            objectResult.StatusCode.Should().Be(200);
            objectResult.Value.Should().BeEquivalentTo(settings);

        }

        #endregion
    }
}
