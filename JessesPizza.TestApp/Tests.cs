using System;
using System.IO;
using System.Linq;
using NUnit.Framework;
using Xamarin.UITest;
using Xamarin.UITest.Queries;

namespace JessesPizza.TestApp
{
    [TestFixture(Platform.Android)]
    [TestFixture(Platform.iOS)]
    public class Tests
    {
        IApp app;
        Platform platform;

        public Tests(Platform platform)
        {
            this.platform = platform;
        }

        [SetUp]
        public void BeforeEachTest()
        {
            app = AppInitializer.StartApp(platform);
        }

        [Test]
        public void MainMenuItemsListDisplayed()
        {
            AppResult[] results = app.WaitForElement(c => c.Marked("MainMenuItemsListView"));
            app.Screenshot("Welcome screen.");

            Assert.IsTrue(results.Any());
        }

        [Test]
        public void MainMenuItemsListTapped()
        {
            app.Tap("MainMenuItemsListView");
            app.Query(x => x.Marked("MainMenuItemsListView").Descendant());
            AppResult[] results = app.WaitForElement(c => c.Marked("MenuItemsListView"));
            app.Repl();

            app.Tap("MenuItemsFrame");

            Assert.IsTrue(results.Any());
        }
    }
}
