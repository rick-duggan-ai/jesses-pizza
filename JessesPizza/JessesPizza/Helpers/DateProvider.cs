using System;
using System.Collections;
using System.Collections.Generic;
using Telerik.XamarinForms.Input.DataForm;

namespace JessesPizza.Helpers
{
    class DateProvider : PropertyDataSourceProvider
    {
        public override IList GetSourceForKey(object key)
        {
            if (key.ToString() == "Month")
            {
                return new List<int>() {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
            }
            if (key.ToString() == "Year")
            {
                var year = DateTime.Today.Year;
                var yearList = new List<int>();
                yearList.Add(year);
                for (int i = 1; i < 6; i++)
                {
                    yearList.Add(year+i);
                }
                return yearList;
            }

            return null;
        }
    }
}
