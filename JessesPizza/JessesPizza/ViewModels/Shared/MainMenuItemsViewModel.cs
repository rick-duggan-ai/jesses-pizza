using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Text;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Models;
using Xamarin.Forms;
using System.Linq;
namespace JessesPizza.ViewModels
{
    class MainMenuItemsViewModel : BaseViewModel
    {
        public ObservableCollection<MainMenuItemViewModel> MainItems { get; set; }
        public Command LoadItemsCommand { get; set; }

        public MainMenuItemsViewModel()
        {
            Title = "Main Menu";
            MainItems = new ObservableCollection<MainMenuItemViewModel>();
            LoadItemsCommand = new Command(async () => await ExecuteLoadItemsCommand());

        }

        async Task ExecuteLoadItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                //await Task.Delay(1000);
                Device.BeginInvokeOnMainThread(async () =>
                {
                    MainItems.Clear();
                    var items = await App.MenuManager.GetMainMenuItemsAsync();

                    if (items != null)
                        foreach (var item in items)
                        {
                            MainItems.Add(new MainMenuItemViewModel(item));
                        }
                    MainItems = new ObservableCollection<MainMenuItemViewModel>(MainItems.OrderBy(x => x.Ordinal));
                });
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
            }
            finally
            {
                IsBusy = false;
            }
        }
    }
}
