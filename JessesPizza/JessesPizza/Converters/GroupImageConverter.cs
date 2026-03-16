using JessesPizza.Core.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using Xamarin.Forms;

namespace JessesPizza.Helpers
{
    public class GroupImageConverter : IValueConverter
    {
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null)
                return "";

            string  id = value as string;
            string[] array = id.Split('<');
            if (!string.IsNullOrEmpty(array[2]) && !string.IsNullOrWhiteSpace(array[2]))
            {
                var url = new Uri(array[2]);

                return url;
            }
            return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value;
        }
    }
}
