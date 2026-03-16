using System;
using System.Windows.Input;

using Xamarin.Forms;
using Xamarin.Essentials;
using System.Threading.Tasks;
using System.Diagnostics;
using JessesPizza.Core.Models;
using System.Collections.ObjectModel;
using JessesPizza.Core.Models.Identity;
using Telerik.Windows.Documents.Fixed.Model.Editing.Lists;
using System.Collections.Generic;
using JessesPizza.Core.Models.Transactions;

namespace JessesPizza.ViewModels
{
    public class CreditCardListViewModel : BaseViewModel
    {
        public ObservableCollection<CreditCardViewModel> CreditCards { get; set; }
        public CreditCardListViewModel(List<CreditCard> creditCards)
        {
            List<CreditCardViewModel> ViewModels = new List<CreditCardViewModel>();
            foreach (var card in creditCards)
            {
                var vm = new CreditCardViewModel(card);
                ViewModels.Add(vm);
            }
            CreditCards = new ObservableCollection<CreditCardViewModel>(ViewModels);
            Title = "Choose a payment method";
        }
        public CreditCardListViewModel()
        {
            List<CreditCardViewModel> ViewModels = new List<CreditCardViewModel>();
            CreditCards = new ObservableCollection<CreditCardViewModel>(ViewModels);
            Title = "Manage Credit Cards";
        }
        private string _aboutString;
        public string AboutString
        {
            get => _aboutString;
            set
            {
                _aboutString = value;
                OnPropertyChanged();
            }
        }
        public async Task ExecuteLoadItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                // get menu item ids
                List<CreditCardViewModel> ViewModels = new List<CreditCardViewModel>();
                var response = await App.MenuManager.GetCreditCards(new GetCreditCardsRequest());
                foreach (CreditCard cc in response.CreditCards)
                {
                    var vm = new CreditCardViewModel(cc);
                    ViewModels.Add(vm);
                }
                CreditCards = new ObservableCollection<CreditCardViewModel>(ViewModels);
              
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }
            finally
            {
                IsBusy = false;
            }
        }
    }

}