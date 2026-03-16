using System;
using System.Threading.Tasks;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Core.Models.Transactions;
using JessesPizzaKitchen.Models;

namespace JessesPizzaKitchen.Services
{
    public interface IMongoService
    {

        Task<MongoTransaction> GetTransactionByGuid(Guid transactionGuid);
        //Task<MongoTransaction> GetTransactionByToken(string spreedlyToken);
        //Task<MongoTransaction> CancelTransaction(MongoTransaction authorizedPayment);
        Task<MongoTransaction> UpdateTransaction(MongoTransaction authorizedPayment);
        Task<UpdateDeliveryTimeResponse> UpdateDeliveryTime(UpdateDeliveryTimeRequest authorizedPayment);
        Task<KDSGetTransactionsResponse> RefreshTransactions();

    }
}
