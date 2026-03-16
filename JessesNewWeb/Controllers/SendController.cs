using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Flurl;
using Flurl.Http;
using System.Text.Json;
using MongoDB.Driver;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace JessesNewWeb.Controllers
{
    public class SendController : Controller
    { 
        public async Task<IActionResult> Post([FromBody]OrderReady ord)
        {
            const string apiUrl = "https://services.jessespizza.com:5000/api/Mongo/";
            string tok = Environment.GetEnvironmentVariable("API_TOKEN");
            
            try
            {
                var resp = await apiUrl.AppendPathSegment("UpdateDeliveryTime").WithHeader("ContentType", "application/json")
                    .WithOAuthBearerToken(tok).PostJsonAsync(ord);

                await SaveMessageToMongo(ord);

                return Ok(await resp.Content.ReadAsStringAsync());
            } 
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }

        public async Task<IActionResult> SaveMessage([FromBody]OrderReady ord)
        {
            try
            {
                Console.WriteLine($"Request was **** : \n\n {JsonSerializer.Serialize(ord)} \n******* end request *****\n\n");

                return Ok(await SaveMessageToMongo(ord));
            }
            catch (Exception e)
            {
                return BadRequest($"{e.Message} - {e.GetType().ToString()}\n\nMsg was : {JsonSerializer.Serialize(ord)} \n\n {e}");
            }
        }

        private async Task<string> SaveMessageToMongo(OrderReady ord)
        { 
            const string mConn = "mongodb+srv://jesses:rwguMF0CSr01x3wD@jesses-sandbox-ndqtx.mongodb.net/test?retryWrites=true&w=majority";
            MongoClient dbClient = new MongoClient(mConn);
            var db = dbClient.GetDatabase("JessesPizzaDB");
            var coll = db.GetCollection<OrderReady>("TextMessages");
            await coll.InsertOneAsync(ord);

            return "success";
        }
    }

    [BsonIgnoreExtraElements]
    public class OrderReady
    { 
        public string PhoneNumber { get; set; } = string.Empty; 
        public string Message { get; set; } = string.Empty;

        public DateTime date { get; set; } = DateTime.Now;

        public string convergeTransactionId { get; set; } = "error this should be a GUID value";
    }
}
