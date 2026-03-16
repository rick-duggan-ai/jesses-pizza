using JessesPizzaKitchen.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Text;
using Xamarin.Forms;

namespace JessesPizzaKitchen.Converters
{
    public class BoolToButtonTextConverter : IValueConverter
    {
        public string DeliveryText { get; set; } = "UPDATE DELIVERY TIME";
        public string PickupText { get; set; } = "UPDATE PICKUP TIME";
        public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
        {
            if (value == null) return PickupText;
            var payment = value as PaymentParent;
            if (payment.NoContact || payment.IsDelivery)
                return DeliveryText;
            else
                return PickupText;
        }

        public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
        {
            return value;
        }
    }
}
