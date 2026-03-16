using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Authentication;
using System.Threading.Tasks;
using JessesPizza.Core;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Transactions;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.Linq;

namespace JessesPizza.Data
{
    public class PizzaRepo : IPizzaRepo
    {
        private static IMongoCollection<MainMenuItem> _mainMenuItemsCollection;
        private static IMongoCollection<JessesPizzaSettings> _settingsCollection;
        private static IMongoCollection<MongoTransaction> _transactionsCollection;
        private static IMongoCollection<MongoTransactionV1_1> _transactionsV1_1Collection;

        private static IMongoCollection<Group> _groupsCollection;

        private static IMongoCollection<MainMenuItem> MainMenuItemsCollection =>
            _mainMenuItemsCollection ?? (_mainMenuItemsCollection =
                _db.GetCollection<MainMenuItem>(MainMenuItemsCollectionName, _collectionSettings));
        private static IMongoCollection<JessesPizzaSettings> SettingsCollection =>
            _settingsCollection ?? (_settingsCollection =
                _db.GetCollection<JessesPizzaSettings>(SettingsCollectionName, _collectionSettings));
        static IMongoCollection<Group> GroupsCollection =>
            _groupsCollection ??
            (_groupsCollection = _db.GetCollection<Group>(GroupsCollectionName, _collectionSettings));
        static IMongoCollection<MongoTransaction> TransactionsCollection =>
            _transactionsCollection ?? (_transactionsCollection =
                _db.GetCollection<MongoTransaction>(TransactionsCollectionName, _collectionSettings));
        static IMongoCollection<MongoTransactionV1_1> TransactionsV1_1Collection =>
    _transactionsV1_1Collection ?? (_transactionsV1_1Collection =
        _db.GetCollection<MongoTransactionV1_1>("TransactionsV1_1", _collectionSettings));


        private const string DbName = "JessesPizzaDB";
        private const string SettingsCollectionName = "Settings";
        private const string MainMenuItemsCollectionName = "MainMenuItems";
        private const string TransactionsCollectionName = "Transactions";
        private const string GroupsCollectionName = "Groups";
        private static MongoCollectionSettings _collectionSettings;
        private static IMongoDatabase _db;

        //use for unit tests to access test DB
        //public PizzaRepo(string connectionString)
        //{
        //    var settings = MongoClientSettings.FromUrl(
        //        new MongoUrl(connectionString)
        //    );
        //    settings.SslSettings = new SslSettings { EnabledSslProtocols = SslProtocols.Tls12 };
        //    BsonDefaults.GuidRepresentation = GuidRepresentation.Standard;
        //    var client = new MongoClient(settings);
        //    _db = client.GetDatabase(DbName);
        //    _collectionSettings = new MongoCollectionSettings { ReadPreference = ReadPreference.Nearest };

        //}
        // Get connection string from ENV Variable
        public PizzaRepo()
        {
            var connectionString = Environment.GetEnvironmentVariable("MONGO_CONNECTION_STRING");
            var settings = MongoClientSettings.FromUrl(
                new MongoUrl(connectionString)
            );
            settings.SslSettings = new SslSettings { EnabledSslProtocols = SslProtocols.Tls12 };
            settings.GuidRepresentation = GuidRepresentation.Standard;
            var client = new MongoClient(settings);
            _db = client.GetDatabase(DbName);
            _collectionSettings = new MongoCollectionSettings { ReadPreference = ReadPreference.Nearest };

        }
        //Use hardcoded connection string
        //public PizzaRepo()
        //{
        //    var connectionString = "mongodb+srv://jesses:rwguMF0CSr01x3wD@jesses-sandbox-ndqtx.mongodb.net/test?retryWrites=true&w=majority";
        //    try
        //    {
        //        var settings = MongoClientSettings.FromUrl(
        //            new MongoUrl(connectionString)
        //        );
        //        settings.SslSettings = new SslSettings { EnabledSslProtocols = SslProtocols.Tls12 };
        //        BsonDefaults.GuidRepresentation = GuidRepresentation.Standard;
        //        var client = new MongoClient(settings);
        //        _db = client.GetDatabase(DbName);
        //        _collectionSettings = new MongoCollectionSettings { ReadPreference = ReadPreference.Nearest };
        //        Console.WriteLine($"connected to mongodb with {connectionString}");

        //    }
        //    catch (Exception e)
        //    {
        //        Console.WriteLine($"connected to mongodb with {connectionString} because {e.Message}");
        //    }
        //}
        #region Transactions
        public async Task<IEnumerable<MongoTransaction>> GetAllTransactions()
        {
            var allItems = await TransactionsCollection
                .AsQueryable()
                .ToListAsync();
            return allItems;
        }
        public async Task<IEnumerable<MongoTransactionV1_1>> GetAllTransactionsV1_1()
        {
            var allItems = await TransactionsV1_1Collection
                .AsQueryable()
                .ToListAsync();
            return allItems;
        }

        public async Task<MongoTransaction> GetTransactionByGuid(Guid guid)
        {
            var allItems = await TransactionsCollection
                .AsQueryable()
                .Where(x => x.TransactionGuid == guid)
                .ToListAsync();
            return allItems.FirstOrDefault();
        }
        public async Task<MongoTransactionV1_1> GetTransactionByGuidV1_1(Guid guid)
        {
            var allItems = await TransactionsV1_1Collection
                .AsQueryable()
                .Where(x => x.TransactionGuid == guid)
                .ToListAsync();
            return allItems.FirstOrDefault();
        }
        public async Task<bool> DeleteTransaction(Guid guid)
        {
            var result = await TransactionsCollection.DeleteOneAsync(t => t.TransactionGuid == guid);

            return result.IsAcknowledged && result.DeletedCount == 1;
        }
        public async Task<bool> DeleteTransactionV1_1(Guid guid)
        {
            var result = await TransactionsV1_1Collection.DeleteOneAsync(t => t.TransactionGuid == guid);

            return result.IsAcknowledged && result.DeletedCount == 1;
        }
        public async Task<List<MongoTransaction>> GetTransactionsByState(TransactionState state)
        {
            var allItems = await TransactionsCollection
                .AsQueryable()
                .Where(x => x.TransactionState == state)
                .ToListAsync();
            return allItems;
        }
        public async Task<List<MongoTransactionV1_1>> GetTransactionsByStateV1_1(TransactionState state)
        {
            var allItems = await TransactionsV1_1Collection
                .AsQueryable()
                .Where(x => x.TransactionState == state)
                .ToListAsync();
            return allItems;
        }

        public async Task<MongoTransactionV1_1> UpdateTransaction(MongoTransactionV1_1 authorizedPayment)
        {
            try
            {
                var updateEntry = await GetTransactionByGuidV1_1(authorizedPayment.TransactionGuid);
                if (updateEntry == null)
                    return null;

                var update = Builders<MongoTransactionV1_1>.Update
                    .Set(x => x.Address1, authorizedPayment.Address1)
                    .Set(x => x.City, authorizedPayment.City)
                    .Set(x => x.Email, authorizedPayment.Email)
                    .Set(x => x.Name, authorizedPayment.Name)
                    .Set(x => x.PhoneNumber, authorizedPayment.PhoneNumber)
                    .Set(x => x.ZipCode, authorizedPayment.ZipCode)
                    .Set(x => x.SubTotal, authorizedPayment.SubTotal)
                    .Set(x => x.TaxTotal, authorizedPayment.TaxTotal)
                    .Set(x => x.DeliveryCharge, authorizedPayment.DeliveryCharge)
                    .Set(x => x.TransactionState, authorizedPayment.TransactionState)
                    .Set(x => x.TransactionStateV1_1, authorizedPayment.TransactionStateV1_1)
                    .Set(x => x.Date, authorizedPayment.Date)
                    .Set(x => x.ConvergeTransactionId, authorizedPayment.ConvergeTransactionId)
                    .Set(x => x.CardPreview, authorizedPayment.CardPreview)
                    .Set(x => x.CardShortDescription, authorizedPayment.CardShortDescription)
                    .Set(x => x.ExpDate, authorizedPayment.ExpDate)
                    .Set(x => x.Items, authorizedPayment.Items);


                var updoneresult = await TransactionsV1_1Collection.UpdateOneAsync(Builders<MongoTransactionV1_1>.Filter.Eq("TransactionGuid", authorizedPayment.TransactionGuid), update);
                if (updoneresult.IsAcknowledged)
                {
                    updateEntry = await GetTransactionByGuidV1_1(authorizedPayment.TransactionGuid);
                    return updateEntry;
                }
                return null;
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                return null;
            }
        }
        public async Task<MongoTransaction> UpdateTransaction(MongoTransaction authorizedPayment)
        {
            try
            {
                var updateEntry = await GetTransactionByGuid(authorizedPayment.TransactionGuid);
                if (updateEntry == null)
                    return null;

                var update = Builders<MongoTransaction>.Update
                    .Set(x => x.Address1, authorizedPayment.Address1)
                    .Set(x => x.City, authorizedPayment.City)
                    .Set(x => x.Email, authorizedPayment.Email)
                    .Set(x => x.Name, authorizedPayment.Name)
                    .Set(x => x.PhoneNumber, authorizedPayment.PhoneNumber)
                    .Set(x => x.ZipCode, authorizedPayment.ZipCode)
                    .Set(x => x.SubTotal, authorizedPayment.SubTotal)
                    .Set(x => x.TaxTotal, authorizedPayment.TaxTotal)
                    .Set(x => x.DeliveryCharge, authorizedPayment.DeliveryCharge)
                    .Set(x => x.TransactionState, authorizedPayment.TransactionState)
                    .Set(x => x.Date, authorizedPayment.Date)
                    .Set(x => x.ConvergeTransactionId, authorizedPayment.ConvergeTransactionId)
                    .Set(x => x.CardPreview, authorizedPayment.CardPreview)
                    .Set(x => x.CardShortDescription, authorizedPayment.CardShortDescription)
                    .Set(x => x.ExpDate, authorizedPayment.ExpDate)
                    .Set(x => x.Items, authorizedPayment.Items);
                var updoneresult = await TransactionsCollection.UpdateOneAsync(Builders<MongoTransaction>.Filter.Eq("TransactionGuid", authorizedPayment.TransactionGuid), update);
                if (updoneresult.IsAcknowledged)
                {
                    updateEntry = await GetTransactionByGuid(authorizedPayment.TransactionGuid);
                    return updateEntry;
                }
                return null;
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                return null;
            }
        }
        public async Task<MongoTransaction> UpdateTransactionState(MongoTransaction authorizedPayment)
        {
            try
            {
                var updateEntry = await GetTransactionByGuid(authorizedPayment.TransactionGuid);
                if (updateEntry == null)
                    return null;

                var update = Builders<MongoTransaction>.Update.Set(x => x.TransactionState, authorizedPayment.TransactionState);
                var updoneresult = await TransactionsCollection.UpdateOneAsync(Builders<MongoTransaction>.Filter.Eq("TransactionGuid", authorizedPayment.TransactionGuid), update);
                if (updoneresult.IsAcknowledged)
                {
                    updateEntry = await GetTransactionByGuid(authorizedPayment.TransactionGuid);
                    return updateEntry;
                }
                return null;
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                return null;
            }
        }
        public async Task<MongoTransactionV1_1> UpdateTransactionStateV1_1(MongoTransactionV1_1 authorizedPayment)
        {
            try
            {
                var updateEntry = await GetTransactionByGuidV1_1(authorizedPayment.TransactionGuid);
                if (updateEntry == null)
                    return null;

                var update = Builders<MongoTransactionV1_1>.Update.Set(x => x.TransactionState, authorizedPayment.TransactionState).Set(x => x.TransactionStateV1_1,(TransactionStateV1_1) authorizedPayment.TransactionState);
                var updoneresult = await TransactionsV1_1Collection.UpdateOneAsync(Builders<MongoTransactionV1_1>.Filter.Eq("TransactionGuid", authorizedPayment.TransactionGuid), update);
                if (updoneresult.IsAcknowledged)
                {
                    updateEntry = await GetTransactionByGuidV1_1(authorizedPayment.TransactionGuid);
                    return updateEntry;
                }
                return null;
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                return null;
            }
        }
        public async Task<bool> SaveNewTransaction(MongoTransaction authorizedPayment)
        {
            try
            {
                await TransactionsCollection.InsertOneAsync(authorizedPayment);
                return true;
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                return false;
            }
        }
        public async Task<bool> SaveNewTransactionV1_1(MongoTransactionV1_1 authorizedPayment)
        {
            try
            {
                await TransactionsV1_1Collection.InsertOneAsync(authorizedPayment);
                return true;
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                return false;
            }
        }
        #endregion
        #region MainMenuItems

        public async Task<List<MainMenuItem>> GetAllMainMenuItems()
        {
            try { 
                var allItems = await MainMenuItemsCollection
                    .Find(new BsonDocument())
                    .ToListAsync();
                return allItems.OrderBy(x=>x.Ordinal).ToList();

            }
            catch(Exception e)
            {
                return new List<MainMenuItem>();

            }

        }
        public async Task<MainMenuItem> GetMainMenuItem(string id)
        {
            try
            {
                var results = await MainMenuItemsCollection
                    .AsQueryable()
                    .Where(mi => mi.Id.Equals(id))
                    .ToListAsync();

                return results.FirstOrDefault();
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                return null;
            }
        }
        public async Task AddMainMenuItem(MainMenuItem item)
        {
            try
            {
                await MainMenuItemsCollection.InsertOneAsync(item);
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
            }

        }
        public async Task<bool> RemoveMainMenuItem(MainMenuItem item)
        {
            try { 
            var result = await MainMenuItemsCollection.DeleteOneAsync(mi => mi.Id == item.Id);

            return result.IsAcknowledged && result.DeletedCount == 1;
            }
            catch
            {
                return false;
            }
        }
        public async Task<MainMenuItem> UpdateMainMenuItem(MainMenuItem updatedItem)
        {
            try
            {
                var updateEntry = await GetMainMenuItem(updatedItem.Id);
                if (updateEntry == null)
                    return null;

                var update = Builders<MainMenuItem>.Update.Set(x => x.Name, updatedItem.Name)
                    .Set(x => x.MenuItems, updatedItem.MenuItems)
                    .Set(x => x.Ordinal, updatedItem.Ordinal)
                    .Set(x => x.ImageUrl, updatedItem.ImageUrl);
;
                var updoneresult = await MainMenuItemsCollection.UpdateOneAsync(Builders<MainMenuItem>.Filter.Eq("Id", updatedItem.Id), update);
                if (updoneresult.IsAcknowledged)
                {
                    updateEntry = await GetMainMenuItem(updatedItem.Id);
                    return updateEntry;
                }
                return null;
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                return null;
            }
        }
        #endregion

        #region Groups

        public async  Task<List<Group>> GetAllGroups()
        {
            var results = await GroupsCollection
                .AsQueryable()
                .ToListAsync();

            return results;
        }

        public async Task<Group> GetGroup(string id)
        {
            var results = await GroupsCollection
                .AsQueryable()
                .Where(mi => mi.Id == id).ToListAsync()
                ;

            return results.FirstOrDefault();
        }

        public async Task AddGroup(Group group)
        {
            try
            {
                await GroupsCollection.InsertOneAsync(group);

            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
            }
        }
        public async Task<Group> UpdateGroup(Group group)
        {
            try
            {
                var updateEntry = await GetGroup(group.Id);
                if (updateEntry == null)
                    return null;

                var update = Builders<Group>.Update.Set(x => x.Name, group.Name)
                    .Set(x => x.Type, group.Type)
                    .Set(x=>x.Type,group.Type)
                    .Set(x => x.GroupType, group.GroupType)
                    .Set(x => x.IsRequired, group.IsRequired)
                    .Set(x => x.Max, group.Max)
                    .Set(x => x.Min, group.Min)
                    .Set(x => x.Items, group.Items)
                    .Set(x => x.ImageUrl, group.ImageUrl);
                ;
                var updoneresult = await GroupsCollection.UpdateOneAsync(Builders<Group>.Filter.Eq("Id", group.Id), update);
                if (!updoneresult.IsAcknowledged) return null;
                updateEntry = await GetGroup(group.Id);
                return updateEntry;
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                return null;
            }
        }

        public async Task<bool> RemoveGroup(Group group)
        {
            var result = await GroupsCollection.DeleteOneAsync(mi => mi.Id == group.Id);

            return result.IsAcknowledged && result.DeletedCount == 1;
        }
        #endregion
        #region Settings

        public async Task<JessesPizzaSettings> GetSettings()
        {
            try
            {
                var results = await SettingsCollection
                .AsQueryable()
                .ToListAsync();
                JessesPizzaSettings first = null;
                if (results == null) return first;
                if (results.Count != 0)
                    first = results.FirstOrDefault();
                return first;
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
                return null;
            }
        }
        public async Task AddSettings(JessesPizzaSettings settings)
        {
            try
            {
                var list = await SettingsCollection.AsQueryable().ToListAsync();
                if (!list.Any()) 
                    await SettingsCollection.InsertOneAsync(settings);

            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
            }
        }

        public async Task<JessesPizzaSettings> UpdateSettings(JessesPizzaSettings settings)
        {
            try
            {
                var delete = await RemoveSettings(settings);
                if (delete)
                    await AddSettings(settings);
                else
                    return null;
                return settings;
            }
            catch (Exception exception)
            {
                Console.WriteLine(exception);
                return null;
            }
        }

        public async Task<bool> RemoveSettings(JessesPizzaSettings settings)
        {
            var result = await SettingsCollection.DeleteOneAsync(s=> s.Id == settings.Id);

            return result.IsAcknowledged && result.DeletedCount == 1;
        }

        public async Task<List<MongoTransaction>> GetTransactionsForUser(List<Guid> guids)
        {
            var list = new List<MongoTransaction>();
            try
            {
                //foreach(var guid in guids)
                //{
                //    Console.WriteLine($"Trying Guid {guid}");
                //    var transaction = TransactionsCollection.AsQueryable().FirstOrDefault(x=>x.TransactionGuid == guid);
                //    if(transaction!= null)
                //        list.Add(transaction);

                //}
                //return list;
                return await TransactionsCollection
                    .AsQueryable()
                    .Where(x => guids.Contains(x.TransactionGuid))
                    .ToListAsync();
            }
            catch(Exception e)
            {
                Console.WriteLine($"Failed");
                return null;
            }

        }


        public async Task<List<MongoTransactionV1_1>> GetTransactionsForUserV1_1(List<Guid> guids)
        {
            return await TransactionsV1_1Collection
                 .AsQueryable()
                 .Where(x => guids.Contains(x.TransactionGuid))
                 .ToListAsync();
        }
        #endregion

    }
}
