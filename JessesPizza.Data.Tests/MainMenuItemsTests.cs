using JessesPizza.Core;
using JessesPizza.Core.Helpers;
using JessesPizza.Core.Models;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Xunit;
using FluentAssertions;
using System.Linq;

namespace JessesPizza.Data.Tests
{
    [TestCaseOrderer("JessesPizza.Data.Tests.AlphabeticalOrderer", "JessesPizza.Data.Tests")]
    public class MainMenuItemsTests
    {
        static IPizzaRepo _pizzaRepo;
        public MainMenuItemsTests()
        {
            _pizzaRepo = new PizzaRepo(APIKeys.TestConnectionString);
        
        }
        [Fact]
        public async Task AllMainMenuItemsTests()
        {
            await a_should_add_MMI_when_command_valid();
            await b_should_update_MMI_when_command_valid();
            await c_should_remove_MMI_when_command_valid();
            await d_should_not_remove_MMI_when_command_invalidvalid();
        }
        private async Task a_should_add_MMI_when_command_valid()
        {
            await ResetMainMenuItems();
            var items = new List<JessesMenuItem>() { new JessesMenuItem() {Name = "Item 1",ImageUrl="blah",Description="description",Id = IdHelper.GetUniqueId().ToLower(),Sizes = new List<JessesItemSize>() } };
            var expected = new MainMenuItem() {Id=IdHelper.GetUniqueId().ToLower(),  ImageUrl= "blah", Name = "jessesItem" , MenuItems=items};
            await _pizzaRepo.AddMainMenuItem(expected);
            var result = await _pizzaRepo.GetAllMainMenuItems();
            result.Should().BeEquivalentTo(expected);
        }
        private async Task b_should_update_MMI_when_command_valid()
        {
            var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
            var expected = mainMenuItems.FirstOrDefault();
            var items = new List<JessesMenuItem>() { new JessesMenuItem() { Name = "Item 2", ImageUrl = "blah2", Description = "description2", Id = IdHelper.GetUniqueId().ToLower(), Sizes = new List<JessesItemSize>() { new JessesItemSize()} } };

            expected.MenuItems = items;
            expected.Name = "new";
            expected.ImageUrl = "new";
            var result = await _pizzaRepo.UpdateMainMenuItem(expected);
            result.Should().BeEquivalentTo(expected);
        }
        private async Task c_should_remove_MMI_when_command_valid()
        {
            var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
            var expected = mainMenuItems.FirstOrDefault();
            var removeResult = await _pizzaRepo.RemoveMainMenuItem(expected);
            var result = await _pizzaRepo.GetAllMainMenuItems();
            Assert.Equal(result,new List<MainMenuItem>());
            Assert.True(removeResult);
        }
        private async Task d_should_not_remove_MMI_when_command_invalidvalid()
        {
            var expected = new MainMenuItem() { Id = IdHelper.GetUniqueId() };
            var removeResult = await _pizzaRepo.RemoveMainMenuItem(expected);
            var result = await _pizzaRepo.GetAllMainMenuItems();
            Assert.False(removeResult);
        }

        private async Task ResetMainMenuItems()
        {
            var mainMenuItems = await _pizzaRepo.GetAllMainMenuItems();
            foreach (var mainMenuItem in mainMenuItems)
            {
                await _pizzaRepo.RemoveMainMenuItem(mainMenuItem);
            }
        }
    }
}
