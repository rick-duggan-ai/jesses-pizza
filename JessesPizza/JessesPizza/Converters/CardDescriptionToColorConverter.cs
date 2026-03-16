using System;
using System.Globalization;
using Xamarin.Forms;

namespace JessesPizza.Converters
{
    public class CardDescriptionToColorConverter : IValueConverter
    {
        public Color Visa { get; set; }
        public Color Amex { get; set; }
        public Color MasterCard { get; set; }
        public Color Discover { get; set; }
        public Color NotRecognized { get; set; }

        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null) return NotRecognized;
            var description = value.ToString().Trim();

            switch (description)
            {
                case "VISA":
                    return Visa;
                case "AMEX":
                    return Amex;
                case "MC":
                    return MasterCard;
                case "DISC":
                    return Discover;
                default:
                    return NotRecognized;

            }
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value;
        }
    }
}
