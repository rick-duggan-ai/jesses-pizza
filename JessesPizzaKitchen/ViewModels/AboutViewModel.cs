using System;
using System.Windows.Input;
using JessesPizzaAdmin.ViewModels;
using Xamarin.Forms;

namespace JessesPizzaKitchen.ViewModels
{
    public class AboutViewModel : BaseViewModel
    {
        public AboutViewModel()
        {
            Title = "About";

            OpenWebCommand = new Command(() => Device.OpenUri(new Uri("https://xamarin.com/platform")));
        }

        public ICommand OpenWebCommand { get; }
    }
}