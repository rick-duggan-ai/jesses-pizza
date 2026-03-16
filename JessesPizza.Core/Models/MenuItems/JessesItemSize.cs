using MongoDB.Bson.Serialization.Attributes;
using SQLite;
using System.Collections.Generic;

namespace JessesPizza.Core.Models
{
    [Table("JessesItemSize")]
    public class JessesItemSize
    {
        [PrimaryKey, AutoIncrement, Column("_id")]
        public string Id { get; set; }
        [BsonElement("name")]
        public string Name { get; set; }
        [BsonElement("price")]

        public decimal Price { get; set; }
        [BsonElement("default")]
        public bool IsDefault { get; set; }
        [BsonElement("groupIds")]
        [Ignore]
        public IEnumerable<string> GroupIds { get; set; }
    }
}
