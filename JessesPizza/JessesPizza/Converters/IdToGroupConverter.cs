using JessesPizza.Core.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using Xamarin.Forms;

namespace JessesPizza.Helpers
{
    public class IdToGroupConverter : IValueConverter
    {
        private List<GroupItem> GroupItems;
        public IdToGroupConverter()
        {
               
        }
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null)
                return "";

            string id = value as string;
            string[] array = id.Split('<');
                return array[1];

        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value;
        }
    }
}   
