using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using JessesPizza.Core.Models;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Flurl;
using Flurl.Http;

using JessesPizza.Core.Models.Transactions;
using JessesPizza.Data;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using MongoDB.Bson;
using Swashbuckle.AspNetCore.Annotations;
using MongoDB.Driver;
using Flurl.Http.Xml;
using System.IO;
using System.Xml.Serialization;
using System.Globalization;
using txn = JessesPizza.Core.Models.Transactions.txn;
using Microsoft.Extensions.Options;
using Microsoft.AspNetCore.Authorization;
using System.IdentityModel.Tokens.Jwt;
using Microsoft.IdentityModel.Tokens;
using System.Security.Claims;
using Microsoft.AspNetCore.Identity;
using JessesApi.Areas.Identity.Data;
using JessesPizza.Core.Models.Identity;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using JessesApi.Services;
using static Twilio.Rest.Api.V2010.Account.Call.FeedbackSummaryResource;
using Xamarin.Essentials;

namespace JessesApi.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiVersion("1.0")]
    [ApiController]
    [SwaggerTag("Authorization Related Methods")]
    public class AuthController : ControllerBase
    {
        private readonly ILogger<AuthController> _logger;
        private readonly ICacheService _cache;
        private readonly AppSettings _appSettings;
        public IPizzaRepo _pizzaRepo { get; }
        public UserManager<JessesAppUser> _userManager { get; }
        public SignInManager<JessesAppUser> _signInManager { get; }

        public AuthController(
            ILogger<AuthController> logger,
            IOptions<AppSettings> appSettings,
            IPizzaRepo pizzaRepo,
            UserManager<JessesAppUser> userManager,
            SignInManager<JessesAppUser> signInManager,
            ICacheService cache
            )
        {
            _logger = logger;
            _pizzaRepo = pizzaRepo;
            _userManager = userManager;
            _signInManager = signInManager;
            _cache = cache;
            _appSettings = appSettings.Value;
        }


        #region New Password        
        /// <summary>
        /// Initiates forgot password logic, validates phone number and sends code
        /// </summary>
        [AllowAnonymous]
        [HttpPost("ForgotPassword")]
        [Produces("application/json", Type = typeof(ForgotPasswordResponse))]
        public async Task<IActionResult> ForgotPassword(ForgotPasswordRequest request)
        {
            try
            {
                Serilog.Log.Information($"Entered the ForgotPassword method with request: {request}");
                ForgotPasswordResponse response = new ForgotPasswordResponse();
                var users = _userManager.Users.Where(x => x.PhoneNumber.ToLower() == request.PhoneNumber.ToLower());
                if (!users.Any())
                {
                    Serilog.Log.Information($"No account found for phone number: {request.PhoneNumber}, unable to continue with ForgotPassword");
                    response.Succeeded = false;
                    response.Message = "No account exists with this phone number";
                    return Ok(response);
                }
                else
                {
                    var user = users.FirstOrDefault();
                    var resent = await _cache.GetCacheValue(string.Concat(user.Id.ToString(), "ResentPasswordCodeToUser"));
                    if (resent != null)
                    {
                        if (bool.Parse(resent))
                        {
                            Serilog.Log.Error($"Code sent to user {user.Email} twice");
                            response = new ForgotPasswordResponse()
                                { Succeeded = false, Message = "Code sent too many times, try again later" };
                            return Ok(response);
                        }
                    }
                    response.Succeeded = true;
                    Random generator = new Random();
                    var code = generator.Next(0, 999999).ToString("D6");
                    await _cache.SetCacheValue(string.Concat(user.Id.ToString(), "ResetCode"), code);
                    var settings = await _pizzaRepo.GetSettings();
                    var twilioResponse = await SendText(code, user.PhoneNumber, settings.TwilioAccountSid, settings.TwilioAuthToken, settings.TwilioPhoneNumber);
                    if (twilioResponse)
                    {
                        Serilog.Log.Information($"Successfully sent ForgotPassword text to phone number: {request.PhoneNumber}");
                        return Ok(response);
                    }

                    else
                    {
                        Serilog.Log.Error("Failed to send reset password code");
                        response.Succeeded = false;
                        response.Message="Unable to send reset password code";
                        return Ok(response);

                    }
                }

            }

            catch (Exception exception)
            {
                Serilog.Log.Error(exception, $"Something terrible happened while trying to send ForgotPassword token, because: {exception.Message}");
            }

            return BadRequest("Failed to login");
        }
        /// <summary>
        /// Resends code for new password
        /// </summary>
        [AllowAnonymous]
        [HttpPost("ResendChangePasswordCode")]
        [Produces("application/json", Type = typeof(ResendChangePasswordCodeResponse))]
        public async Task<IActionResult> ResendChangePasswordCode(ResendChangePasswordCodeRequest request)
        {
            try
            {
                Serilog.Log.Information($"Entered the ResendChangePasswordCode method with request: {request}");
                ResendChangePasswordCodeResponse response = new ResendChangePasswordCodeResponse();
                var user = _userManager.Users.Where(x => x.PhoneNumber.ToLower() == request.PhoneNumber.ToLower()).FirstOrDefault();
                if (user == null)
                {
                    Serilog.Log.Information($"No account found for phone number: {request.PhoneNumber}, unable to continue with ResendChangePasswordCode");
                    response.Succeeded = false;
                    response.Message = "No user associated with phonenumber";
                    return Ok(response);
                }
                else
                {
                    var resent = await _cache.GetCacheValue(string.Concat(user.Id.ToString(), "ResentPasswordCodeToUser"));
                    if (resent != null)
                    {
                        if (bool.Parse(resent))
                        {
                            Serilog.Log.Error($"Code sent to user {user.Email} twice");
                             response = new ResendChangePasswordCodeResponse()
                                { Succeeded = false, Message = "Code sent too many times, try again later" };
                            return Ok(response);
                        }
                    }
                    response.Succeeded = true;
                    Random generator = new Random();
                    var code = generator.Next(0, 999999).ToString("D6");
                    await _cache.SetCacheValue(string.Concat(user.Id.ToString(), "ResetCode"), code);
                    await _cache.SetCacheValue(string.Concat(user.Id.ToString(), "ResentPasswordCodeToUser"), "true");
                    var settings = await _pizzaRepo.GetSettings();
                    bool twilioResponse = await SendText(code, user.PhoneNumber, settings.TwilioAccountSid, settings.TwilioAuthToken, settings.TwilioPhoneNumber);
                    if (twilioResponse)
                    {
                        Serilog.Log.Information($"Successfully resent ForgotPasswordCode text to phone number: {request.PhoneNumber}");
                        return Ok(response);
                    }
                    else
                    {
                        Serilog.Log.Error("Failed to resend reset password code in ResendChangePasswordCode");
                        response.Succeeded = false;
                        response.Message = "Unable to resend reset password code";
                        return Ok(response);
                    }
                }

            }

            catch (Exception exception)
            {
                Serilog.Log.Error(exception, $"Something terrible happened while trying to resend ForgotPassword token, because: {exception.Message}");
            }

            return BadRequest(new ResendChangePasswordCodeResponse() { Message = "Failed to resend code", Succeeded = false });
        }
        /// <summary>
        /// Validates code for password change
        /// </summary>
        [AllowAnonymous]
        [HttpPost("ConfirmPasswordChange")]
        [Produces("application/json", Type = typeof(ConfirmPasswordChangeResponse))]
        public async Task<IActionResult> ConfirmPasswordChange(ConfirmPasswordChangeRequest request)
        {
            try
            {
                Serilog.Log.Information($"Entered the ConfirmPasswordChange method with request: {request}");
                ConfirmPasswordChangeResponse response = new ConfirmPasswordChangeResponse();
                var user = _userManager.Users.FirstOrDefault(x => x.PhoneNumber == request.PhoneNumber);
                if (user == null)
                {
                    Serilog.Log.Information($"No account found for phone number: {request.PhoneNumber}, unable to continue with ConfirmPasswordChange");
                    return Ok(new ConfirmAccountResponse() { Message = "No user found", Succeeded = false });
                }
                var code = await _cache.GetCacheValue(string.Concat(user.Id.ToString(), "ResetCode"));
                if (string.IsNullOrEmpty(code))
                {
                    Serilog.Log.Information($"Code expired for phone number: {request.PhoneNumber}, unable to continue with ConfirmPasswordChange");
                    return Ok(new ConfirmAccountResponse() { Message = "Code expired", Succeeded = false });
                }
                if (request.Code != code)
                {
                    Serilog.Log.Information($"Code: {request.Code} did not match code on server: {code} for phone number: {request.PhoneNumber}, unable to continue with ConfirmPasswordChange");
                    return Ok(new ConfirmAccountResponse() { Message = "Wrong code", Succeeded = false });
                }
                Serilog.Log.Information($"Code matched for phone number: {request.PhoneNumber}, exiting ConfirmPasswordChange");
                response.Succeeded = true;
                return Ok(response);
            }

            catch (Exception exception)
            {
                Serilog.Log.Error(exception, "Something terrible happened while confirming account, because: {message}", exception.Message);
            }

            return BadRequest("Failed to login");
        }
        /// <summary>
        /// Validates and sets new password for user and returns token
        /// </summary>
        [AllowAnonymous]
        [HttpPost("NewPassword")]
        [Produces("application/json", Type = typeof(NewPasswordResponse))]
        public async Task<IActionResult> NewPassword(NewPasswordRequest request)
        {
            try
            {
                Serilog.Log.Information($"Entered the NewPassword method with request: {request}");
                NewPasswordResponse response = new NewPasswordResponse();
                var user = _userManager.Users.FirstOrDefault(x => x.PhoneNumber == request.PhoneNumber);
                var passwordValidator = new PasswordValidator<JessesAppUser>();
                var validatePassword = await passwordValidator.ValidateAsync(_userManager, null, request.Password);
                if (!validatePassword.Succeeded)
                {
                    Serilog.Log.Information($"Validation for NewPassword failed with error: {validatePassword.Errors.FirstOrDefault().Description}");
                    response.Succeeded = false;
                    response.Message = validatePassword.Errors.FirstOrDefault().Description;
                    return Ok(response);
                }
                var passwordHasher = new PasswordHasher<JessesAppUser>();
                var newPasswordHash = passwordHasher.HashPassword(user,request.Password);
                user.PasswordHash = newPasswordHash;
                var result = _userManager.UpdateAsync(user);
                if (result.Result == null)
                {
                    Serilog.Log.Error($"UserManager failed to update user:{user} in the NewPassword method");
                    response.Succeeded = false;
                    response.Message = "Something went wrong";
                    return Ok(response);
                }
                if (result.Result.Succeeded)
                {
                    var tokenHandler = new JwtSecurityTokenHandler();
                    var key = Encoding.ASCII.GetBytes(_appSettings.Secret);
                    var tokenDescriptor = new SecurityTokenDescriptor
                    {
                        Subject = new ClaimsIdentity(new Claim[]
                        {
                        new Claim(ClaimTypes.Name, user.Email)

                        }),
                        Expires = DateTime.UtcNow.AddDays(7),
                        SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                    };
                    var token = tokenHandler.CreateToken(tokenDescriptor);
                    response.Token = tokenHandler.WriteToken(token);
                    response.TokenExpires = tokenDescriptor.Expires;
                    response.Succeeded = true;
                    Serilog.Log.Information($"NewPassword created for user: {user}, returning token and exiting method");
                    return Ok(response);
                }
                else 
                {
                    response.Succeeded = false;
                    response.Message = "Something went wrong";
                    return Ok(response);
                }
            }
            catch (Exception e)
            {
                NewPasswordResponse response = new NewPasswordResponse();
                response.Succeeded = false;
                response.Message = "Something went wrong";
                return Ok(response);
            }
        }
        #endregion
        #region SignUp
        /// <summary>
        /// Start of signup flow, makes sure email isn't in use and validates password
        /// </summary>
        [AllowAnonymous]
        [HttpPost("ValidateEmailAddress")]
        [Produces("application/json", Type = typeof(SignUpEmailValidationResponse))]
        public async Task<IActionResult> ValidateEmail(SignUpEmailValidationRequest request)
        {
            try
            {
                Serilog.Log.Information($"Entered the ValidateEmail method with request: {request}");
                SignUpEmailValidationResponse response = new SignUpEmailValidationResponse();
                var users = _userManager.Users;
                var oldUsers = users.Where(x => x.Email.ToLower() == request.Email.ToLower());
                if (oldUsers.Any())
                {
                    Serilog.Log.Information($"User with email already exists: {request.Email}");
                    response.Succeeded = false;
                    response.Message = "User with this email already exists";
                    return Ok(response);
                }
                var passwordValidator = new PasswordValidator<JessesAppUser>();
                var validatePassword = await passwordValidator.ValidateAsync(_userManager, null, request.Password);
                if (validatePassword.Succeeded)
                {
                    Serilog.Log.Information($"Successfully validate email");
                    response.Succeeded = true;
                    return Ok(response);
                }
                else
                {
                    Serilog.Log.Information($"Unable to validate user with request: {request}");
                    response.Succeeded = false;
                    response.Message = validatePassword.Errors.FirstOrDefault().Description;
                    return Ok(response);
                }
            }
            catch (Exception exception)
            {
                Serilog.Log.Error(exception, $"Something terrible happened while signing up user with request {request} in, because: {exception.Message}");
                return StatusCode(500);
            }
        }
        /// <summary>
        /// Authenticates a user
        /// </summary>
        [AllowAnonymous]
        [HttpPost("CreateUser")]
        [Produces("application/json", Type = typeof(SignUpResponse))]
        public async Task<IActionResult> SignUp(SignUpRequest request)
        {
            try
            {
                Serilog.Log.Information($"Entered the CreateUser method with request: {request}");
                SignUpResponse response = new SignUpResponse();
                var newUser = new JessesAppUser(request);
                var users = _userManager.Users;
                var oldUsers = users.Where(x => x.Email.ToLower() == request.Email.ToLower());
                if (oldUsers.Any())
                {
                    Serilog.Log.Information($"User with email address: {request.Email} already exists ");
                    response.Succeeded = false;
                    response.Message = "User with this email already exists";
                    return Ok(response);
                }
                var passwordValidator = new PasswordValidator<JessesAppUser>();
                var validatePassword = await passwordValidator.ValidateAsync(_userManager, null, request.Password);
                if (!validatePassword.Succeeded)
                {
                    Serilog.Log.Information($"Failed to validate password for user: {request.Email}");
                    response.Succeeded = false;
                    response.Message = validatePassword.Errors.FirstOrDefault().Description;
                    return Ok(response);
                }
                var result = _userManager.CreateAsync(newUser, request.Password);
                if (result.Result == null)
                {
                    Serilog.Log.Information($"Failed to create user: {newUser}");
                    response.Succeeded = false;
                    response.Message = "Something went wrong";
                    return Ok(response);
                }
                if (result.Result.Succeeded)
                {
                    response.Succeeded = true;
                    Random generator = new Random();
                    var code = generator.Next(0, 999999).ToString("D6");
                    await _cache.SetCacheValue(string.Concat(newUser.Id.ToString(), "SignUpCode"), code);
                    await _userManager.UpdateAsync(newUser);
                    var settings = await _pizzaRepo.GetSettings();
                    await SendText(code, newUser.PhoneNumber, settings.TwilioAccountSid, settings.TwilioAuthToken, settings.TwilioPhoneNumber);
                    Serilog.Log.Information($"Successfully created user and sent text to: {newUser}");
                    return Ok(response);
                }

            }

            catch (Exception exception)
            {
                Serilog.Log.Error(exception, $"Something terrible happened while signing up user with request {request} in, because: {exception.Message}");
            }
            return BadRequest("Failed to login");

        }
        /// <summary>
        /// Checks code and if successful returns token
        /// </summary>
        //// <returns>JWT Token</returns>
        [AllowAnonymous]
        [HttpPost("ConfirmAccount")]
        [Produces("application/json", Type = typeof(ConfirmAccountResponse))]
        public async Task<IActionResult> ConfirmAccount(ConfirmAccountRequest request)
        {
            try
            {
                Serilog.Log.Information($"Entered the ConfirmAccount method");
                ConfirmAccountResponse response = new ConfirmAccountResponse();
                var user = _userManager.Users.FirstOrDefault(x => x.Email == request.Email);
                var code = await _cache.GetCacheValue(string.Concat(user.Id.ToString(), "SignUpCode"));
                if (user == null)
                {
                    Serilog.Log.Error($"Unable to find a user with email address: {request.Email} in the ConfirmAccount method");
                    return Ok(new ConfirmAccountResponse() { Message = "Something went wrong", Succeeded = false });
                }

                if (string.IsNullOrEmpty(code))
                {
                    Serilog.Log.Error($"Code on server was null in the ConfirmAccount method");
                    return Ok(new ConfirmAccountResponse() { Message = "Unable to confirm account", Succeeded = false });
                }
                if (request.Code != code)
                {
                    Serilog.Log.Information($"Code provided: {request.Code} did not match code on server: {code}");
                    return Ok(new ConfirmAccountResponse() { Message = "Wrong code", Succeeded = false });
                }
                Serilog.Log.Information($"Account confirmation for user: {user.Email} matched code on server");
                user.PhoneNumberConfirmed = true;
                user.AccountVerified = true;
                await _userManager.UpdateAsync(user);
                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.ASCII.GetBytes(_appSettings.Secret);
                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = new ClaimsIdentity(new Claim[]
                    {
                        new Claim(ClaimTypes.Name, user.NormalizedEmail)

                    }),
                    Expires = DateTime.UtcNow.AddDays(7),
                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                };
                var token = tokenHandler.CreateToken(tokenDescriptor);
                response.Token = tokenHandler.WriteToken(token);
                response.TokenExpires = tokenDescriptor.Expires;
                response.Succeeded = true;
                response.Name = user.Info.FirstName;
                return Ok(response);
            }

            catch (Exception exception)
            {
                Serilog.Log.Error(exception, "Something terrible happened while confirming account, because: {message}", exception.Message);
                return BadRequest("Failed to login");
            }

        }
        /// <summary>
        /// Resends code for account confirmation
        /// </summary>
        [AllowAnonymous]
        [HttpPost("ResendSignupCode")]
        [Produces("application/json", Type = typeof(ResendSignupCodeResponse))]
        public async Task<IActionResult> ResendSignupCode(ResendSignupCodeRequest request)
        {
            try
            {
                Serilog.Log.Information($"Entered the ResendSignupCode method");
                ResendSignupCodeResponse response = new ResendSignupCodeResponse();
                var user = _userManager.Users.FirstOrDefault(x => x.Email == request.Email);
                if (user == null)
                {
                    Serilog.Log.Error($"User was null when trying to ResendSignupCode: {request.Email}, did not match any accounts");
                    response.Succeeded = false;
                    response.Message = "No user associated with phonenumber";
                    return Ok(response);
                }
                var resent = await _cache.GetCacheValue(string.Concat(user.Id.ToString(), "ResentCodeToUser"));
                if (resent != null)
                {
                    if (bool.Parse(resent))
                    {
                        Serilog.Log.Information($"Code sent to user {user.Email} twice");
                        response.Succeeded = false;
                        response.Message = "Code sent too many times, try again later";
                        return Ok(response);
                    }
                }
                response.Succeeded = true;
                Random generator = new Random();
                var code = generator.Next(0, 999999).ToString("D6");
                await _cache.SetCacheValue(string.Concat(user.Id.ToString(), "SignUpCode"), code);
                await _cache.SetCacheValue(string.Concat(user.Id.ToString(), "ResentCodeToUser"), "true");
                var settings = await _pizzaRepo.GetSettings();
                bool twilioResponse = await SendText(code, user.PhoneNumber, settings.TwilioAccountSid, settings.TwilioAuthToken, settings.TwilioPhoneNumber);
                if (twilioResponse) 
                {
                    Serilog.Log.Information($"Code resent succesfully, exiting ResendSignupCode");
                    return Ok(response);
                }
                Serilog.Log.Error("Failed to resend signup code password code");
                response.Succeeded = false;
                response.Message = "Unable to send signup code";
                return Ok(response);
            }
            catch (Exception exception)
            {
                Serilog.Log.Error(exception, "Something terrible happened while logging in, because: {message}", exception.Message);
                return BadRequest(new ResendChangePasswordCodeResponse() { Message = "Failed to resend code", Succeeded = false });
            }
        }
        #endregion

        #region SignIn
        /// <summary>
        /// Authenticates a user
        /// </summary>
        /// <remarks>
        /// Sample request:
        ///
        ///     POST /UserLogin
        ///     {
        ///        "email": blah@gmail.com,
        ///        "password": "P@ssw00rd",
        ///        "deviceid": "0000"
        ///     }
        ///
        /// </remarks>
        /// <param name="request"></param>
        /// <returns>A newly created Token for the user</returns>
        /// <response code="200">Returns the newly created token</response>
        /// <response code="400">If the credentials are wrong</response>      
        [AllowAnonymous]
        [HttpPost("UserLogin")]
        [Produces("application/json", Type = typeof(string))]
        public async Task<IActionResult> UserLogin(LoginRequest request)
        {
            try
            {
                Serilog.Log.Information($"Entered the User login method");
                var tokenHandler = new JwtSecurityTokenHandler();
                var user = _userManager.Users.FirstOrDefault(x => x.Email.ToLower() == request.Email.ToLower());
                if (user == null)
                {
                    Serilog.Log.Information($"User was null for the request: {0}", request);
                    return Ok(new LoginResponse() { Message = "Invalid username or password", Succeeded = false });
                }
                if (string.IsNullOrEmpty(request.Password))
                {
                    Serilog.Log.Information($"Password was null for the request: {0}", request);
                    return Ok(new LoginResponse() { Message = "Invalid username or password", Succeeded = false });
                }
                var result = await _userManager.CheckPasswordAsync(user, request.Password);

                if (result)
                {
                    var key = Encoding.ASCII.GetBytes(_appSettings.Secret);
                    var tokenDescriptor = new SecurityTokenDescriptor
                    {
                        Subject = new ClaimsIdentity(new Claim[]
                        {
                        new Claim(ClaimTypes.Name, user.NormalizedEmail)

                        }),
                        Expires = DateTime.UtcNow.AddMonths(6),
                        SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                    };
                    var token = tokenHandler.CreateToken(tokenDescriptor);
                    Serilog.Log.Information($"{user.Email} logged in and received a token");
                    if (!user.AccountVerified)
                    {
                        var resent = await _cache.GetCacheValue(string.Concat(user.Id.ToString(), "ResentCodeToUser"));
                        if (resent != null)
                        {
                            if (bool.Parse(resent))
                            {
                                Serilog.Log.Information($"Code sent to user {user} twice");
                                var response = new LoginResponse()
                                    { Succeeded = false, AccountConfirmed = false, Message = "Try again later" };
                                return Ok(response);
                            }
                        }
                        Random generator = new Random();
                        var code = generator.Next(0, 999999).ToString("D6");
                        await _cache.SetCacheValue(string.Concat(user.Id.ToString(), "SignUpCode"), code);
                        var settings = await _pizzaRepo.GetSettings();
                        await SendText(code, user.PhoneNumber, settings.TwilioAccountSid, settings.TwilioAuthToken, settings.TwilioPhoneNumber);
                        Serilog.Log.Information($"Successfully sent text to user: {0}", user);

                    }
                    return Ok(new LoginResponse() { Succeeded = true, Token = tokenHandler.WriteToken(token), TokenExpires = tokenDescriptor.Expires , Name=user.Info.FirstName,AccountConfirmed = user.AccountVerified});
                }
                else
                {
                    Serilog.Log.Information($"{0} tried to log in with an invalid password, returning", user);
                    return Ok(new LoginResponse() { Succeeded = false, Message = "Invalid username or password" });
                }
            }

            catch (Exception exception)
            {
                Serilog.Log.Error(exception, "Something terrible happened while logging in, because: {message}", exception.Message);
            }
            return BadRequest("Failed to login");
        }

        /// <summary>
        /// Guest login
        /// </summary>
        //// <returns>JWT Token</returns>
        [AllowAnonymous]
        [HttpPost("GuestLogin")]
        [Produces("application/json", Type = typeof(GuestLoginResponse))]
        public async Task<IActionResult> GuestLogin(GuestLoginRequest request)
        {
            try
            {
                Serilog.Log.Information($"Entered the GuestLogin method");
                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.ASCII.GetBytes(_appSettings.Secret);
                if (request.Secret == _appSettings.Secret)
                {
                    //var locs= JsonConvert.SerializeObject(otmAppUser.UserLocations);
                    var tokenDescriptor = new SecurityTokenDescriptor
                    {
                        Subject = new ClaimsIdentity(new Claim[]
                        {
                        new Claim(ClaimTypes.Name, "Guest")

                        }),
                        Expires = DateTime.UtcNow.AddMonths(6),
                        SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                    };
                    var token = tokenHandler.CreateToken(tokenDescriptor);
                    AppUser user = new AppUser();
                    user.Token = tokenHandler.WriteToken(token);
                    user.TokenExpires = tokenDescriptor.Expires;
                    user.IsGuest = true;
                    //Serilog.Log.Error("{@AppUser} logged in and received a token", user);
                    return Ok(user);
                }
                Serilog.Log.Information($"Secret provided did not match app-settings, exiting GuestLogin");
                return Unauthorized();
            }

            catch (Exception exception)
            {
                Serilog.Log.Error(exception, "Something terrible happened while logging in, because: {message}", exception.Message);
            }
            return BadRequest("Failed to login");
        }
        /// <summary>
        /// Delete a user account
        /// </summary>
        [HttpPost("DeleteAccount")]
        [Produces("application/json", Type = typeof(DeleteAccountResponse))]
        public async Task<IActionResult> DeleteAccount(DeleteAccountRequest request)
        {
            try
            {
                Serilog.Log.Information($"Entered the DeleteAccount method");
                string email = User.FindFirst(ClaimTypes.Name)?.Value;
                if (string.IsNullOrEmpty(email))
                {
                    Serilog.Log.Error($"Email provided for DeleteAccount was null or empty");
                    return NotFound();
                }
                JessesAppUser user = _userManager.Users.FirstOrDefault(x => x.NormalizedEmail == email.ToUpper());
                if (user == null)
                {
                    Serilog.Log.Error($"User came back as null in the DeleteAccount Method");
                    return Ok(new DeleteAccountResponse() { Succeeded = false, Message = "Unable to delete account" });
                }
                var result = await _userManager.DeleteAsync(user);
                if (result.Succeeded)
                {
                    Serilog.Log.Information($"Successfully deleted account: {user}");
                    return Ok(new DeleteAccountResponse() { Succeeded = true });
                }
                Serilog.Log.Error($"User manager failed to delete account in the DeleteAccount Method");
                return Ok(new DeleteAccountResponse() { Succeeded = false, Message = "Unable to delete account" });
            }

            catch (Exception exception)
            {
                Serilog.Log.Error(exception, "Something terrible happened while logging in, because: {message}", exception.Message);
            }

            return BadRequest("Failed to login");
        }
        #endregion

        private async Task<bool> SendText(string text, string phoneNumber, string accountSid, string authToken, string twilioPhoneNumber)
        {
            try
            {
                TwilioClient.Init(accountSid, authToken);
                var message = MessageResource.Create(
                body: $"Your verifaction code for Jesse's Pizza mobile app is {text}",
                from: new Twilio.Types.PhoneNumber(twilioPhoneNumber),
                to: new Twilio.Types.PhoneNumber(phoneNumber)
                );
                if (message.Status == StatusEnum.Failed)
                    return false;
                else
                    return true;
            }
            catch (Exception e)
            {
                Serilog.Log.Error("Unable to send SMS, because: {ExceptionMessage}", e);
                return false;
            }
        }

        //[AllowAnonymous]
        //[HttpGet("TestMessage")]
        //[Produces("application/json")]
        //public async Task<IActionResult> TestTextMessage()
        //{
        //    try
        //    {
        //        var settings = await _pizzaRepo.GetSettings();
        //        var succeded = SendText("TestMessage", "9515950240", settings.TwilioAccountSid, settings.TwilioAuthToken,
        //            settings.TwilioPhoneNumber);


        //        return Ok();
        //    }
        //    catch (Exception e)
        //    {
        //        Console.WriteLine(e);
        //        return StatusCode(500);
        //    }
        //}
    }
}