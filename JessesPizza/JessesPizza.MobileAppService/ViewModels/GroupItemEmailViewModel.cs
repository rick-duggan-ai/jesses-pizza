using JessesPizza.Core.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace JessesPizza.MobileAppService.ViewModels
{
    public class GroupItemEmailViewModel
    {

        public int GroupListIndex { get; set; }
        public GroupItem GroupItem { get; set; }
        public Uri ImageUrl { get; set; }

        public bool IsRequired { get; set; }
        private bool _isItemSelected;
        public bool IsItemSelected
        {
            get { return this._isItemSelected; }
            set
            {
                if (_isItemSelected == value)
                    return;

                _isItemSelected = value;
            }
        }
        public string ItemName { get; set; }
        public string GroupName { get; set; }

        public bool SizeListFull { get; set; } = true;

        private string _sizeLabelText { get; set; }

        public string SizeLabelText
        {
            get { return _sizeLabelText; }
            set
            {
                if (_sizeLabelText != value)
                {
                    _sizeLabelText = value;
                }
            }
        }
        public bool SideListFull { get; set; } = true;
        private string _sideLabelText { get; set; }

        public string SideLabelText
        {
            get { return _sideLabelText; }
            set
            {
                if (_sideLabelText != value)
                {
                    _sideLabelText = value; 
                }
            }
        }

        public string ItemPrice {get;set;}
        public GroupItemEmailViewModel(GroupItem groupItem, bool isRequired)
        {
            GroupItem = groupItem;
            ItemName = GroupItem.Name;
            IsRequired = isRequired;
            ItemPrice = "";
            SizeListFull = false;
            SideListFull = false;
        }
        public GroupItemEmailViewModel(GroupItem groupItem, bool isRequired,string sizeName)
        {
            GroupItem = groupItem;
            ItemName = GroupItem.Name;
            IsRequired = isRequired;
            var size = GroupItem.Sizes.FirstOrDefault(x => x.Name == sizeName);
            if(size!= null)
            { 
            SizeLabelText = size.Name;
            ItemPrice = size.Price.ToString("$0.00");
            }
            else
            {
                SizeLabelText = "";
                ItemPrice = "";
            }
            SizeListFull = true;
            SideListFull = false;
        }
        public GroupItemEmailViewModel(GroupItem groupItem, bool isRequired, string sizeName,string sideName)
        {
            GroupItem = groupItem;
            ItemName = GroupItem.Name;
            IsRequired = isRequired;
            var size = GroupItem.Sizes.FirstOrDefault(x => x.Name == sizeName);
            var side = GroupItem.Sides.FirstOrDefault(x => x.Name == sideName);
            if (size !=null && side != null)
            {
                SizeLabelText = size.Name;
                SideLabelText = side.Name;
                var price = size.Price + side.Price;
                ItemPrice = price.ToString("$0.00");
            }
            else
            {
                SizeLabelText = "";
                SideLabelText = "";
                ItemPrice = "";
            }
            SizeListFull = true;
            SideListFull = true;
        }
        public override string ToString()
        {
            if (!SizeListFull && !SideListFull)
            {
                return $"{ItemName}";
            }
            else if(SizeListFull && !SideListFull)
            {
                return $"{ItemName}({SizeLabelText}) + {ItemPrice}";
            }
            else if (SizeListFull && SideListFull)
            {
                return $"{ItemName}({SizeLabelText},{SideLabelText}) + {ItemPrice}";

            }
            return base.ToString();
        }

    }
}
