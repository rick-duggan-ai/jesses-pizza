using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using JessesPizza.Core.Models.Identity;
using JessesPizza.Core.Models.Transactions;
using JessesPizza.Models;

namespace JessesPizza.Services
{
    public class MenuItemManager
    {
        public IMongoService _mongoService;

        public MenuItemManager(IMongoService mongoService)
        {
            _mongoService = mongoService;
        }

        //Retrieves settings from Mongo
        public async Task<JessesPizzaSettings> GetOrderInfoAsync()
        {
            return await _mongoService.GetSettings();
        }

        //Retrieves list of Jesse's menu items
        public async Task<List<MainMenuItem>> GetMainMenuItemsAsync()
        {
            return await _mongoService.GetMainMenuItemsAsync();
        }

        //Retrieves list of Groups 
        public async Task<List<Group>> GetGroupDataAsync()
        {
            return await _mongoService.GetGroupsAsync();
        }

        //Retrieves privacy policy
        public async Task<string> GetPrivacyAsync()
        {
            return await _mongoService.GetPrivacyPolicyAsync();
        }
        public async Task<bool> CheckHoursAsync()
        {
            return await _mongoService.CheckHoursAsync();
        }
        #region Identity
        public async Task<SignUpEmailValidationResponse> ValidateEmailAddress(string emailAddress,string password)
        {
            return await _mongoService.ValidateEmailAddressAsync(emailAddress, password);
        }

        public async Task<DeleteAccountResponse> DeleteAccount(DeleteAccountRequest request)
        {
            return await _mongoService.DeleteAccount(request);
        }

        public async Task<SignUpResponse> CreateUser(SignUpRequest request)
        {
            return await _mongoService.CreateUser(request);
        }

        public async Task<ConfirmAccountResponse> ConfirmAccount(ConfirmAccountRequest request)
        {
            return await _mongoService.ConfirmAccount(request);
        }
        public async Task<LoginResponse> Login(LoginRequest request)
        {
            return await _mongoService.Login(request);
        }
        public async Task<GuestLoginResponse> GuestLogin(GuestLoginRequest request)
        {
            return await _mongoService.GuestLogin(request);
        }
        public async Task<ForgotPasswordResponse> ForgotPassword(ForgotPasswordRequest request)
        {
            return await _mongoService.ForgotPassword(request);
        }
        public async Task<ConfirmPasswordChangeResponse> ConfirmPasswordChange(ConfirmPasswordChangeRequest request)
        {
            return await _mongoService.ConfirmPasswordChange(request);
        }
        public async Task<NewPasswordResponse> UpdatePassword(NewPasswordRequest request)
        {
            return await _mongoService.UpdatePassword(request);
        }

        public async Task<ResendChangePasswordCodeResponse> ResendChangePasswordCode(ResendChangePasswordCodeRequest request)
        {
            return await _mongoService.ResendChangePasswordCode(request);
        }

        public async Task<ResendSignupCodeResponse> ResendSignupCode(ResendSignupCodeRequest request)
        {
            return await _mongoService.ResendSignupCode(request);
        }

        internal async Task<GetAccountInfoResponse> GetAccountInfo()
        {
            return await _mongoService.GetAccountInfo();
        }

        public async Task<GetCreditCardsResponse> GetCreditCards(GetCreditCardsRequest request)
        {
            return await _mongoService.GetCreditCards(request);
        }
        public async Task<bool> SaveCreditCard(CreditCard request)
        {
            return await _mongoService.SaveCreditCard(request);
        }
        public async Task<DeleteCreditCardResponse> DeleteCreditCard(DeleteCreditCardRequest request)
        {
            return await _mongoService.DeleteCreditCard(request);
        }
        public async Task<GetAddressesResponse> GetAddresses(GetAddressesRequest request)
        {
            return await _mongoService.GetAddresses(request);
        }
        public async Task<bool> UpdateAddress(Address request)
        {
            return await _mongoService.UpdateAddress(request);
        }
        public async Task<bool> AddNewAddress(Address request)
        {
            return await _mongoService.AddNewAddress(request);
        }
        public async Task<DeleteAddressResponse> DeleteAddress(DeleteAddressRequest request)
        {
            return await _mongoService.DeleteAddress(request);
        }
        public async Task<SaveAddressResponse> SaveAddress(SaveAddressRequest request)
        {
            return await _mongoService.SaveAddress(request);
        }
        public async Task<TransactionValidationResponse> ValidateTransaction(LocalTransactionV1_1 localTransaction)
        {
            return await _mongoService.ValidateTransaction(localTransaction);
        }

        public async Task<MongoTransactionV1_1> GetHPPToken(LocalTransactionV1_1 localTransaction)
        {
            return await _mongoService.GetHPPTokenAsync(localTransaction);
        }
        public async Task<TransactionValidationResponse> ValidateTransactionAmount(decimal amount)
        {
            return await _mongoService.ValidateTransactionAmount(amount);
        }

        public async Task<PostTransactionResponse> PostTransaction(PostTransactionRequestV1_1 request)
        {
            return await _mongoService.PostTransaction(request);
        }
        #endregion
    }
}
