using JessesPizza.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using FluentAssertions;
using JessesPizza.Core.Helpers;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using Xunit;

namespace JessesPizza.Data.Tests
{
    [TestCaseOrderer("JessesPizza.Data.Tests.AlphabeticalOrderer", "JessesPizza.Data.Tests")]
    public class TransactionsTests
    {
        static IPizzaRepo _pizzaRepo;

        public TransactionsTests()
        {
            _pizzaRepo = new PizzaRepo(APIKeys.TestConnectionString);

        }

        private async Task ResetTransactions()
        {
            var transactions = await _pizzaRepo.GetAllTransactions();
            foreach (var transaction in transactions)
            {
                await _pizzaRepo.DeleteTransaction(transaction.TransactionGuid);
            }
        }

        [Fact]
        public async Task AllTransactionTests()
        {
            await a_should_add_transaction_when_command_valid();
            await b_should_update_transaction_when_command_valid();
            await c_should_update_transactionstate_when_command_valid();
            await d_should_remove_transaction_when_command_valid();
            await e_should_not_remove_transaction_when_command_invalid();
            await f_should_return_transaction_by_state_when_command_valid();
        }

        private async Task a_should_add_transaction_when_command_valid()
        {
            await ResetTransactions();
            var items = new List<ShoppingCartItem>()
            {
                new ShoppingCartItem()
                {
                    Name = "Item 1", ImageUrl = "blah", Description = "description",Instructions = "instructions",InstructionsEnabled = true,MenuItemId = "1232",OptionalChoices = "optionalchoices",
                    Id = 11,SelectedSizeId = "blah", OptionalChoicesEnabled = true,OptionalDelimitedString = "optional/choices",Price =10M,Quantity = 12,RequiredChoices ="Blah",RequiredChoicesEnabled = true,
                    RequiredDelimitedString = "blah",SizeName = "large"
                },
                new ShoppingCartItem()
                {
                    Name = "Item 2", ImageUrl = "blah", Description = "description",Instructions = "instructions",InstructionsEnabled = true,MenuItemId = "1232",OptionalChoices = "optionalchoices",
                    Id = 1222,SelectedSizeId = "blah", OptionalChoicesEnabled = true,OptionalDelimitedString = "optional/choices",Price =10M,Quantity = 12,RequiredChoices ="Blah",RequiredChoicesEnabled = true,
                    RequiredDelimitedString = "blah",SizeName = "large"
                }
            };
            var guid = Guid.NewGuid();
            var expected = new MongoTransaction()
            {
                TransactionGuid = guid, Name = "test customer", Items=items,Address1 = "Blah",City = "henderson",ConvergeTransactionId = "blah",Date = DateTime.UtcNow,DeliveryCharge = 10M,
                Email = "mutlusean@gmail.com",HPPToken ="token",PhoneNumber = "9515950120",SubTotal = 10M,TaxTotal = 10M, Total = 232M,TransactionState = TransactionState.Authorized,ZipCode = "12323"
            };
            await _pizzaRepo.SaveNewTransaction(expected);
            var result = await _pizzaRepo.GetTransactionByGuid(guid);
            result.Should().BeEquivalentTo(expected, options => options.Using<DateTime>(ctx => ctx.Subject.Should().BeCloseTo(ctx.Expectation)).WhenTypeIs<DateTime>());
        }

        private async Task b_should_update_transaction_when_command_valid()
        {
            var transactions = await _pizzaRepo.GetAllTransactions();
            var expected = transactions.FirstOrDefault();
            var items = new List<ShoppingCartItem>()
            {
                new ShoppingCartItem()
                {
                    Name = "Item 3", ImageUrl = "blah", Description = "description",Instructions = "instructions",InstructionsEnabled = true,MenuItemId = "1232",OptionalChoices = "optionalchoices",
                    Id = 11,SelectedSizeId = "blah", OptionalChoicesEnabled = true,OptionalDelimitedString = "optional/choices",Price =10M,Quantity = 12,RequiredChoices ="Blah",RequiredChoicesEnabled = true,
                    RequiredDelimitedString = "blah",SizeName = "large"
                },
                new ShoppingCartItem()
                {
                    Name = "Item 4", ImageUrl = "blah", Description = "description",Instructions = "instructions",InstructionsEnabled = true,MenuItemId = "1232",OptionalChoices = "optionalchoices",
                    Id = 1222,SelectedSizeId = "blah", OptionalChoicesEnabled = true,OptionalDelimitedString = "optional/choices",Price =10M,Quantity = 12,RequiredChoices ="Blah",RequiredChoicesEnabled = true,
                    RequiredDelimitedString = "blah",SizeName = "large"
                }
            };
            expected.Address1 = "new";
            expected.City = "new";
            expected.Name = "new";
            expected.Email = "new";
            expected.PhoneNumber = "new";
            expected.ZipCode = "12343";
            expected.SubTotal = 11M;
            expected.DeliveryCharge = 11M;
            expected.TaxTotal = 11M;
            expected.TransactionState = TransactionState.Delivered;
            expected.Date=DateTime.UtcNow;
            var result = await _pizzaRepo.UpdateTransaction(expected);
            result.Should().BeEquivalentTo(expected, options => options.Using<DateTime>(ctx => ctx.Subject.Should().BeCloseTo(ctx.Expectation)).WhenTypeIs<DateTime>());
        }
        private async Task c_should_update_transactionstate_when_command_valid()
        {
            var transactions = await _pizzaRepo.GetAllTransactions();
            var expected = transactions.FirstOrDefault();
            expected.TransactionState = TransactionState.Validated;
            var result = await _pizzaRepo.UpdateTransactionState(expected);
            result.Should().BeEquivalentTo(expected, options => options.Using<DateTime>(ctx => ctx.Subject.Should().BeCloseTo(ctx.Expectation)).WhenTypeIs<DateTime>());
        }
        private async Task d_should_remove_transaction_when_command_valid()
        {
            var transactions  = await _pizzaRepo.GetAllTransactions();
            var expected = transactions.FirstOrDefault();
            var removeResult = await _pizzaRepo.DeleteTransaction(expected.TransactionGuid);
            var result = await _pizzaRepo.GetAllTransactions();
            Assert.Equal(result, new List<MongoTransaction>());
            Assert.True(removeResult);
        }

        private async Task e_should_not_remove_transaction_when_command_invalid()
        {
            var removeResult = await _pizzaRepo.DeleteTransaction(Guid.NewGuid());
            Assert.False(removeResult);

        }
        private async Task f_should_return_transaction_by_state_when_command_valid()
        {
            var transaction = new MongoTransaction(){TransactionGuid = Guid.NewGuid(),TransactionState = TransactionState.Delivered};
            await _pizzaRepo.SaveNewTransaction(transaction);
            var transaction2 = new MongoTransaction() { TransactionGuid = Guid.NewGuid(), TransactionState = TransactionState.Authorized };
            await _pizzaRepo.SaveNewTransaction(transaction2);
            var transaction3 = new MongoTransaction() { TransactionGuid = Guid.NewGuid(), TransactionState = TransactionState.Validated };
            await _pizzaRepo.SaveNewTransaction(transaction3);
            var result = await _pizzaRepo.GetTransactionsByState(TransactionState.Delivered);
            result.FirstOrDefault().Should().BeEquivalentTo(transaction);

        }
    }
}
