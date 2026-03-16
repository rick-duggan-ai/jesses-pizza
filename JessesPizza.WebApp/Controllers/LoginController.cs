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

using JessesPizza.Core.Models.Transactions;
using JessesPizza.Data;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Logging;
using MongoDB.Bson;
using MongoDB.Driver;
using Microsoft.AspNetCore.Http;
using System.IO;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using JessesPizza.Core.Models.Identity;

namespace JessesPizza.MobileAppService.Controllers
{
    public class LoginController : Controller
    {
        private readonly IPizzaRepo _pizzaRepo;
        private readonly SignInManager<IdentityUser> _signInManager;
        public LoginController(SignInManager<IdentityUser> signInManager, IPizzaRepo pizzaRepo)
        {
            _pizzaRepo = pizzaRepo;
            _signInManager = signInManager;

        }

        [AllowAnonymous]
        [HttpPost("login")]
        [Produces("application/json")]
        public async Task<IActionResult> Login([FromBody]KDSUser user)
        {
            try { 
            var result = await _signInManager.PasswordSignInAsync(user.Username, user.Password, false, lockoutOnFailure: false);
            if (result.Succeeded)
                return Ok();
            else
                return StatusCode(403);
            }
            catch (Exception e)
            {
                return Forbid();
            }
        }
    }
}