using JessesPizza.Core.Models;
using System.Collections.Generic;

namespace JessesPizza.WebApp.Models
{
    public class GroupForm
    {
        public GroupForm()
        {

        }
        public GroupForm(Group group)
        {
            this.Name = group.Name;
            this.ImageUrl = group.ImageUrl;
            this.GroupType = group.GroupType;
            this.Type = group.Type;
            this.IsRequired = group.IsRequired;
            this.Min = group.Min;
            this.Max = group.Max;
            this.Items = group.Items;
            GroupId = group.Id;
        }

        public string SizeId { get; set; }
        public string MenuItemId { get; set; }

        public string GroupId { get; set; }
        public string Id { get; set; }
        public string Name { get; set; }
        public GroupType Type { get; set; }
        public int GroupType { get; set; }
        public bool IsRequired { get; set; }
        public int Min { get; set; }
        public int Max { get; set; }
        public string ImageUrl { get; set; }
        public List<GroupItem> Items { get; set; }
    }
}
