using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using Android.App;
using Android.Content;
using Android.OS;
using Android.Runtime;
using Android.Support.V7.Widget;
using Android.Text;
using Android.Text.Method;
using Android.Views;
using Android.Widget;
using Com.Telerik.Widget.Dataform.Engine;
using Com.Telerik.Widget.Dataform.Visualization;
using Com.Telerik.Widget.Dataform.Visualization.Core;
using JessesPizza.Droid;
using Telerik.XamarinForms.InputRenderer.Android;
using Xamarin.Forms;

namespace JessesPizza.Droid
{

    public class CustomDataFormRenderer : DataFormRenderer
    {
        public CustomDataFormRenderer(Context context) : base(context)
        {
        }

        protected override void UpdateEditor(EntityPropertyEditor editor, Telerik.XamarinForms.Input.DataForm.IEntityProperty property)
        {
            base.UpdateEditor(editor, property);

            if (property.PropertyName == "Password" || property.PropertyName == "ConfirmPassword")
            {
                var editText = editor.EditorView.JavaCast<AppCompatEditText>();
                editText.InputType = InputTypes.TextFlagNoSuggestions;
                editText.TransformationMethod = new PasswordTransformationMethod();
            }
        }
    }
}