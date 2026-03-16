using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;

namespace JessesPizza.Data
{
    public interface IPizzaRepo
    {
        Task<List<MainMenuItem>> GetAllMainMenuItems();
        Task<MainMenuItem> GetMainMenuItem(string id);
        Task AddMainMenuItem(MainMenuItem item);
        Task<MainMenuItem> UpdateMainMenuItem(MainMenuItem item);
        Task<bool> RemoveMainMenuItem(MainMenuItem item);


        Task<List<Group>> GetAllGroups();
        Task<Group> GetGroup(string id);
        Task AddGroup(Group group);
        Task<Group> UpdateGroup(Group group);
        Task<bool> RemoveGroup(Group group);


        Task<bool> SaveNewTransaction(MongoTransaction authorizedPayment);
        Task<bool> SaveNewTransactionV1_1(MongoTransactionV1_1 authorizedPayment);

        Task<IEnumerable<MongoTransaction>> GetAllTransactions();
        Task<IEnumerable<MongoTransactionV1_1>> GetAllTransactionsV1_1();

        Task<MongoTransaction> UpdateTransaction(MongoTransaction authorizedPayment);
        Task<MongoTransactionV1_1> UpdateTransaction(MongoTransactionV1_1 authorizedPayment);

        Task<MongoTransaction> GetTransactionByGuid(Guid guid); 
        Task<MongoTransactionV1_1> GetTransactionByGuidV1_1(Guid guid);

        Task<List<MongoTransaction>> GetTransactionsForUser(List<Guid> guids);
        Task<List<MongoTransactionV1_1>> GetTransactionsForUserV1_1(List<Guid> guids);

        Task<bool> DeleteTransaction(Guid guid);
        Task<bool> DeleteTransactionV1_1(Guid guid);

        Task<List<MongoTransaction>> GetTransactionsByState(TransactionState state);
        Task<List<MongoTransactionV1_1>> GetTransactionsByStateV1_1(TransactionState state);

        Task<MongoTransaction> UpdateTransactionState(MongoTransaction authorizedPayment);
        Task<MongoTransactionV1_1> UpdateTransactionStateV1_1(MongoTransactionV1_1 authorizedPayment);
        
        Task<JessesPizzaSettings> GetSettings();
        Task<JessesPizzaSettings> UpdateSettings(JessesPizzaSettings settings);
        Task AddSettings(JessesPizzaSettings settings);

        Task<bool> RemoveSettings(JessesPizzaSettings settings);

    }
}
