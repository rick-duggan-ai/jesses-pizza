using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JessesPizza.Core.Models.Identity.Guest;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Helpers;
using JessesPizza.Models;
using JessesPizza.Services;
using SQLite;
using Xamarin.Essentials;
using Xamarin.Forms;

namespace JessesPizza.ViewModels
{
    class OrdersViewModel : BaseViewModel
    {
        public Command LoadItemsCommand { get; set; }
        public ObservableCollection<SqliteTransaction> LocalTransactions { get; set; }
        private ObservableCollection<MongoTransactionViewModel> _openTransactions;
        public ObservableCollection<MongoTransactionViewModel> OpenTransactions
        {
            get { return _openTransactions; }
            set
            {
                _openTransactions = value;
                OnPropertyChanged("OpenTransactions");
            }
        }
        private bool _isEmpty;
        public bool IsEmpty
        {
            get => _isEmpty;
            set
            {
                _isEmpty = value;
                OnPropertyChanged();
            }
        }
        private bool _isLoading;
        public bool IsLoading
        {
            get => _isLoading;
            set
            {
                _isLoading = value;
                OnPropertyChanged();
            }
        }
        public OrdersViewModel()
        {
            Title = "My Orders";
            OpenTransactions = new ObservableCollection<MongoTransactionViewModel>();
            LoadItemsCommand = new Command(async () => await ExecuteLoadItemsCommand());
            IsEmpty = false;

        }
        async Task ExecuteLoadItemsCommand()
        {
            if (IsLoading)
                return;

            IsLoading = true;
            IsEmpty = false;

            try
            {
                Device.BeginInvokeOnMainThread(async ()=>
                {
                    OpenTransactions.Clear();
                    var service = new MongoService();
                    var db = new SQLiteConnection(Constants.SqlLiteDbFolder);
                    db.CreateTable<GuestTransaction>();
                    var isGuest = bool.Parse(await SecureStorage.GetAsync("oauth_token_is_guest"));

                    if (isGuest)
                    {
                        var items = from i in db.Table<GuestTransaction>()
                                    select i;
                        if (items != null)
                        {
                            if (items.Count() != 0)
                            {
                                foreach (var item in items)
                                {
                                    if (item != null)
                                    {

                                        var transaction = await service.GetTransactionByGuid(item.TransactionId);
                                        if (transaction != null)
                                        {
                                            var vm = new MongoTransactionViewModel(transaction);
                                            OpenTransactions.Add(vm);
                                        }
                                    }
                                }
                                if (OpenTransactions.Count() == 0)
                                    IsEmpty = true;
                                else
                                {
                                    var sortedTransactions = new ObservableCollection<MongoTransactionViewModel>(OpenTransactions.OrderByDescending(x => x.Date));
                                    OpenTransactions = sortedTransactions;
                                }
                            }
                            else
                                IsEmpty = true;
                        }
                        else
                            IsEmpty = true;
                    }
                    else
                    {
                        var response = await service.GetOrders();
                        if (response == null)
                        {
                            PopupHelper.CreateErrorPopup("Something went wrong");
                            return;
                        }
                        if (!response.Succeeded)
                            PopupHelper.CreateErrorPopup(response.Message);
                        if (response.Transactions != null)
                        {
                            foreach (var transaction in response.Transactions)
                            {
                                var vm = new MongoTransactionViewModel(transaction);
                                OpenTransactions.Add(vm);
                            }
                            if (OpenTransactions.Count() == 0)
                                IsEmpty = true;
                            else
                            {
                                var sortedTransactions = new ObservableCollection<MongoTransactionViewModel>(OpenTransactions.OrderByDescending(x => x.Date));
                                OpenTransactions = sortedTransactions;
                            }
                        }
                    }
                });

            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex);
            }
            finally
            {
                IsLoading = false;
            }
        }
    }
}
