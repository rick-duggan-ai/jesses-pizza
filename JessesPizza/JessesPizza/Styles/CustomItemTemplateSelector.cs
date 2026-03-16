using JessesPizza.ViewModels;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Telerik.XamarinForms.DataControls.ListView;
using Xamarin.Forms;

namespace JessesPizza.Styles
{
    public class CustomItemTemplateSelector : DataTemplateSelector
    {
        //Selected but no sizes or sides
        public DataTemplate NoSizeOrSideTemplate { get; set; }
        //Selected but no SIDES
        public DataTemplate SizeOnlyTemplate { get; set; }
        //Selected Item has sizes and sides
        public DataTemplate SizeAndSideTemplate { get; set; }
        public DataTemplate NotSelectedTemplate { get; set; }
        protected override DataTemplate OnSelectTemplate(object item, BindableObject container)
        {
            var groupItem = item as GroupItemViewModel;
            //Task.Delay(100).Wait();
            if (groupItem.IsItemSelected)
            {
                if (!groupItem.MaxReached)
                {
                    if (groupItem.SideListFull)
                        return this.SizeAndSideTemplate;
                    else if (groupItem.SizeListFull)
                        return this.SizeOnlyTemplate;
                    else
                        return this.NoSizeOrSideTemplate;
                }
                else
                {
                    (item as GroupItemViewModel).IsItemSelected = false;
                    return this.NotSelectedTemplate;
                }
            }
            return this.NotSelectedTemplate;
        }
    }
}
