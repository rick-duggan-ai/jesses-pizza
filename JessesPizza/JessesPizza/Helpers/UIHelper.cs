using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Forms;

namespace JessesPizza.Helpers
{
    public class UIHelper
    {
        public static void AddChild(Grid grid, View view, int row, int column, int rowspan, int columnspan)
        {
            if (row < 0)
                throw new ArgumentOutOfRangeException("row");
            if (column < 0)
                throw new ArgumentOutOfRangeException("column");
            if (rowspan <= 0)
                throw new ArgumentOutOfRangeException("rowspan");
            if (columnspan <= 0)
                throw new ArgumentOutOfRangeException("columnspan");
            if (view == null)
                throw new ArgumentNullException("view");

            Grid.SetRow((BindableObject)view, row);
            Grid.SetRowSpan((BindableObject)view, rowspan);
            Grid.SetColumn((BindableObject)view, column);
            Grid.SetColumnSpan((BindableObject)view, columnspan);

            grid.Children.Add(view);
        }
    }
}
