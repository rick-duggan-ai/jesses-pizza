using System;
using System.Linq;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Helpers;
using JessesPizza.Models;
using JessesPizza.Services;
using JessesPizza.ViewModels;
using SQLite;
using Telerik.Windows.Documents.Fixed.Model.Objects;
using Telerik.XamarinForms.Input;
using Telerik.XamarinForms.Input.DataForm;
using Telerik.XamarinForms.Primitives;
using Xamarin.Essentials;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class GuestInfoPage : ContentPage
    {
        private static int count { get; set; }
        private SQLiteConnection _db { get; set; }
        public bool Delivery { get; }
        public bool NoContact { get; }

        private GuestInfoViewModel _viewModel; 
        public bool buttonPressed = false;
        protected override async void OnAppearing()
        {
            base.OnAppearing();
            buttonPressed = false;
        }

        public GuestInfoPage()
        {

            InitializeComponent();
            BindingContext = _viewModel = new GuestInfoViewModel();
            DataForm.PropertyDataSourceProvider = new DateProvider();
            DataForm.RegisterEditor(nameof(_viewModel.LastName), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.FirstName), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.AddressLine1), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.City), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.ZipCode), EditorType.IntegerEditor);
            DataForm.RegisterEditor(nameof(_viewModel.Email), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.PhoneNumber), EditorType.TextEditor);

        }
        public GuestInfoPage(string title,bool delivery,bool noContact)
        {
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);
            BindingContext = _viewModel = new GuestInfoViewModel();
            this.Title = title;
            InitializeComponent();
            DataForm.Source = _viewModel;
            DataForm.PropertyDataSourceProvider = new DateProvider();
            DataForm.RegisterEditor(nameof(_viewModel.LastName), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.FirstName), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.AddressLine1), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.City), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.ZipCode), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.Email), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(_viewModel.PhoneNumber), EditorType.TextEditor);
            Delivery = delivery;
            NoContact = noContact;
        }

        private void submit_button_clicked(object sender, EventArgs e)
        {
            DataForm.FormValidationCompleted += DataFormValidationCompleted;

            DataForm.CommitAll();

        }

        private async void DataFormValidationCompleted(object sender, FormValidationCompletedEventArgs e)
        {
            if (buttonPressed) return;
            buttonPressed = true;
            DataForm.FormValidationCompleted -= DataFormValidationCompleted;
            if (e.IsValid)
            {

                try
                {
                    _viewModel.FirstName = _viewModel.FirstName.Trim();
                    _viewModel.LastName = _viewModel.LastName.Trim();
                    var name = string.Concat(_viewModel.FirstName, " ", _viewModel.LastName);

                    var items = from i in _db.Table<ShoppingCartItem>()
                        select i;
                    var orderTotals = (from o in _db.Table<OrderTotals>() select o).ToList();
                    var totals = orderTotals.FirstOrDefault();
                    if (totals == null)
                    {
                        PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
                        return;
                    }
                    if (orderTotals.Count() != 0)
                        _db.DeleteAll<OrderTotals>();
                    _db.Insert(totals);
                        
                    CustomerInfoApp info = new CustomerInfoApp()
                    {
                        AddressLine1 = _viewModel.AddressLine1,
                        City = _viewModel.City,
                        EmailAddress = _viewModel.Email,
                        FirstName = _viewModel.FirstName,
                        LastName = _viewModel.LastName,
                        ZipCode = _viewModel.ZipCode,
                        PhoneNumber = _viewModel.PhoneNumber
                    };
                    var localTransaction = new LocalTransactionV1_1()
                    {
                        Info = info,
                        TransactionItems = items.ToList(),
                        Totals = totals,
                        IsDelivery = Delivery,
                        NoContactDelivery = NoContact,
                        SpecialInstructions = totals.SpecialInstructions
                    };
                    _db.CreateTable<SqliteTransaction>();
                    var localTransactionSqlite = new SqliteTransaction(info);
                    var forms = from f in _db.Table<SqliteTransaction>() select f;
                    if (forms.Count() != 0)
                        _db.DeleteAll<SqliteTransaction>();
                    _db.Insert(localTransactionSqlite);

                    var response = await App.MenuManager.ValidateTransaction(localTransaction);
                    if (response.Succeeded)
                    {
                        var sendTransactionResponse = await App.MenuManager.GetHPPToken(localTransaction);
                        if (sendTransactionResponse != null)
                        {
                            await Navigation.PushAsync(new WebViewPage(sendTransactionResponse));
                        }
                        else
                        {
                            PopupHelper.CreatePopup("Uh-oh!", "Unable to process transaction");
                            buttonPressed = false;
                        }
                    }
                    else
                    {
                        if (response.Message != null || response.Message != string.Empty)
                            PopupHelper.CreatePopup("Uh-oh!", response.Message);
                        else
                            PopupHelper.CreatePopup("Uh-oh!", "Unable to process transaction");
                        buttonPressed = false;
                    }
                }
                catch (Exception exception)
                {
                    PopupHelper.CreatePopup("Uh-oh!", "Unable to process transaction");
                    buttonPressed = false;
                }
            }
            else
            {
                buttonPressed = false;
                await Application.Current.MainPage.DisplayAlert("Uh-oh!", "There are some invalid fields.", "OK");
            }
        }
    }
}