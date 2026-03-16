using Acr.UserDialogs;
using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Helpers
{
    public class PopupHelper
    {
        public static void CreatePopup (string title, string message)
        {
            var aConfi = new AlertConfig();
            aConfi.SetMessage(message);
            aConfi.SetTitle(title);
            aConfi.SetOkText("Ok");
            UserDialogs.Instance.Alert(aConfi);
        }
        public static void CreateErrorPopup(string message)
        {
            var aConfi = new AlertConfig();
            aConfi.SetMessage(message);
            aConfi.SetTitle("Uh-oh!");
            aConfi.SetOkText("Ok");
            UserDialogs.Instance.Alert(aConfi);
        }
    }
}
