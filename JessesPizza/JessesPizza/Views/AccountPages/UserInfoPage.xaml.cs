using System;
using System.Linq;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Helpers;
using JessesPizza.Models;
using JessesPizza.Services;
using SQLite;
using Telerik.XamarinForms.Input;
using Telerik.XamarinForms.Input.DataForm;
using Telerik.XamarinForms.Primitives;
using Xamarin.Forms;
using Xamarin.Forms.Xaml;

namespace JessesPizza.Views
{
    [XamlCompilation(XamlCompilationOptions.Compile)]
    public partial class UserInfoPage : ContentPage
    {
        private CustomerInfoApp Form { get; set; }
        private string Amount { get; set; }
        private static int count { get; set; }
        private SQLiteConnection _db { get; set; }
        public UserInfoPage(bool isDelivery)
        {
            Form = new CustomerInfoApp();
            InitializeComponent();
            DataForm.Source = Form;
            DataForm.PropertyDataSourceProvider = new DateProvider();
            DataForm.RegisterEditor(nameof(Form.LastName), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(Form.FirstName), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(Form.AddressLine1), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(Form.City), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(Form.ZipCode), EditorType.IntegerEditor);
            DataForm.RegisterEditor(nameof(Form.EmailAddress), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(Form.PhoneNumber), EditorType.TextEditor);

        }
        public UserInfoPage(string amount,bool isDelivery)
        {
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);

            Form = new CustomerInfoApp();

            Amount = amount;
            InitializeComponent();
            DataForm.Source = Form;
            DataForm.PropertyDataSourceProvider = new DateProvider();
            DataForm.RegisterEditor(nameof(Form.LastName), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(Form.FirstName), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(Form.AddressLine1), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(Form.City), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(Form.ZipCode), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(Form.EmailAddress), EditorType.TextEditor);
            DataForm.RegisterEditor(nameof(Form.PhoneNumber), EditorType.TextEditor);
        }

        private void submit_button_clicked(object sender, EventArgs e)
        {
            DataForm.FormValidationCompleted += DataFormValidationCompleted;

            DataForm.CommitAll();

        }

        private async void DataFormValidationCompleted(object sender, FormValidationCompletedEventArgs e)
        {
            DataForm.FormValidationCompleted -= DataFormValidationCompleted;
            Form.FirstName = Form.FirstName.Trim();
            Form.LastName = Form.LastName.Trim();
            var name = string.Concat(Form.FirstName, " ", Form.LastName);
             
            if (e.IsValid)
            {

                var service = new MongoService();
                try
                {
                    var items = from i in _db.Table<ShoppingCartItem>()
                                select i;
                    var orderTotal = (from o in _db.Table<OrderTotals>() select o).FirstOrDefault();
                    if (orderTotal == null)
                    {
                        PopupHelper.CreatePopup("Uh-oh!", "Unable to process Transaction");
                        return;
                    }
                    var localTransaction = new LocalTransactionV1_1()
                    {
                        Info = Form,
                        TransactionItems = items.ToList(),
                        Totals = orderTotal
                    };
                    _db.CreateTable<SqliteTransaction>();
                    var sqliteForm = new SqliteTransaction(Form);
                    var forms = from f in _db.Table<SqliteTransaction>() select f;
                    if (forms.Count() != 0)
                        _db.DeleteAll<SqliteTransaction>();
                    _db.Insert(sqliteForm);

                    var response = await service.ValidateTransaction(localTransaction);
                    if (response.Succeeded)
                    {
                        var sendTransactionResponse = await service.GetHPPTokenAsync(localTransaction);
                        if (sendTransactionResponse!=null)
                        {
                            await Navigation.PushAsync(new WebViewPage(sendTransactionResponse));
                        }
                        else
                        {
                            PopupHelper.CreatePopup("Uh-oh!","Unable to process transaction");
                        }
                    }
                    else
                    {
                        if (response.Message != null || response.Message != string.Empty)
                            PopupHelper.CreatePopup("Uh-oh!", response.Message);
                        else
                            PopupHelper.CreatePopup("Uh-oh!", "Unable to process transaction");
                    }
                }
                catch (Exception exception)
                {
                    PopupHelper.CreatePopup("Uh-oh!", "Unable to process transaction");
                }
            }
            else
            {
                await Application.Current.MainPage.DisplayAlert("Fail", "There are some invalid fields.", "OK");
            }
        }
    }
}