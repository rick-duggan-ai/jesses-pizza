using System;
using System.Collections.Generic;
using System.Text;

namespace JessesPizza.Data.Tests
{
    public static class APIKeys
    {
        //Azure CosmosDb Connection
        //public static readonly string ConnectionString = "mongodb://semu1995:CCKtUZzsgRmNS5xqnC4umLUApa63tFEAK9vFXmi6Svj9rV1TqUC75dVCKHf3uTeDxb10g6xAIpewELd9Y6OE5w==@semu1995.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&maxIdleTimeMS=120000&appName=@semu1995@";

        //MongoDbAtlas Azure connection
        public static readonly string TestConnectionString = "mongodb+srv://mert:Passw00rd@jessespizza-rgiky.azure.mongodb.net/test?retryWrites=true&w=majority";

        //MongoDbAtlas AWS connection
        public static readonly string ConnectionString = "mongodb+srv://mert:Passw00rd@jessespizzaaws-4xeqz.mongodb.net/test?retryWrites=true&w=majority";
        //public static readonly string WebsiteUrl = "http://192.168.86.118:5001";




    }
}
