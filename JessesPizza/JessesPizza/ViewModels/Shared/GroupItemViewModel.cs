using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Input;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Models;
using JessesPizza.Services;
using SQLite;
using Xamarin.Forms;

namespace JessesPizza.ViewModels
{
    public class GroupItemViewModel : BaseViewModel
    {

        public int GroupListIndex { get; set; }
        public Command LoadItemsCommand { get; set; }
        public GroupItem GroupItem { get; set; }
        public Uri ImageUrl { get; set; }
        public string GroupImageUrlString { get; set; }

        public bool MaxReached { get; set; }
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
                OnPropertyChanged();
            }
        }
        public string ItemName { get; set; }
        public string GroupName { get; set; }

        public bool SizeListFull { get; set; } = true;

        public bool SizeIncreaseEnable { get; set; } = true;
        public bool SizeDecreaseEnable { get; set; } = true;

        public int SizeStepperMax { get; set; }
        private int _sizeIndex { get; set; }
        public int SizeIndex
        {
            get { return _sizeIndex; }
            set
            {
                if (_sizeIndex != value)
                {
                    _sizeIndex = value;
                    OnPropertyChanged("SizeIndex");
                    ItemPrice = "";
                }
            }
        }


        private string _sizeLabelText { get; set; }

        public string SizeLabelText { get { return _sizeLabelText; } set { if (_sizeLabelText!=value){
                    _sizeLabelText = value; OnPropertyChanged("SizeLabelText");
            } }
        }
        public bool SideListFull { get; set; } = true;
        public bool SideIncreaseEnable { get; set; } = true;
        public bool SideDecreaseEnable { get; set; } = true;

        public int SideStepperMax { get; set; }
        private int _sideIndex { get; set; }
        public int SideIndex
        {
            get { return _sideIndex; }
            set
            {
                if (_sideIndex != value)
                {
                    _sideIndex = value; OnPropertyChanged("SideIndex");
                    ItemPrice = "";

                }
            }
        }

        private string _sideLabelText { get; set; }

        public string SideLabelText
        {
            get { return _sideLabelText; }
            set
            {
                if (_sideLabelText != value)
                {
                    _sideLabelText = value; OnPropertyChanged("SideLabelText");
                }
            }
        }

        private string _itemprice { get; set; }
        public string ItemPrice
        {
            get { return _itemprice; }
            set
            {
                if (SizeListFull && SideListFull)
                {
                    var selectedSide = GroupItem.Sides[SideIndex];
                    var selectedSize = GroupItem.Sizes[SizeIndex];
                    var total = selectedSide.Price + selectedSize.Price;
                    if (total == 0M)
                        _itemprice = ItemName;
                    else
                        _itemprice = $"{ItemName} +{total.ToString("C")}";
                }
                else if (SizeListFull)
                {
                    var selectedSize = GroupItem.Sizes[SizeIndex];
                    var total =  selectedSize.Price;
                    if (total == 0M)
                        _itemprice = ItemName;
                    else
                        _itemprice = $"{ItemName} +{total.ToString("C")}";

                }
                else if (SizeListFull)
                {
                    var selectedSide = GroupItem.Sides[SideIndex];
                    var total = selectedSide.Price;
                    if (total == 0M)
                        _itemprice = ItemName;
                    else
                        _itemprice = $"{ItemName} +{total.ToString("C")}";

                }
                else
                    _itemprice = "";
                OnPropertyChanged("ItemPrice");

            }
        }
        public ICommand DecreaseSide { private set; get; }

        public ICommand IncreaseSide { private set; get; }
        public ICommand DecreaseSize { private set; get; }

        public ICommand IncreaseSize { private set; get; }
        public GroupItemViewModel(GroupItem groupItem,bool isRequired)
        {
            GroupItem = groupItem;
            ItemName = GroupItem.Name;
            IsRequired = isRequired;
            if (!string.IsNullOrEmpty(groupItem.ImageUrl) && !string.IsNullOrWhiteSpace(groupItem.ImageUrl))
                ImageUrl = new Uri(GroupItem.ImageUrl);
            if (GroupItem.Sizes != null)
            {
                if (GroupItem.Sizes.Count != 0)
                {
                    SizeStepperMax = GroupItem.Sizes.Count;
                    //Set Default Size
                    var defaultSize = GroupItem.Sizes.FirstOrDefault(x => x.Default == true);
                    if (defaultSize == null)
                        defaultSize = GroupItem.Sizes[0];
                    else
                        SizeIndex = GroupItem.Sizes.IndexOf(defaultSize);
                    IncreaseSize = new Command(() => SizeStepUp());
                    DecreaseSize = new Command(() => SizeStepDown());
                    SizeLabelText = defaultSize.Name;
                }
                else
                    SizeListFull = false;
            }
            else
                SizeListFull = false;
            //Set Default Side
            if (GroupItem.Sides != null)
            {
                if (GroupItem.Sides.Count != 0)
                {
                    SideStepperMax = GroupItem.Sides.Count;
                    var defaultSide = GroupItem.Sides.FirstOrDefault(x => x.IsDefault == true);
                    if (defaultSide == null)
                        defaultSide = GroupItem.Sides[0];
                    else
                        SideIndex = GroupItem.Sides.IndexOf(defaultSide);
                    SideLabelText = defaultSide.Name;
                    IncreaseSide = new Command(() =>  SideStepUp());
                    DecreaseSide = new Command(() =>  SideStepDown());
                }
                else
                    SideListFull = false; // make list invisible if list is empty
            }
            else
                SideListFull = false;
            ItemPrice = "";
        }
        void SideStepUp()
        {
            if (SideIndex >= SideStepperMax - 1)
                return;
            SideIndex++;
            var selectedSide = GroupItem.Sides[SideIndex];
            SideLabelText = selectedSide.Name;

        }
        void SideStepDown()
        {
            if (SideIndex <= 0)
                return;
            SideIndex--;
            var selectedSide = GroupItem.Sides[SideIndex];
            SideLabelText = selectedSide.Name;

        }
        void SizeStepUp()
        {
            if (SizeIndex >= SizeStepperMax - 1)
                return;
            SizeIndex++;
            var selectedSize = GroupItem.Sizes[SizeIndex];
            SizeLabelText = selectedSize.Name;

        }
        void SizeStepDown()
        {
            if (SizeIndex <= 0)
                return;
            SizeIndex--;
            var selectedSize = GroupItem.Sizes[SizeIndex];
            SizeLabelText = selectedSize.Name;
        }

    }
}
