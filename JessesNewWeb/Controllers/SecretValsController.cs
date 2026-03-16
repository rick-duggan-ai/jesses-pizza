using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
using MongoDB.Bson;
// using MongoDB.Driver.Builders;
using JessesNewWeb.Models;

namespace JessesNewWeb.Controllers
{
    public class SecretValsController : Controller
    {
        private const string mConn = "mongodb+srv://jesses:rwguMF0CSr01x3wD@jesses-sandbox-ndqtx.mongodb.net/test?retryWrites=true&w=majority";
        private readonly ILogger<SecretValsController> _logger;

        public SecretValsController(ILogger<SecretValsController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            string tok = Environment.GetEnvironmentVariable("API_TOKEN");
            return Ok($"token is {tok}");
        }   

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
