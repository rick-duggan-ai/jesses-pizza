using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.Linq;

namespace JessesPizza.Core.Helpers
{
    public class IdHelper
    {
        static Random random = new Random();

        public static string GetUniqueId()
        {
            byte[] buffer = new byte[12];
            random.NextBytes(buffer);
            string result = String.Concat(buffer.Select(x => x.ToString("X2")).ToArray());
                return result;
        }
    }
}
