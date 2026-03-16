using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace JessesNewWeb.Models
{
    public class OrderModel
    {
        public DateTime Date { get; set; } = new DateTime(1900, 1, 1);
        public string Id { get; set; } = string.Empty;
        public decimal Total { get; set; } = 0;
        public string Name { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public string City { get; set; } = string.Empty;
        public string ZipCode { get; set; } = string.Empty;
        public string State { get; set; } = string.Empty;
        public string Message { get; set; } = string.Empty;
    }

    public class OrderListModel : List<dbOrder> { }

    [BsonIgnoreExtraElements]
    public class dbOrder
    {
        // didn't work
        //[BsonRepresentation(BsonType.ObjectId)]
        //public string _id { get; set; } = string.Empty;
        
        public static DateTime ToLocal(DateTime original) {
          TimeZoneInfo inf = TimeZoneInfo.FindSystemTimeZoneById("US/Pacific");
          DateTime pac = TimeZoneInfo.ConvertTime(original, inf);
          return pac;
        }

        [BsonDateTimeOptions(DateOnly = false)]
        private DateTime _date = DateTime.Now;
        public DateTime date 
        { 
          get 
          {
             return dbOrder.ToLocal(_date);
          }
          set
          {
             _date = value;
          }
        }   
        public string name { get; set; }

        public string phoneNumber { get; set; }
        public string address { get; set; }

        public string total { get; set; }

        public string convergeTransactionId { get; set; }
        public string Message { get; set; } = string.Empty;
        public string SpecialInstructionsForOrder { get; set; }

        public List<OrderItem> shoppingCartItems { get; set; }
    }

    [BsonIgnoreExtraElements]
    public class OrderItem
    {
       public string Description {get;set;} = string.Empty;
       public string Instructions {get;set;} = string.Empty;
       public string Name {get;set;} = string.Empty;
    }
}
