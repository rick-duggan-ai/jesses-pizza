using JessesPizza.Core.Models;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;

namespace JessesPizza.ViewModels
{

    public class SizeSelectionViewModel :BaseViewModel
    {
        public ObservableCollection<SizeViewModel> SizeList = new ObservableCollection<SizeViewModel>();
        public JessesMenuItem MenuItem;
        public SizeViewModel defaultSize = null;

        public SizeSelectionViewModel(JessesMenuItem menuItem)
        {
            MenuItem = menuItem;
            Title = $"Sizes for {menuItem.Name}";
            foreach (var size in MenuItem.Sizes)
            {
                var vm = new SizeViewModel(size);
                if (size.IsDefault)
                    defaultSize = vm;
                SizeList.Add(vm);
            }
            if (defaultSize != null)
                defaultSize.IsSelected = true;
            else
            {
                defaultSize = SizeList.FirstOrDefault();
                defaultSize.IsSelected = true;
            }
        }
    }
}
