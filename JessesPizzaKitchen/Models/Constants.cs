using System;
using System.IO;
using Xamarin.Forms;

namespace JessesPizzaKitchen.Models
{
    public class Constants
    {
        public static string SqlLiteDbFolder = Device.RuntimePlatform != Device.UWP ? Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Personal), "JessesPizza.db3") : Path.Combine(/*ApplicationData.Current.LocalFolder.Path,*/ "JessesPizza.db3");
        public static string BaseAddress = "https://services.jessespizza.com:5000";
        //public static string BaseAddress = "http://192.168.86.165:8080";
        public static string ChatAddress = $"https://services.jessespizza.com/chatHub";
        //public static string ChatAddress = $"http://192.168.86.165:8080/chatHub";
        public static string JessesUrl = BaseAddress + "/api/Mongo";
        public static string LoginAddress = "https://services.jessespizza.com:5001/login";
        //public static string LoginAddress = "http://192.168.86.165:8081/login";

    }
}
