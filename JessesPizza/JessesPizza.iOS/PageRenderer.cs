using System;
using JessesPizza.Helpers;
using JessesPizza.Styles;
using UIKit;
using Xamarin.Forms;
using Xamarin.Forms.Platform.iOS;
[assembly: ExportRenderer(typeof(ContentPage), typeof(JessesPizza.iOS.PageRenderer))]
namespace JessesPizza.iOS
{
    public class PageRenderer : Xamarin.Forms.Platform.iOS.PageRenderer
    {
        protected override void OnElementChanged(VisualElementChangedEventArgs e)
        {
            base.OnElementChanged(e);

            if (e.OldElement != null || Element == null)
            {
                return;
            }

            try
            {
                SetAppTheme();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"\t\t\tERROR: {ex.Message}");
            }
        }

        public override void TraitCollectionDidChange(UITraitCollection previousTraitCollection)
        {
            if (UIDevice.CurrentDevice.CheckSystemVersion(13, 0))
            {
                base.TraitCollectionDidChange(previousTraitCollection);
            if (this.TraitCollection.UserInterfaceStyle != previousTraitCollection.UserInterfaceStyle)
            {
                SetAppTheme();
            }
            }

        }

        void SetAppTheme()
        {
            if (UIDevice.CurrentDevice.CheckSystemVersion(13, 0))
            { 
                if (this.TraitCollection.UserInterfaceStyle == UIUserInterfaceStyle.Dark)
            {
                if (((App)App.Current).AppTheme == Theme.Dark)
                    return;

                App.Current.Resources = new DarkTheme();

                ((App)App.Current).AppTheme = Theme.Dark;
            }
            else
            {
                App.Current.Resources = new WhiteTheme();
                ((App)App.Current).AppTheme = Theme.Light;
            }
            }
            else
            {
                App.Current.Resources = new WhiteTheme();
                ((App)App.Current).AppTheme = Theme.Light;
            }
        }
    }
}