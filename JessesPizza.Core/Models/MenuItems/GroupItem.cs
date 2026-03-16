using System.Collections.Generic;

namespace JessesPizza.Core.Models
{
    public class GroupItem
    {
        public GroupItem()
        {

        }
        public GroupItem(GroupItem item)
        {
            this.Name = item.Name;
            this.ImageUrl = item.ImageUrl;
            this.Sizes = item.Sizes;
            this.Sides = item.Sides;
        }
        public string Id { get; set; }
        public string GroupId { get; set; }
        public string Name { get; set; }
        public string ImageUrl { get; set; }

        public List<ItemSize> Sizes { get; set; }
        public List<ItemSide> Sides { get; set; }
    }

}
