using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Services;
using JessesPizzaAdmin.ViewModels;
using JessesPizzaKitchen.Models;
using JessesPizzaKitchen.ViewModels;
using SQLite;
using Telerik.XamarinForms.ConversationalUI;
using Xamarin.Forms;

namespace JessesPizzaAdmin.ViewModels
{
    class OrdersViewModel : BaseViewModel
    {
        private string _connectedIcon;
        public string ConnectedIcon
        {
            get => _connectedIcon;
            set
            {
                _connectedIcon = value;
                OnPropertyChanged();

            }
        }

        private Color _IconColor;
        public Color IconColor
        {
            get => _IconColor;
            set
            {
                _IconColor = value;
                OnPropertyChanged();

            }
        }
        public Command LoadAuthorizedItemsCommand { get; set; }
        public Command LoadKitchenItemsCommand { get; set; }
        public Command LoadOutItemsCommand { get; set; }
        public Command LoadDeliveredItemsCommand { get; set; }
        public Command RefreshItemsCommand { get; set; }

        private readonly MongoService _service;

        public ObservableCollection<MongoTransaction> Payments { get; set; }
        public ObservableCollection<Grouping<PaymentParent, ShoppingCartItem>> AuthorizedPaymentsGrouped { get; set; }
        public ObservableCollection<Grouping<PaymentParent, ShoppingCartItem>> KitchenPaymentsGrouped { get; set; }
        public ObservableCollection<Grouping<PaymentParent, ShoppingCartItem>> OutPaymentsGrouped { get; set; }
        public ObservableCollection<Grouping<PaymentParent, ShoppingCartItem>> DeliveredPaymentsGrouped { get; set; }

        public OrdersViewModel()
        {
            Title = "My Orders";
            ConnectedIcon = "Connected";
            IconColor = Color.Red;
            Payments = new ObservableCollection<MongoTransaction>();
            AuthorizedPaymentsGrouped = new ObservableCollection<Grouping<PaymentParent, ShoppingCartItem>>();
            KitchenPaymentsGrouped = new ObservableCollection<Grouping<PaymentParent, ShoppingCartItem>>();
            OutPaymentsGrouped = new ObservableCollection<Grouping<PaymentParent, ShoppingCartItem>>();
            DeliveredPaymentsGrouped = new ObservableCollection<Grouping<PaymentParent, ShoppingCartItem>>();


            LoadAuthorizedItemsCommand = new Command(async () => await ExecuteLoadAuthorizedItemsCommand());
            LoadKitchenItemsCommand = new Command(async () => await ExecuteLoadKitchenItemsCommand());
            LoadOutItemsCommand = new Command(async () => await ExecuteLoadOutItemsCommand());
            LoadDeliveredItemsCommand = new Command(async () => await ExecuteLoadDeliveredItemsCommand());
            RefreshItemsCommand = new Command(async () => await ExecuteRefreshItemsCommand());

            _service = new MongoService();
        }
        public async Task ExecuteRefreshItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                var refreshResponse = await _service.RefreshTransactions();
                Device.BeginInvokeOnMainThread(() =>
                {
                    AuthorizedPaymentsGrouped.Clear();
                    KitchenPaymentsGrouped.Clear();
                    OutPaymentsGrouped.Clear();
                    DeliveredPaymentsGrouped.Clear();
                    if(refreshResponse != null)
                    if (refreshResponse.Transactions != null)
                    {
                        foreach (var payment in refreshResponse.Transactions)
                        {
                            var items = new List<ShoppingCartItem>();
                            foreach (var item in payment.Items)
                                items.Add(item);
                            var groupedPayment = new Grouping<PaymentParent, ShoppingCartItem>(new PaymentParent(payment), items);
                            switch (payment.TransactionState)
                            {
                                case TransactionState.Authorized:
                                    AuthorizedPaymentsGrouped.Add(groupedPayment);
                                    break;
                                case TransactionState.InKitchen:
                                    KitchenPaymentsGrouped.Add(groupedPayment);
                                    break;
                                case TransactionState.OutForDelivery:
                                    OutPaymentsGrouped.Add(groupedPayment);
                                    break;
                                case TransactionState.Delivered:
                                    DeliveredPaymentsGrouped.Add(groupedPayment);
                                    break;
                                default:
                                    break;
                            }
                        }

                    }
                    if (refreshResponse != null)
                        if (refreshResponse.TransactionsV1_1 != null)
                    {
                        foreach (var transactionv1_1 in refreshResponse.TransactionsV1_1)
                        {
                            var items = new List<ShoppingCartItem>();
                            foreach (var item in transactionv1_1.Items)
                                items.Add(item);
                            var groupedPayment = new Grouping<PaymentParent, ShoppingCartItem>(new PaymentParent(transactionv1_1, "1.1"), items);
                            switch (transactionv1_1.TransactionState)
                            {
                                case TransactionState.Authorized:
                                    AuthorizedPaymentsGrouped.Add(groupedPayment);
                                    break;
                                case TransactionState.InKitchen:
                                    KitchenPaymentsGrouped.Add(groupedPayment);
                                    break;
                                case TransactionState.OutForDelivery:
                                    OutPaymentsGrouped.Add(groupedPayment);
                                    break;
                                case TransactionState.Delivered:
                                    DeliveredPaymentsGrouped.Add(groupedPayment);
                                    break;
                                default:
                                    break;
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
                IsBusy = false;
            }
        }
        public async Task ExecuteLoadDeliveredItemsCommand()
        {
            //if (IsBusy)
            //    return;

            IsBusy = true;

            try
            {
                var transactions = await _service.GetTransactionsByState(TransactionState.Delivered);
                var newTransactions = await _service.GetTransactionsByStateV1_1(TransactionState.Delivered);
                Device.BeginInvokeOnMainThread(async () =>
               {

                   DeliveredPaymentsGrouped.Clear();
                   if (transactions != null)
                   {
                       Payments.Clear();
                       foreach (var transaction in transactions)
                           Payments.Add(transaction);
                       foreach (var payment in Payments)
                       {
                           if (payment.TransactionState != TransactionState.Delivered)
                               continue;
                           var items = new List<ShoppingCartItem>();
                           foreach (var item in payment.Items)
                               items.Add(item);
                           var groupedPayment = new Grouping<PaymentParent, ShoppingCartItem>(new PaymentParent(payment), items);
                           DeliveredPaymentsGrouped.Add(groupedPayment);
                       }

                   }
                   if (newTransactions != null)
                   {
                       foreach (var payment in newTransactions)
                       {
                           if (payment.TransactionState != TransactionState.Delivered)
                               continue;
                           var items = new List<ShoppingCartItem>();
                           foreach (var item in payment.Items)
                               items.Add(item);
                           var groupedPayment = new Grouping<PaymentParent, ShoppingCartItem>(new PaymentParent(payment,"1.1"), items);
                           DeliveredPaymentsGrouped.Add(groupedPayment);
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
                IsBusy = false;
            }
        }


        public async Task ExecuteLoadOutItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                Device.BeginInvokeOnMainThread(async () =>
                {
                    var transactions = await _service.GetTransactionsByState(TransactionState.OutForDelivery);
                    var newTransactions = await _service.GetTransactionsByStateV1_1(TransactionState.OutForDelivery);
                    OutPaymentsGrouped.Clear();
                    if (newTransactions != null)
                    {
                        foreach (var payment in newTransactions)
                        {
                            if (payment.TransactionState != TransactionState.OutForDelivery)
                                continue;
                            var items = new List<ShoppingCartItem>();
                            foreach (var item in payment.Items)
                                items.Add(item);
                            OutPaymentsGrouped.Add(new Grouping<PaymentParent, ShoppingCartItem>(new PaymentParent(payment, "1.1"), items));
                            
                        }

                    }
                    if (transactions != null)
                    {
                        Payments.Clear();
                        foreach (var authorizedPayment in transactions)
                            Payments.Add(authorizedPayment);
                        foreach (var payment in Payments)
                        {
                            if (payment.TransactionState != TransactionState.OutForDelivery)
                                continue;
                            var items = new List<ShoppingCartItem>();
                            foreach (var item in payment.Items)
                                items.Add(item);
                                    OutPaymentsGrouped.Add(new Grouping<PaymentParent, ShoppingCartItem>(new PaymentParent(payment), items));
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
                IsBusy = false;
            }
        }
        public async Task ExecuteLoadKitchenItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                Device.BeginInvokeOnMainThread(async () =>
                {
                    var transactions = await _service.GetTransactionsByState(TransactionState.InKitchen);
                    var newTransactions = await _service.GetTransactionsByStateV1_1(TransactionState.InKitchen);
                    KitchenPaymentsGrouped.Clear();
                    if (newTransactions != null)
                    {
                        Payments.Clear();

                        foreach (var payment in newTransactions)
                        {
                            if (payment.TransactionState != TransactionState.InKitchen)
                                continue;
                            var items = new List<ShoppingCartItem>();
                            foreach (var item in payment.Items)
                                items.Add(item);
                            KitchenPaymentsGrouped.Add(new Grouping<PaymentParent, ShoppingCartItem>(new PaymentParent(payment, "1.1"), items));
                        }

                    }
                    if (transactions != null)
                    {
                        Payments.Clear();

                        foreach (var authorizedPayment in transactions)
                            Payments.Add(authorizedPayment);
                        foreach (var payment in Payments)
                        {
                            if (payment.TransactionState != TransactionState.InKitchen)
                                continue;
                            var items = new List<ShoppingCartItem>();
                            foreach (var item in payment.Items)
                                items.Add(item);
                            KitchenPaymentsGrouped.Add(new Grouping<PaymentParent, ShoppingCartItem>(new PaymentParent(payment), items));
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
                IsBusy = false;
            }
        
        }



        public async Task ExecuteLoadAuthorizedItemsCommand()
        {
            if (IsBusy)
                return;

            IsBusy = true;

            try
            {
                Device.BeginInvokeOnMainThread(async () =>
                {
                    var transactions = await _service.GetTransactionsByState(TransactionState.Authorized);
                    var newTransactions = await _service.GetTransactionsByStateV1_1(TransactionState.Authorized);
                    AuthorizedPaymentsGrouped.Clear();
                    if (newTransactions != null)
                    {
                        Payments.Clear();
                        foreach (var payment in newTransactions)
                        {
                            if (payment.TransactionState != TransactionState.Authorized)
                                continue;
                            var items = new List<ShoppingCartItem>();
                            foreach (var item in payment.Items)
                                items.Add(item);
                            AuthorizedPaymentsGrouped.Add(new Grouping<PaymentParent, ShoppingCartItem>(new PaymentParent(payment, "1.1"), items));
                        }
                    }
                    if (transactions != null)
                    {
                        Payments.Clear();
                        foreach (var authorizedPayment in transactions)
                            Payments.Add(authorizedPayment);
                        foreach (var payment in Payments)
                        {
                            if (payment.TransactionState != TransactionState.Authorized)
                                continue;
                            var items = new List<ShoppingCartItem>();
                            foreach (var item in payment.Items)
                                items.Add(item);
                            AuthorizedPaymentsGrouped.Add(new Grouping<PaymentParent, ShoppingCartItem>(new PaymentParent(payment), items));
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
                IsBusy = false;
            }
        }
    }
}
