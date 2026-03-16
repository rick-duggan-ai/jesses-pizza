using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using JessesApi.ViewModels;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace JessesApi.Views
{
    public class CustomerEmailModel : PageModel
    {
        public MongoTransaction Transaction { get; set; }
        public List<Group> Groups { get; set; }

        public List<MainMenuItem> MainMenuItems { get; set; }
        public List<ShoppingCartItemParent> ShoppingCartItems { get; set; } = new List<ShoppingCartItemParent>();
        public string AddressLabel { get; set; }
        public string SpecialInstructions { get; set; }
        public bool NoContact { get; }

        public CustomerEmailModel(MongoTransactionV1_1 transaction, List<Group> groups, List<MainMenuItem> mainMenuItems, bool isDelivery)
        {
            if (transaction.NoContactDelivery)
                NoContact = true;
            Transaction = (MongoTransaction)transaction;
            Groups = groups;
            MainMenuItems = mainMenuItems;
            SpecialInstructions = transaction.SpecialInstructionsForOrder;
            foreach (var item in Transaction.Items)
            {
                List<GroupItemEmailViewModel> selectedRequiredItems = new List<GroupItemEmailViewModel>();
                List<GroupItemEmailViewModel> selectedOptionalItems = new List<GroupItemEmailViewModel>();
                JessesMenuItem jessesItem = new JessesMenuItem();
                foreach (var mainmenuItem in MainMenuItems)
                {
                    jessesItem = mainmenuItem.MenuItems.FirstOrDefault(mi => mi.Id == item.MenuItemId);
                    if (jessesItem != null)
                        break;
                }
                var selectedSize = jessesItem.Sizes.FirstOrDefault(x => x.Id == item.SelectedSizeId);
                if (!string.IsNullOrWhiteSpace(item.RequiredDelimitedString))
                {

                    string[] words = item.RequiredDelimitedString.Split(',');
                    foreach (var word in words)
                    {
                        var trim = word.TrimStart();
                        foreach (var groupId in selectedSize.GroupIds)
                        {
                            var group = Groups.Where(x => x.Id == groupId).FirstOrDefault();
                            string[] parameters = trim.Split('/');
                            var requiredGroupItem = group.Items.FirstOrDefault(x => x.Id == parameters[0]);
                            if (requiredGroupItem == null)
                                continue;
                            GroupItemEmailViewModel vm = null;
                            switch (parameters.Count())
                            {
                                case 1:
                                    vm = new GroupItemEmailViewModel(requiredGroupItem, true);
                                    break;
                                case 2:
                                    vm = new GroupItemEmailViewModel(requiredGroupItem, true, parameters[1]) { };
                                    break;
                                case 3:
                                    vm = new GroupItemEmailViewModel(requiredGroupItem, true, parameters[1], parameters[2]) { };
                                    break;
                            }
                            selectedRequiredItems.Add(vm);
                        }
                    }
                }

                if (!string.IsNullOrWhiteSpace(item.OptionalDelimitedString))
                {
                    string[] words = item.OptionalDelimitedString.Split(',');
                    foreach (var word in words)
                    {
                        var trim = word.TrimStart();
                        foreach (var groupId in selectedSize.GroupIds)
                        {
                            var group = Groups.Where(x => x.Id == groupId).FirstOrDefault();
                            string[] parameters = trim.Split('/');
                            var optionalGroupItem = group.Items.FirstOrDefault(x => x.Id == parameters[0]);
                            if (optionalGroupItem == null)
                            {
                                continue;
                            }
                            GroupItemEmailViewModel vm = null;
                            switch (parameters.Count())
                            {
                                case 1:
                                    vm = new GroupItemEmailViewModel(optionalGroupItem, false);
                                    break;
                                case 2:
                                    vm = new GroupItemEmailViewModel(optionalGroupItem, false, parameters[1]) { };
                                    break;
                                case 3:
                                    vm = new GroupItemEmailViewModel(optionalGroupItem, false, parameters[1], parameters[2]) { };
                                    break;
                            }
                            if (vm != null)
                                selectedOptionalItems.Add(vm);
                        }
                    }
                }

                var newItem = new ShoppingCartItemParent(item, selectedRequiredItems, selectedOptionalItems) { };
                ShoppingCartItems.Add(newItem);
                if (isDelivery)
                {
                    AddressLabel = "Delivery Address";
                }
                else
                    AddressLabel = "Billing Address";
            }
        }
        public CustomerEmailModel(MongoTransaction transaction, List<Group> groups, List<MainMenuItem> mainMenuItems, bool isDelivery)
        {

            Transaction = transaction;
            Groups = groups;
            MainMenuItems = mainMenuItems;
            foreach (var item in Transaction.Items)
            {
                List<GroupItemEmailViewModel> selectedRequiredItems = new List<GroupItemEmailViewModel>();
                List<GroupItemEmailViewModel> selectedOptionalItems = new List<GroupItemEmailViewModel>();
                JessesMenuItem jessesItem = new JessesMenuItem();
                foreach (var mainmenuItem in MainMenuItems)
                {
                    jessesItem = mainmenuItem.MenuItems.FirstOrDefault(mi => mi.Id == item.MenuItemId);
                    if (jessesItem != null)
                        break ;
                }
                var selectedSize = jessesItem.Sizes.FirstOrDefault(x => x.Id == item.SelectedSizeId);
                if (!string.IsNullOrWhiteSpace(item.RequiredDelimitedString))
                {

                    string[] words = item.RequiredDelimitedString.Split(',');
                    foreach (var word in words)
                    {
                        var trim = word.TrimStart();
                        foreach (var groupId in selectedSize.GroupIds)
                        {
                            var group = Groups.Where(x => x.Id == groupId).FirstOrDefault();
                            string[] parameters = trim.Split('/');
                            var requiredGroupItem = group.Items.FirstOrDefault(x => x.Id == parameters[0]);
                            if (requiredGroupItem == null)
                                continue;
                            GroupItemEmailViewModel vm = null;
                            switch (parameters.Count())
                            {
                                case 1:
                                    vm = new GroupItemEmailViewModel(requiredGroupItem, true);
                                    break;
                                case 2:
                                    vm = new GroupItemEmailViewModel(requiredGroupItem, true, parameters[1]) { };
                                    break;
                                case 3:
                                    vm = new GroupItemEmailViewModel(requiredGroupItem, true, parameters[1], parameters[2]) { };
                                    break;
                            }
                            selectedRequiredItems.Add(vm);
                        }
                    }
                }

                if (!string.IsNullOrWhiteSpace(item.OptionalDelimitedString))
                {
                    string[] words = item.OptionalDelimitedString.Split(',');
                    foreach (var word in words)
                    {
                        var trim = word.TrimStart();
                        foreach (var groupId in selectedSize.GroupIds)
                        {
                            var group = Groups.Where(x => x.Id == groupId).FirstOrDefault();
                            string[] parameters = trim.Split('/');
                            var optionalGroupItem = group.Items.FirstOrDefault(x => x.Id == parameters[0]);
                            if (optionalGroupItem == null)
                            {
                                continue;
                            }
                            GroupItemEmailViewModel vm = null;
                            switch (parameters.Count())
                            {
                                case 1:
                                    vm = new GroupItemEmailViewModel(optionalGroupItem, false);
                                    break;
                                case 2:
                                    vm = new GroupItemEmailViewModel(optionalGroupItem, false, parameters[1]) { };
                                    break;
                                case 3:
                                    vm = new GroupItemEmailViewModel(optionalGroupItem, false, parameters[1], parameters[2]) { };
                                    break;
                            }
                            if (vm != null)
                                selectedOptionalItems.Add(vm);
                        }
                    }
                }

                var newItem = new ShoppingCartItemParent(item, selectedRequiredItems, selectedOptionalItems) { };
                ShoppingCartItems.Add(newItem);
                if (isDelivery)
                {
                    AddressLabel = "Delivery Address";
                }
                else
                    AddressLabel = "Billing Address";
            }
        }
        public void OnGet()
        {


        }
    }
}
