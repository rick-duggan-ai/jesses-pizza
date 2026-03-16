using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Models;
using JessesPizza.Services;
using SQLite;
using Xamarin.Forms;

namespace JessesPizza.ViewModels
{
    public class GroupViewModel : BaseViewModel
    {
        public Command LoadItemsCommand { get; set; }
        public Group Group { get; set; }

        private string _displayName;
        public string DisplayName
        {
            get
            {
                if (Group.IsRequired)
                    return Group.Name;
                else
                    return string.Concat(Group.Name, "(Optional)");
            }
        }

        public Uri ImageUrl { get; set; }
        public ObservableCollection<GroupItemViewModel> Items { get; set; }
        public ObservableCollection<GroupItemViewModel> SelectedItems { get; set; }

        public bool HeaderTapped { get; set; } = false;
        private int _stepperValue { get; set; }
        public int StepperValue
        {
            get{
                return _stepperValue;
            }
            set {
                _stepperValue = value;
                OnPropertyChanged();
            }
        }
        public GroupViewModel(Group group)
        {
            Group = group;
            if (!string.IsNullOrEmpty(group.ImageUrl) && !string.IsNullOrWhiteSpace(group.ImageUrl))
                ImageUrl = new Uri(group.ImageUrl);
            Items = new ObservableCollection<GroupItemViewModel>();
            if(Group.Items != null)
            {
                if(Group.Items.Count != 0)
                    foreach (var item in Group.Items)
                    {
                        var newItem = new GroupItemViewModel(item,group.IsRequired);
                        Items.Add(newItem);
                    }
            }

        }

    }
}
