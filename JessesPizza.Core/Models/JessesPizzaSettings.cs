using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Core.Models
{
    public class JessesPizzaSettings
    {
        [BsonId, BsonRepresentation(BsonType.ObjectId)]
        public string Id { get; set; }
        [BsonElement("storeHours")]
        public List<StoreHours> StoreHours { get; set; }
        [BsonElement("merchantId")]
        public string MerchantId { get; set; }
        [BsonElement("userId")]
        public string UserId { get; set; }
        [BsonElement("pin")]
        public string Pin { get; set; }
        [BsonElement("deliveryCharge")]
        public decimal DeliveryCharge { get; set; }
        [BsonElement("taxRate")]
        public decimal TaxRate { get; set; }
        [BsonElement("minimumOrderAmount")]
        public decimal MinimumOrderAmount { get; set; }
        [BsonElement("zipCodes")]
        public List<ZipCode> ZipCodes { get; set; }
        [BsonElement("aboutText")]
        public string AboutText { get; set; }
        [BsonElement("sendGridKey")]
        public string SendGridKey { get; set; }
        [BsonElement("adminEmail")]
        public string AdminEmail { get; set; }
        [BsonElement("sendGridEmail")]
        public string SendGridEmail { get; set; }
        [BsonElement("twilioAccountSid")]
        public string TwilioAccountSid { get; set; }
        [BsonElement("twilioAuthToken")]
        public string TwilioAuthToken { get; set; }
        [BsonElement("twilioPhoneNumber")]
        public string TwilioPhoneNumber { get; set; }
        [BsonElement("useDemoEndpoints")]
        public bool UseDemoEndpoints { get; set; }
    }
    public class ZipCode
    {
        public string ZipCodeValue { get; set; }
    }
    public class StoreHours
    {
        [BsonElement("day")]
        public DayOfTheWeek Day { get; set; }
        [BsonElement("openingTime")]
        public DateTime? OpeningTime { get; set; }
        [BsonElement("closingTime")]
        public DateTime? ClosingTime { get; set; }
    }

    public enum DayOfTheWeek
    {
        Monday,
        Tuesday,
        Wednesday,
        Thursday,
        Friday,
        Saturday,
        Sunday
    }
}
