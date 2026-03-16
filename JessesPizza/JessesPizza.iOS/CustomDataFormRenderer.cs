using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Foundation;
using JessesPizza.iOS;
using Telerik.XamarinForms.InputRenderer.iOS;
using TelerikUI;
using UIKit;
using Xamarin.Forms;

namespace JessesPizza.iOS
{
    public class CustomDataFormRenderer : DataFormRenderer
    {
        protected override Type GetCustomEditorType(string propertyName, Type propertyType)
        {
            if (propertyName == "Email")
            {
                return typeof(TKDataFormEmailEditor);
            }

            if (propertyName == "Password" || propertyName == "ConfirmPassword")
            {
                return typeof(TKDataFormPasswordEditor);
            }

            return base.GetCustomEditorType(propertyName, propertyType);
        }
    }
}