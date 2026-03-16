using System;
using System.Collections.Generic;
using System.Text;
using Telerik.XamarinForms.Common;
using Telerik.XamarinForms.Common.DataAnnotations;

namespace JessesPizza.ViewModels
{
    public class ConfirmPasswordChangeViewModel : NotifyPropertyChangedBase
    {
        [DisplayOptions(Header = "Verification Code")]
        [StringLengthValidator(6, 6, "Code must 6 digits long")]
        public string Code { get; set; }
    }
}
