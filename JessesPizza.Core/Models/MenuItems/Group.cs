using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace JessesPizza.Core.Models
{
    public class Group
    {
        public Group()
        {

        }
        public Group(Group group)
        {
            this.Name = group.Name;
            this.ImageUrl = group.ImageUrl;
            this.GroupType = group.GroupType;
            this.Type = group.Type;
            this.IsRequired = group.IsRequired;
            this.Min = group.Min;
            this.Max = group.Max;
            this.Items = new List<GroupItem>();
        }
        public string Id { get; set; }
        [Required]
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
