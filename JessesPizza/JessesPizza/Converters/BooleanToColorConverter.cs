using System;
using System.Globalization;
using Xamarin.Forms;

namespace JessesPizza.Converters
{
    public class BooleanToColorConverter : IValueConverter
    {
        public Color Selected { get; set; } = Color.Orange;
        public Color NotSelected { get; set; } = Color.White;
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null) return NotSelected;
            var selected = (bool)value;
            if (selected)
                return Selected;
            else
                return NotSelected;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value;
        }
    }
}
