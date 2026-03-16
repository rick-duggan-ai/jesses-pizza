using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net;
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
using JessesPizza.Models;
using JessesPizza.Views;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.Linq;
using Newtonsoft.Json;
using Xamarin.Essentials;
using Xamarin.Forms;

namespace JessesPizza.Services
{
    public class MongoService : IMongoService
    {
        readonly HttpClient _client;
        public List<JessesMenuItem> MenuItems { get; private set; }
        public List<MainMenuItem> MainMenuItems { get; private set; }
        public List<Group> Groups { get; private set; }
        public JessesPizzaSettings Info { get; private set; }


        public AppUser User { get; set; }
        public MongoService()
        {
            _client = new HttpClient();
            _client.BaseAddress = new Uri(Constants.BaseAddress);
        }

        private async Task<bool> CheckTokenAsync()
        {
            if (User == null)
            {
                var oauthToken = await SecureStorage.GetAsync("oauth_token");
                var oauthTokenExpiration = await SecureStorage.GetAsync("oauth_token_expiration");
                var oauthTokenIsGuest = await SecureStorage.GetAsync("oauth_token_is_guest");
                if (!string.IsNullOrEmpty(oauthToken) && !string.IsNullOrEmpty(oauthTokenExpiration) && !string.IsNullOrEmpty(oauthTokenIsGuest))
                    User = new AppUser() { IsGuest = bool.Parse(oauthTokenIsGuest), Token = oauthToken, TokenExpires = DateTime.Parse(oauthTokenExpiration) };
            }
            if (User == null)
            {
                SecureStorage.RemoveAll();
                App.Current.MainPage = new NavigationPage(new HomeScreen());
                return false;
            }
            if (string.IsNullOrEmpty(User.Token) || User.TokenExpires == null)
            {
                SecureStorage.RemoveAll();
                App.Current.MainPage = new NavigationPage(new HomeScreen());
                return false;
            }
            if (User.TokenExpires < DateTime.UtcNow)
            {
                SecureStorage.RemoveAll();
                App.Current.MainPage = new NavigationPage(new HomeScreen());
                return false;
            }
            return true;
        }
        #region Transactions

        public async Task<MongoTransaction> CancelTransaction(MongoTransaction authorizedPayment)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.TransactionsApiUrl.AppendPathSegment("CancelTransaction")
                    .WithOAuthBearerToken(User.Token).PostJsonAsync(authorizedPayment).ReceiveJson<MongoTransaction>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());

                }
                return null;
            }
            catch (Exception ex)
            {

                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;

            }


        }
        public async Task<MongoTransactionV1_1> GetTransactionByGuid(Guid transactionGuid)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.TransactionsApiUrl.AppendPathSegment("TransactionGuid").WithHeader("X-Version","1.1").WithOAuthBearerToken(User.Token).SetQueryParams(new
                {
                    transactionGuid = new Guid(transactionGuid.ToString())
                }).GetJsonAsync<MongoTransactionV1_1>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
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
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.TransactionsApiUrl.AppendPathSegment("UpdateTransaction").WithOAuthBearerToken(User.Token).PostJsonAsync(authorizedPayment).ReceiveJson<MongoTransaction>();
                if (response != null)
                {
                    return response;
                }
                return new MongoTransaction();

            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return new MongoTransaction();

            }

        }

        public async Task<TransactionValidationResponse> ValidateTransaction(LocalTransactionV1_1 transaction)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null; var response = await Constants.TransactionsApiUrl.AppendPathSegment("ValidateTransaction").WithHeader("X-Version", "1.1").WithOAuthBearerToken(User.Token).PostJsonAsync(transaction).ReceiveJson<TransactionValidationResponse>();
                if (response.Succeeded)
                {
                    return new TransactionValidationResponse() { TransactionGuid = response.TransactionGuid, Succeeded = true };

                }
                return new TransactionValidationResponse() { Succeeded = false, Message = response.Message };
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return new TransactionValidationResponse() { Succeeded = false, Message = "Something went wrong"};

            }

        }
        public async Task<TransactionValidationResponse> ValidateTransactionAmount(decimal amount)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.TransactionsApiUrl.AppendPathSegment("ValidateTransactionAmount").WithOAuthBearerToken(User.Token).PostJsonAsync(amount).ReceiveJson<TransactionValidationResponse>();
                if (response.Succeeded)
                {
                    return new TransactionValidationResponse() { TransactionGuid = response.TransactionGuid, Succeeded = true };

                }
                return new TransactionValidationResponse() { Succeeded = false, Message = response.Message };
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return new TransactionValidationResponse() { Succeeded = false };

            }
        }
        public async Task<MongoTransactionV1_1> GetHPPTokenAsync(LocalTransactionV1_1 localTransaction)
        {

            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.TransactionsApiUrl.AppendPathSegment("GetHPPToken").WithOAuthBearerToken(User.Token).WithHeader("X-Version","1.1").PostJsonAsync(localTransaction).ReceiveJson<MongoTransactionV1_1>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
            }

            return null;
        }



        #endregion

        #region MenuItems
        public async Task<List<Group>> GetGroupsAsync()
        {
            Groups = new List<Group>();

            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.MenuItemsApiUrl.AppendPathSegment("Groups").WithOAuthBearerToken(User.Token).GetJsonAsync<List<Group>>();
                if (response != null)
                {
                    Groups = response;
                }
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
            }

            return Groups;
        }

        public async Task<List<MainMenuItem>> GetMainMenuItemsAsync()
        {
            MainMenuItems = new List<MainMenuItem>();

            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null; var mainMenuItems = await Constants.MenuItemsApiUrl.AppendPathSegment("MainMenuItems").WithOAuthBearerToken(User.Token).GetJsonAsync<List<MainMenuItem>>();
                if (mainMenuItems.Any())
                    MainMenuItems = mainMenuItems;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
            }

            return MainMenuItems;
        }
        #endregion

        #region Settings

        public async Task<JessesPizzaSettings> GetSettings()
        {
            Info = new JessesPizzaSettings();

            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var info = await Constants.SettingsApiUrl.AppendPathSegment("OrderInfo").WithOAuthBearerToken(User.Token).GetJsonAsync<JessesPizzaSettings>();
                if (info != null)
                    Info = info;
                else
                    return null;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
            }

            return Info;
        }
        public async Task<string> GetPrivacyPolicyAsync()
        {
            try
            {
                var privacy = await Constants.SettingsApiUrl.AppendPathSegment("Privacy").GetStringAsync();
                if (privacy != null)
                    return privacy;
                else
                    return null;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }

        }

        public async Task<bool> CheckHoursAsync()
        {
            try
            {
                var checkToken = await CheckTokenAsync();
                if (!checkToken)
                    return false;
                var response = await Constants.AuthApiUrl.AppendPathSegment("ResendSignupCode").WithOAuthBearerToken(User.Token).GetJsonAsync<bool>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return false;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return false;
            }
        }
        #endregion

        #region Identity

        #region SignUp
        public async Task<SignUpEmailValidationResponse> ValidateEmailAddressAsync(string emailAddress, string password)
        {
            try
            {
                var blah = new SignUpEmailValidationRequest() { Email = emailAddress, Password = password };
                var response = await Constants.AuthApiUrl.AppendPathSegment("/ValidateEmailAddress").PostJsonAsync(blah).ReceiveJson<SignUpEmailValidationResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }

        public async Task<SignUpResponse> CreateUser(SignUpRequest request)
        {
            try
            {
                var response = await Constants.AuthApiUrl.AppendPathSegment("/CreateUser").PostJsonAsync(request).ReceiveJson<SignUpResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }
        public async Task<ConfirmAccountResponse> ConfirmAccount(ConfirmAccountRequest request)
        {
            try
            {
                var response = await Constants.AuthApiUrl.AppendPathSegment("ConfirmAccount").PostJsonAsync(request).ReceiveJson<ConfirmAccountResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }
        public async Task<ResendSignupCodeResponse> ResendSignupCode(ResendSignupCodeRequest request)
        {
            try
            {
                var response = await Constants.AuthApiUrl.AppendPathSegment("ResendSignupCode").PostJsonAsync(request).ReceiveJson<ResendSignupCodeResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }
        #endregion

        #region SignIn
        public async Task<LoginResponse> Login(LoginRequest request)
        {
            try
            {
                var response = await Constants.AuthApiUrl.AppendPathSegment("UserLogin").PostJsonAsync(request).ReceiveJson<LoginResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }
        #endregion

        #region Guest
        public async Task<GuestLoginResponse> GuestLogin(GuestLoginRequest request)
        {
            try
            {
                var response = await Constants.AuthApiUrl.AppendPathSegment("GuestLogin").PostJsonAsync(request).ReceiveJson<GuestLoginResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }
        #endregion

        #region ChangePassword
        public async Task<ForgotPasswordResponse> ForgotPassword(ForgotPasswordRequest request)
        {
            try
            {
                var response = await Constants.AuthApiUrl.AppendPathSegment("ForgotPassword").PostJsonAsync(request).ReceiveJson<ForgotPasswordResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }

        public async Task<ConfirmPasswordChangeResponse> ConfirmPasswordChange(ConfirmPasswordChangeRequest request)
        {
            try
            {
                var response = await Constants.AuthApiUrl.AppendPathSegment("ConfirmPasswordChange").PostJsonAsync(request).ReceiveJson<ConfirmPasswordChangeResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }

        public async Task<NewPasswordResponse> UpdatePassword(NewPasswordRequest request)
        {
            try
            {
                var response = await Constants.AuthApiUrl.AppendPathSegment("NewPassword").PostJsonAsync(request).ReceiveJson<NewPasswordResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }

        public async Task<ResendChangePasswordCodeResponse> ResendChangePasswordCode(ResendChangePasswordCodeRequest request)
        {
            try
            {
                var response = await Constants.AuthApiUrl.AppendPathSegment("ResendChangePasswordCode").PostJsonAsync(request).ReceiveJson<ResendChangePasswordCodeResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }
        #endregion
        public async Task<GetOrdersResponse> GetOrders()
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.AccountApiUrl.AppendPathSegment("GetOrders").WithHeader("X-Version","1.1").WithOAuthBearerToken(User.Token).GetAsync().ReceiveJson<GetOrdersResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }
        public async Task<GetCreditCardsResponse> GetCreditCards(GetCreditCardsRequest request)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.TransactionsApiUrl.AppendPathSegment("CreditCards").WithOAuthBearerToken(User.Token).GetAsync().ReceiveJson<GetCreditCardsResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }
        public async Task<bool> SaveCreditCard(CreditCard request)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return false;
                var response = await Constants.TransactionsApiUrl.AppendPathSegment("SaveCreditCard").WithOAuthBearerToken(User.Token).PostJsonAsync(request).ReceiveJson<bool>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return false;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return false;
            }
        }
        public async Task<GetAddressesResponse> GetAddresses(GetAddressesRequest request)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.AccountApiUrl.AppendPathSegment("Addresses").WithOAuthBearerToken(User.Token).GetAsync().ReceiveJson<GetAddressesResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }

        public async Task<bool> UpdateAddress(Address request)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return false;
                var response = await Constants.AccountApiUrl.AppendPathSegment("UpdateAddress").WithOAuthBearerToken(User.Token).PostJsonAsync(request).ReceiveJson<bool>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return false;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return false;
            }
        }

        public async Task<bool> AddNewAddress(Address request)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return false;
                var response = await Constants.AccountApiUrl.AppendPathSegment("AddNewAddress").WithOAuthBearerToken(User.Token).PostJsonAsync(request).ReceiveJson<bool>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return false;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return false;
            }
        }
        public async Task<SaveAddressResponse> SaveAddress(SaveAddressRequest request)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return new SaveAddressResponse() { Message = "Authentication failed", Succeeded = false };
                var response = await Constants.AccountApiUrl.AppendPathSegment("SaveAddress").WithOAuthBearerToken(User.Token).PostJsonAsync(request).ReceiveJson<SaveAddressResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return new SaveAddressResponse() { Message = "Something went wrong", Succeeded = false };
            }
        }
        public async Task<PostTransactionResponse> PostTransaction(PostTransactionRequestV1_1 request)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.TransactionsApiUrl.AppendPathSegment("PostTransaction").WithHeader("X-Version","1.1").WithOAuthBearerToken(User.Token).PostJsonAsync(request).ReceiveJson<PostTransactionResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }

        public async Task<DeleteAddressResponse> DeleteAddress(DeleteAddressRequest request)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.AccountApiUrl.AppendPathSegment("DeleteAddress").WithOAuthBearerToken(User.Token).PostJsonAsync(request).ReceiveJson<DeleteAddressResponse>();
                return response;
            }

            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }

        public async Task<DeleteCreditCardResponse> DeleteCreditCard(DeleteCreditCardRequest request)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.TransactionsApiUrl.AppendPathSegment("DeleteCard").WithOAuthBearerToken(User.Token).PostJsonAsync(request).ReceiveJson<DeleteCreditCardResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }

        public async Task<DeleteAccountResponse> DeleteAccount(DeleteAccountRequest request)
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.AuthApiUrl.AppendPathSegment("DeleteAccount").WithOAuthBearerToken(User.Token).PostJsonAsync(request).ReceiveJson<DeleteAccountResponse>();
                return response;
            }
            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }

        public async Task<GetAccountInfoResponse> GetAccountInfo()
        {
            try
            {
                var tokenCheck = await CheckTokenAsync();
                if (!tokenCheck)
                    return null;
                var response = await Constants.AccountApiUrl.AppendPathSegment("GetAccountInfo").WithOAuthBearerToken(User.Token).GetAsync().ReceiveJson<GetAccountInfoResponse>();
                return response;
            }

            catch (FlurlHttpException ex)
            {
                if (ex.Call.HttpStatus == HttpStatusCode.Forbidden || ex.Call.HttpStatus == HttpStatusCode.Unauthorized)
                {
                    SecureStorage.RemoveAll();
                    App.Current.MainPage = new NavigationPage(new HomeScreen());
                }
                return null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(@"\tERROR {0}", ex.Message);
                return null;
            }
        }

        #endregion
    }
}
