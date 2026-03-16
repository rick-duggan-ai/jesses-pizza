using System;
using Xamarin.UITest;
using Xamarin.UITest.Queries;

namespace JessesPizza.TestApp
{
    public class AppInitializer
    {
        public static IApp StartApp(Platform platform)
        {
            if (platform == Platform.Android)
            {
                return ConfigureApp.Android.InstalledApp("com.codexposed.JessesPizza").StartApp();
            }

            return ConfigureApp.iOS.StartApp();
        }
    }
}