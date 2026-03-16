using JessesPizza.Core;
using JessesPizza.Core.Helpers;
using JessesPizza.Core.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Xunit;
using FluentAssertions;
[assembly: CollectionBehavior(DisableTestParallelization = true)]
namespace JessesPizza.Data.Tests
{
    [TestCaseOrderer("JessesPizza.Data.Tests.AlphabeticalOrderer", "JessesPizza.Data.Tests")]
    public class SettingsTests
    {
        static IPizzaRepo _pizzaRepo;
        public SettingsTests()
        {
            //_pizzaRepo = new PizzaRepo(APIKeys.TestConnectionString);
        
        }

        [Fact]
        public async Task AllSettingsTests()
        {
            await a_should_add_settings_when_command_valid();
            await b_should_update_settings_when_command_valid();
            await c_shouldnot_add_settings_when_already_exists();
            await d_should_remove_settings_when_command_valid();
        }

        private async Task ResetSettings()
        {
            var settings = await _pizzaRepo.GetSettings();
            if(settings != null)
                await _pizzaRepo.RemoveSettings(settings);
        }

        private async Task a_should_add_settings_when_command_valid()
        {
            await ResetSettings();
            var storeHours = new List<StoreHours>() { new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Monday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Tuesday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Wednesday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Thursday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Friday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Saturday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Sunday },};
            var expected = new JessesPizzaSettings() {StoreHours=storeHours, Id=IdHelper.GetUniqueId().ToLower(),  MerchantId = "blah", MinimumOrderAmount = 12M, AboutText = "about jesses", DeliveryCharge = 12M, Pin = "blah", TaxRate = 8.23M, UserId = "blah", ZipCodes = new List<ZipCode>() { new ZipCode() { ZipCodeValue = "90993" }, new ZipCode() { ZipCodeValue = "90922" } } };
            await _pizzaRepo.AddSettings(expected);
            var result = await _pizzaRepo.GetSettings();
            result.Should().BeEquivalentTo(expected, options => options.Using<DateTime>(ctx => ctx.Subject.Should().BeCloseTo(ctx.Expectation)).WhenTypeIs<DateTime>());
        }
        private async Task b_should_update_settings_when_command_valid()
        {
            var expected = await _pizzaRepo.GetSettings();
            expected.TaxRate = 15.00M;
            expected.AboutText = "new";
            expected.StoreHours = new List<StoreHours>();
            expected.Pin = "new";
            expected.MerchantId = "new";
            expected.UserId= "new";
            expected.ZipCodes = new List<ZipCode>();
            expected.MinimumOrderAmount = 15M;
            expected.DeliveryCharge = 10M;
            await _pizzaRepo.UpdateSettings(expected);
            var result = await _pizzaRepo.GetSettings();
            result.Should().BeEquivalentTo(expected, options => options.Using<DateTime>(ctx => ctx.Subject.Should().BeCloseTo(ctx.Expectation)).WhenTypeIs<DateTime>());
        }
        private async Task c_shouldnot_add_settings_when_already_exists()
        {
            var expected = await _pizzaRepo.GetSettings();

            var storeHours = new List<StoreHours>() { new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Monday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Tuesday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Wednesday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Thursday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Friday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Saturday },
            new StoreHours() {ClosingTime= DateTime.UtcNow,OpeningTime=DateTime.UtcNow , Day=DayOfTheWeek.Sunday },};
            var settings = new JessesPizzaSettings() { StoreHours = storeHours, Id = IdHelper.GetUniqueId().ToLower(), MerchantId = "blah", MinimumOrderAmount = 12M, AboutText = "about jesses", DeliveryCharge = 12M, Pin = "blah", TaxRate = 8.23M, UserId = "blah", ZipCodes = new List<ZipCode>() { new ZipCode() { ZipCodeValue = "90993" }, new ZipCode() { ZipCodeValue = "90922" } } };
            await _pizzaRepo.AddSettings(settings);
            var result = await _pizzaRepo.GetSettings();
            result.Should().BeEquivalentTo(expected, options => options.Using<DateTime>(ctx => ctx.Subject.Should().BeCloseTo(ctx.Expectation)).WhenTypeIs<DateTime>());
        }
        private async Task d_should_remove_settings_when_command_valid()
        {
            var settings = await _pizzaRepo.GetSettings();
            await _pizzaRepo.RemoveSettings(settings);
            var result = await _pizzaRepo.GetSettings();
            Assert.Null(result);
        }


    }
}
