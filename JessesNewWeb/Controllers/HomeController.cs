using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;
using MongoDB.Bson;
// using MongoDB.Driver.Builders;
using JessesNewWeb.Models;

namespace JessesNewWeb.Controllers
{

    public class HomeController : Controller
    {
        private const string mConn = "mongodb+srv://jesses:rwguMF0CSr01x3wD@jesses-sandbox-ndqtx.mongodb.net/test?retryWrites=true&w=majority";
        private readonly ILogger<HomeController> _logger;

        public HomeController(ILogger<HomeController> logger)
        {
            _logger = logger;
        }

        public IActionResult Index()
        {
            MongoClient dbClient = new MongoClient(mConn);

            var db = dbClient.GetDatabase("JessesPizzaDB");
            // dbClient.RequestStart(db);
            var coll = db.GetCollection<dbOrder>("TransactionsV1_1");

            // get the list of numbers we have already sent to today 
            var coll2 = db.GetCollection<OrderReady>("TextMessages");
            var lExclude = coll2.Find(x => x.date > DateTime.Now.AddHours(-24)).ToList();

            Dictionary<string, string> sentMsg = new Dictionary<string, string>();
            foreach(var ord in lExclude)
            {
                if (!string.IsNullOrWhiteSpace(ord.convergeTransactionId) && !sentMsg.ContainsKey(ord.convergeTransactionId)) { 
                    sentMsg.Add(ord.convergeTransactionId, ord.Message);
                }
            }

            var l = new OrderListModel(); 

            foreach(var itm in coll.Find(x => x.date > DateTime.Now.AddDays(-2)).ToList())
            {
                if ((itm.convergeTransactionId != null) && sentMsg.ContainsKey(itm.convergeTransactionId)) {
                   itm.Message = sentMsg[itm.convergeTransactionId];
                }
                l.Add(itm);
            }

            l.Sort((x, y) => y.date.CompareTo(x.date));

            return View(l);
        }   

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
