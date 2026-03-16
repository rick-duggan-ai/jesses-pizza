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

namespace JessesPizza.MobileAppService.Controllers
{
    [Authorize]
    [Route("api/[controller]")]
    [ApiVersion("1.0")]
    [ApiController]
    [SwaggerTag("Authorization Related Methods")]
    public class AuthController : ControllerBase
    {
        private readonly ILogger<AuthController> _logger;
        private readonly AppSettings _appSettings;
        public AuthController(
            ILogger<AuthController> logger,
            IOptions<AppSettings> appSettings)
        {
            _logger = logger;
            _appSettings = appSettings.Value;
        }
        /// <summary>
        /// Authenticates a user
        /// </summary>
        //// <returns>JWT Token</returns>
        [AllowAnonymous]
        [HttpPost("Login")]
        [Produces("application/json", Type = typeof(AppUser))]
        public async Task<IActionResult> Login(AppSecret appSecret)
        //public async Task<IActionResult> Login([FromHeader] Credential credential)
        {
            try
            {
                var tokenHandler = new JwtSecurityTokenHandler();
                var key = Encoding.ASCII.GetBytes(_appSettings.Secret);
                if (appSecret.Secret == _appSettings.Secret)
                {
                    //var locs= JsonConvert.SerializeObject(otmAppUser.UserLocations);
                    var tokenDescriptor = new SecurityTokenDescriptor
                    {
                        Subject = new ClaimsIdentity(new Claim[]
                        {
                        new Claim(ClaimTypes.Name, "")

                        }),
                        Expires = DateTime.UtcNow.AddDays(7),
                        SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                    };
                    var token = tokenHandler.CreateToken(tokenDescriptor);
                    AppUser user = new AppUser();
                    user.Token = tokenHandler.WriteToken(token);
                    user.TokenExpires = tokenDescriptor.Expires;
                    //_logger.LogInformation($"{userName} logged in and received a token");
                    return Ok(user);
                }
                else
                    return Unauthorized();
            }

            catch (Exception exception)
            {
                _logger.LogError(exception, "Something terrible happened while logging in, because: {message}", exception.Message);
            }

            return BadRequest("Failed to login");
        }

    }
}