using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Authentication;
using System.Text;
using System.Threading.Tasks;
using Flurl;
using Flurl.Http;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Core.Models.Transactions;
using JessesPizzaKitchen;
using JessesPizzaKitchen.Models;
using JessesPizzaKitchen.Services;
using JessesPizzaKitchen.Views;
using MongoDB.Bson;
using MongoDB.Bson.IO;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using SQLite;

namespace JessesPizza.Services
{
    public class MongoService :IMongoService
    {
        SQLiteConnection _db;
        readonly HttpClient _client;
        public AppUser _user;
        public MongoService()
        {
            _db = new SQLiteConnection(Constants.SqlLiteDbFolder);
            _client = new HttpClient();
            _client.BaseAddress = new Uri(Constants.JessesUrl);

        }
        private async Task GetJWT()
        {
            try
            {
                var request = new GuestLoginRequest() { Secret = "JessesPizzaAppSecret" };
                var response = await Constants.BaseAddress.AppendPathSegment("api/Auth/GuestLogin").PostJsonAsync(request).ReceiveJson<GuestLoginResponse>();

                if (response != null)
                {
                    _user = new AppUser() { Token = response.Token, TokenExpires = response.TokenExpires };
                }
            }
            catch (Exception e)
            {

            }
        }
        private async Task CheckTokenAsync()
        {
            try { 
            if (_user == null)
                await GetJWT();
            if (string.IsNullOrEmpty(_user.Token))
                await GetJWT();
            if (_user.TokenExpires < DateTime.UtcNow)
                await GetJWT();
            }
            catch
            {
            }
        }

        public async Task<bool> UpdateTransactionState(TransactionState state, Guid transactionGuid,double version)
        {
            try
            {
                await CheckTokenAsync();
                var request = new JessesPizzaKitchen.Models.UpdateTransactionStateRequest(){State = state,TransactionGuid = transactionGuid};
                var response = await Constants.JessesUrl.AppendPathSegment("UpdateTransactionState").WithHeader("X-Version", version.ToString()).WithOAuthBearerToken(_user.Token).PostJsonAsync(request).ReceiveJson<bool>();
                return response;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return false;
            }

        }  
        public async Task<List<MongoTransaction>> GetTransactionsByState(TransactionState state)
        {
            try
            {
                await CheckTokenAsync();
                var url = Constants.JessesUrl.AppendPathSegment("Transactions").WithOAuthBearerToken(_user.Token).AppendPathSegment(state);
                var response = await url.GetJsonAsync<List<MongoTransaction>>();
                return response;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }

        }
        public async Task<KDSGetTransactionsResponse> RefreshTransactions()
        {
            try
            {
                await CheckTokenAsync();
                var url = Constants.JessesUrl.AppendPathSegment("RefreshTransactions").WithOAuthBearerToken(_user.Token);
                var response = await url.GetJsonAsync<KDSGetTransactionsResponse>();
                return response;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }

        }
        public async Task<List<MongoTransactionV1_1>> GetTransactionsByStateV1_1(TransactionState state)
        {
            try
            {
                await CheckTokenAsync();
                var url = Constants.JessesUrl.AppendPathSegment("Transactions").WithHeader("X-Version","1.1").WithOAuthBearerToken(_user.Token).AppendPathSegment(state);
                var response = await url.GetJsonAsync<List<MongoTransactionV1_1>>();
                return response;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }

        }
        public async Task<MongoTransaction> GetTransactionByGuid(Guid transactionGuid)
        {
            try
            {
                await CheckTokenAsync();
                var response = await Constants.JessesUrl.AppendPathSegment("TransactionGuid").WithOAuthBearerToken(_user.Token).SetQueryParams(new {
                    transactionGuid = new Guid(transactionGuid.ToString())
                }).GetJsonAsync<MongoTransaction>();
                return response;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }

        }


        public async Task<MongoTransaction> UpdateTransaction(MongoTransaction authorizedPayment)
        {
            try
            {
                await CheckTokenAsync();
                var response = await Constants.JessesUrl.AppendPathSegment("UpdateTransaction").WithOAuthBearerToken(_user.Token).PostJsonAsync(authorizedPayment).ReceiveJson<MongoTransaction>();
                if (response != null)
                {
                    return response;
                }
                return new MongoTransaction();

            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return new MongoTransaction();

            }

        }

        public async Task<UpdateDeliveryTimeResponse> UpdateDeliveryTime(UpdateDeliveryTimeRequest authorizedPayment)
        {
            try
            {
                await CheckTokenAsync();
                var response = await Constants.JessesUrl.AppendPathSegment("UpdateDeliveryTime").WithOAuthBearerToken(_user.Token).PostJsonAsync(authorizedPayment).ReceiveJson<UpdateDeliveryTimeResponse>();
                if (response != null)
                {
                    return response;
                }
                return new UpdateDeliveryTimeResponse() {Succeeded=false, Message="Something went wrong" };

            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return new UpdateDeliveryTimeResponse() { Succeeded = false, Message = "Something went wrong" };

            }
        }
    }
}
//public async Task<List<MongoTransaction>> GetTodaysTransaction( )
//{
//    try
//    {
//        await CheckTokenAsync();
//        var response = await Constants.JessesUrl.AppendPathSegment("TransactionsToday").GetJsonAsync<List<MongoTransaction>>();
//        return response;
//    }
//    catch (Exception ex)
//    {
//        Debug.WriteLine(@"\tERROR {0}", ex.Message);
//        return null;

//    }

//}
//public async Task<MongoTransaction> GetTransactionByToken(string spreedlyToken)
//{
//    try
//    {
//        await CheckTokenAsync();
//        var response = await Constants.JessesUrl.AppendPathSegment("Transactions").PostJsonAsync(spreedlyToken).ReceiveJson<List<MongoTransaction>>();
//        if (response != null)
//        {
//            return response.First();
//        }
//        return new MongoTransaction();

//    }
//    catch (Exception ex)
//    {
//        Debug.WriteLine(@"\tERROR {0}", ex.Message);
//        return new MongoTransaction();

//    }

//}
//public async Task<MongoTransaction> CancelTransaction(MongoTransaction authorizedPayment)
//{
//    try
//    {
//        await CheckTokenAsync();
//        var response = await Constants.JessesUrl.AppendPathSegment("CancelTransaction").PostJsonAsync(authorizedPayment).ReceiveJson<MongoTransaction>();
//        return response;
//    }
//    catch (Exception ex)
//    {
//        Debug.WriteLine(@"\tERROR {0}", ex.Message);
//        return null;

//    }

//}