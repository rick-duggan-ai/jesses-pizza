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
    public class ContactViewModel : BaseViewModel
    {
        public Command LoadItemsCommand { get; set; }
        public JessesPizzaSettings  Settings { get; set; }

        private string _hoursString;
        public string HoursString
        {
            get => _hoursString;
            set
            {
                _hoursString = value;
                OnPropertyChanged();
            }
        }
        public ContactViewModel()
        {
            Title = "Contact Us";
            LoadItemsCommand = new Command(async () => await ExecuteLoadItemsCommand());

        }
        public async Task ExecuteLoadItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                var info = await App.MenuManager.GetOrderInfoAsync();
                if (info != null)
                { 
                    Settings = info;
                    HoursString = "";
                    foreach (var hours in Settings.StoreHours)
                    {
                        DateTime opening =(DateTime) hours.OpeningTime;
                        DateTime closing =(DateTime)hours.ClosingTime;
                        HoursString = string.Concat(HoursString, $"{ConvertDateToString(hours.Day)}: {opening.ToString("h:mm tt")}-{closing.ToString("h:mm tt")}",Environment.NewLine);
                    }
                }
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
            }
            finally
            {
                IsBusy = false;
            }
        }
        private string ConvertDateToString(DayOfTheWeek day)
        {
            switch (day.ToString())
            {
                case "Monday":
                    return "Mon";
                case "Tuesday":
                    return "Tues";
                case "Wednesday":
                    return "Wed";
                case "Thursday":
                    return "Thurs";
                case "Friday":
                    return "Fri";
                case "Saturday":
                    return "Sat";
                case "Sunday":
                    return "Sun";
                default:
                    return "";
            }

        }
    }
}
