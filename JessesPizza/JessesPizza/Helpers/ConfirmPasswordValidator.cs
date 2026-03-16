using JessesPizza.ViewModels;
using System;
using System.Collections.Generic;
using System.Text;
using Telerik.XamarinForms.Common.DataAnnotations;

namespace JessesPizza.Helpers
{
    public class ConfirmPasswordValidatorAttribute : ValidatorBaseAttribute
    {
        public ConfirmPasswordValidatorAttribute()
        {
            this.NegativeFeedback = "Occupation must be specified";
        }

        protected override bool ValidateCore(object vm )
        {
            var passwords = (SignUpViewModel)vm;
            return true;

        }
    }
}
