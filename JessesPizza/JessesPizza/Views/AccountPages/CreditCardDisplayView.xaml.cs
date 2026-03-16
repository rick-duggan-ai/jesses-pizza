using JessesPizza.Core.Models.Transactions;
using JessesPizza.ViewModels;
using Xamarin.Forms;

namespace JessesPizza.Views
{
    public partial class CreditCardDisplayView : StackLayout
    {
        public CreditCardViewModel ViewModel;
        public CreditCardDisplayView(CreditCardViewModel card)
        {
            InitializeComponent();
           BindingContext = ViewModel = card;
            
        }
        public CreditCardDisplayView()
        {
            InitializeComponent();
        }
    }
}
