using JessesPizza.ViewModels;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using Telerik.XamarinForms.DataControls.ListView;
using Xamarin.Forms;

namespace JessesPizza.Styles
{
    public class SizeTemplateSelector : DataTemplateSelector
    {
        public DataTemplate SelectedTemplate { get; set; }
        public DataTemplate NotSelectedTemplate { get; set; }
        protected override DataTemplate OnSelectTemplate(object item, BindableObject container)
        {
            var size = item as SizeViewModel;
            //Task.Delay(100).Wait();
            if (size.IsSelected)
            {
                
               return this.SelectedTemplate;
            }
            return this.NotSelectedTemplate;
        }
    }
}
