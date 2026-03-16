using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
	[XamlCompilation(XamlCompilationOptions.Compile)]
	public partial class OrderFailedPage : ContentPage
	{
		public OrderFailedPage ()
		{
			InitializeComponent ();
		}
		protected override void OnDisappearing()
		{
			Device.BeginInvokeOnMainThread(async () => await Navigation.PopToRootAsync());
		}
	}
}