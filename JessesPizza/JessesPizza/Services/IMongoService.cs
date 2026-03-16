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
    public interface IMongoService
    {
        #region MenuItems
        Task<List<MainMenuItem>> GetMainMenuItemsAsync();
        Task<List<Group>> GetGroupsAsync();
        #endregion

        #region Transactions
        Task<MongoTransactionV1_1> GetTransactionByGuid(Guid transactionGuid);
        Task<MongoTransaction> CancelTransaction(MongoTransaction authorizedPayment);
        Task<MongoTransaction> UpdateTransaction(MongoTransaction authorizedPayment);
        Task<TransactionValidationResponse> ValidateTransaction(LocalTransactionV1_1 transaction);
        Task<TransactionValidationResponse> ValidateTransactionAmount(decimal amount);

        Task<MongoTransactionV1_1> GetHPPTokenAsync(LocalTransactionV1_1 localTransaction);
        #endregion
        #region Settings/Misc
        Task<JessesPizzaSettings> GetSettings();
        Task<string> GetPrivacyPolicyAsync();
        Task<bool> CheckHoursAsync();

        #endregion
        #region SignUp
        Task<SignUpEmailValidationResponse> ValidateEmailAddressAsync(string emailAddress, string password);

        Task<SignUpResponse> CreateUser(SignUpRequest request);
        Task<ConfirmAccountResponse> ConfirmAccount(ConfirmAccountRequest request);
        Task<ResendSignupCodeResponse> ResendSignupCode(ResendSignupCodeRequest request);
        #endregion
        #region SignIn
        Task<LoginResponse> Login(LoginRequest request);
        #endregion
        #region ChangePassword
        Task<ForgotPasswordResponse> ForgotPassword(ForgotPasswordRequest request);
        Task<DeleteAccountResponse> DeleteAccount(DeleteAccountRequest request);
        Task<ConfirmPasswordChangeResponse> ConfirmPasswordChange(ConfirmPasswordChangeRequest request);
        Task<NewPasswordResponse> UpdatePassword(NewPasswordRequest request);
        Task<ResendChangePasswordCodeResponse> ResendChangePasswordCode(ResendChangePasswordCodeRequest request);
        #endregion
        #region Guest
        Task<GuestLoginResponse> GuestLogin(GuestLoginRequest request);
        #endregion
        Task<bool> SaveCreditCard(CreditCard request);

        Task<GetCreditCardsResponse> GetCreditCards(GetCreditCardsRequest request);
        Task<GetAddressesResponse> GetAddresses(GetAddressesRequest request);
        Task<bool> UpdateAddress(Address request);
        Task<bool> AddNewAddress(Address request);
        Task<PostTransactionResponse> PostTransaction(PostTransactionRequestV1_1 request);
        Task<SaveAddressResponse> SaveAddress(SaveAddressRequest request);
        Task<DeleteAddressResponse> DeleteAddress(DeleteAddressRequest request);
        Task<DeleteCreditCardResponse> DeleteCreditCard(DeleteCreditCardRequest request);
        Task<GetAccountInfoResponse> GetAccountInfo();
    }
}
