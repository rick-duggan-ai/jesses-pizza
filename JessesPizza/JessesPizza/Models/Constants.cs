using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using Xamarin.Forms;
namespace JessesPizza.Models
{
    public static class Constants
    {
        public static string BaseAddress = "https://services.jessespizza.com:5000";
        //public static string BaseAddress = "http://192.168.181.196:8080";
        //public static string BaseAddress = "http://jessestest2-env.eba-hmhmppav.us-west-2.elasticbeanstalk.com:5000";
        public static string AccountApiUrl =string.Concat(BaseAddress,"/api/Mongo");
        public static string TransactionsApiUrl = string.Concat(BaseAddress, "/api/Mongo");
        public static string AuthApiUrl = string.Concat(BaseAddress, "/api/Auth");
        public static string MenuItemsApiUrl = string.Concat(BaseAddress, "/api/Mongo");
        public static string SettingsApiUrl = string.Concat(BaseAddress, "/api/Mongo");
        public static string SqlLiteDbFolder = Device.RuntimePlatform != Device.UWP? Path.Combine( Environment.GetFolderPath(Environment.SpecialFolder.Personal),"JessesPizza.db3") : Path.Combine(/*ApplicationData.Current.LocalFolder.Path,*/ "JessesPizza.db3");

    }



     
}
