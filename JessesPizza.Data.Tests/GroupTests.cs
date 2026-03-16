using JessesPizza.Core;
using JessesPizza.Core.Helpers;
using JessesPizza.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Xunit;
using FluentAssertions;
namespace JessesPizza.Data.Tests
{
    [TestCaseOrderer("JessesPizza.Data.Tests.AlphabeticalOrderer", "JessesPizza.Data.Tests")]
    public class GroupTests
    {
        static IPizzaRepo _pizzaRepo;
        public GroupTests()
        {
            _pizzaRepo = new PizzaRepo(APIKeys.TestConnectionString);

        }

        [Fact]
        public async Task AllGroupTests()
        {
            await a_should_add_groups_when_command_valid();
            await b_should_update_group_when_command_valid();
            await c_should_remove_group_when_command_valid();
            await d_should_get_group_when_command_valid();
        }

        private async Task ResetGroups()
        {
            var groups = await _pizzaRepo.GetAllGroups();
            foreach (var group in groups)
            {
                await _pizzaRepo.RemoveGroup(group);

            }
        }

        private async Task a_should_add_groups_when_command_valid()
        {
            await ResetGroups();
            var expected = new Group() { GroupType = 1, Id = IdHelper.GetUniqueId(), ImageUrl = "blah", IsRequired = true, Max = 1, Min = 0, Name = "Group1", Type = GroupType.MinMax};
            var items = new List<GroupItem>()
            {
                new GroupItem(){GroupId = expected.Id,ImageUrl = "Blah",Name = "GroupItem1",Id = IdHelper.GetUniqueId()},
                new GroupItem(){GroupId = expected.Id,ImageUrl = "Blah2",Name = "GroupItem2",Id = IdHelper.GetUniqueId()},
                new GroupItem(){GroupId = expected.Id,ImageUrl = "Blah3",Name = "GroupItem3",Id = IdHelper.GetUniqueId()}
            };
            expected.Items = items;
            await _pizzaRepo.AddGroup(expected);
            var result = await _pizzaRepo.GetGroup(expected.Id);
            result.Should().BeEquivalentTo(expected);
        }
        private async Task b_should_update_group_when_command_valid()
        {
            var groups = await _pizzaRepo.GetAllGroups();
            var expected = groups.FirstOrDefault();
            expected.ImageUrl = "new";
            expected.Name = "new";
            expected.IsRequired = false;
            expected.Items = null;
            expected.GroupType = 1;
            expected.Type = GroupType.Single;
            expected.Min= 15;
            expected.Max = 20;
            Group result = await _pizzaRepo.UpdateGroup(expected);
            result.Should().BeEquivalentTo(expected);
        }
        private async Task c_should_remove_group_when_command_valid()
        {
            var groups = await _pizzaRepo.GetAllGroups();
            var group = groups.FirstOrDefault();
            await _pizzaRepo.RemoveGroup(group);
            var result = await _pizzaRepo.GetAllGroups();
            Assert.Equal(result, new List<Group>());
        }
        private async Task d_should_get_group_when_command_valid()
        {
            var id = IdHelper.GetUniqueId();
            var expected = new Group(){Id = id};
            var group2 = new Group() { Id = IdHelper.GetUniqueId() };
            await _pizzaRepo.AddGroup(expected);
            await _pizzaRepo.AddGroup(group2);
            var result = await _pizzaRepo.GetGroup(id);
            result.Should().BeEquivalentTo(expected);
        }

    }
}
