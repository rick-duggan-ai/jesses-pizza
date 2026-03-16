using System;
using System.Globalization;
using Xamarin.Forms;
namespace JessesPizza.Converters
{
    public class CardDescriptionToImageConverter : IValueConverter
    {
        public ImageSource Visa { get; set; }
        public ImageSource Amex { get; set; }
        public ImageSource MasterCard { get; set; }
        public ImageSource Discover { get; set; }
        public ImageSource NotRecognized { get; set; }

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