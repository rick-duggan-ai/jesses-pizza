using JessesPizza.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace JessesApi.ViewModels
{
    public class ShoppingCartItemParent
    {

        public List<GroupItemEmailViewModel> RequiredGroups { get; set; }
        public List<GroupItemEmailViewModel> OptionalGroups { get; set; }
        public string GroupText { get; set; }

        public string RequiredText { get; set; }
        public string OptionalText
        {
            get; set;
        }
        public ShoppingCartItem Item { get; set; }
        public ShoppingCartItemParent(ShoppingCartItem item, List<GroupItemEmailViewModel>requiredGroups, List<GroupItemEmailViewModel> optionalGroups)
        {
            Item = item;
            RequiredGroups = requiredGroups;
            OptionalGroups = optionalGroups;
            var i = 0;
            foreach(var groupItem in requiredGroups)
                            {
                if (i == 0)
                    RequiredText = string.Concat(RequiredText, "-", groupItem.ToString());
                else if(i == RequiredGroups.Count() -1 )
                    RequiredText = string.Concat(RequiredText, "\n\r-", groupItem.ToString());
                else
                    RequiredText = string.Concat(RequiredText, "\n\r-", groupItem.ToString());

                i++;
            }
            i = 0;
            foreach (var groupItem in OptionalGroups)
            {
                if (i == 0)
                {
                    if (string.IsNullOrEmpty(RequiredText))
                        OptionalText = string.Concat(OptionalText, "-", groupItem.ToString());
                    else
                        OptionalText = string.Concat(OptionalText, "\n\r-", groupItem.ToString());
                }
                else
                    OptionalText = string.Concat(OptionalText, "\n\r-", groupItem.ToString());
                i++;
            }
        }
    }
}
