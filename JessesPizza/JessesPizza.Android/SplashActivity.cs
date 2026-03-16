using System;

using Android.App;
using Android.Content.PM;
using Android.Runtime;
using Android.Views;
using Android.Widget;
using Android.OS;
using Android.Support.V7.App;
using Android.Util;
using System.Threading.Tasks;
using Android.Content;

namespace JessesPizza.Droid
{
    [Activity(Theme = "@style/MyTheme.Splash", MainLauncher = true, NoHistory = true)]
    public class SplashActivity : AppCompatActivity
    {
        static readonly string TAG = "X:" + typeof(SplashActivity).Name;

        public override void OnCreate(Bundle savedInstanceState, PersistableBundle persistentState)
        {
            base.OnCreate(savedInstanceState, persistentState);
            Log.Debug(TAG, "SplashActivity.OnCreate");
            InvokeMainActivity();

        }

        // Launches the startup task
        protected override void OnResume()
        {
            base.OnResume();
            InvokeMainActivity();

        }

        void InvokeMainActivity()
        {
            var mainActivityIntent = new Intent(Application.Context, typeof(MainActivity));
            StartActivity(mainActivityIntent);
        }
    }
}