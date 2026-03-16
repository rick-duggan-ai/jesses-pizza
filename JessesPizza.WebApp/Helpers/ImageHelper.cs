using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using System;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

namespace JessesPizza.Core.Models
{
    public class ImageHelper
    {
        public static string GetImageBasePath ()
        {
            //return "https://codexposed.net/JessesWebBK/JessesImages/";
            return "https://services.jessespizza.com:5001/JessesImages/";
            //return "https://192.168.86.118:5001/JessesImages/";
        }
        public async static Task<string> GetImageAsBase64Url(string id)
        {
                try
                {
                    var path = string.Concat(Directory.GetCurrentDirectory(), "/wwwroot/JessesImages/", id, ".jpg");
                var bytes = File.ReadAllBytes(path);
                return "data:image/jpeg;base64," + Convert.ToBase64String(bytes);
                }
                catch (Exception e)
                {
                    return "";
                }
        }
        public async static Task<string> DuplicateImageFromUrl(string oldId,string id)
        {

                try
                {
                    var path = string.Concat(Directory.GetCurrentDirectory(),"/wwwroot/JessesImages/", oldId, ".jpg");
                    var bytes = File.ReadAllBytes(path);
                    path = string.Concat(Directory.GetCurrentDirectory(), "/wwwroot/JessesImages/", id, ".jpg");
                    using (var imageFile = new FileStream(path, FileMode.Create))
                    {
                        imageFile.Write(bytes, 0, bytes.Length);
                        imageFile.Flush();
                    }
                return string.Concat(GetImageBasePath(), id, ".jpg");
            }
                catch (Exception e)
                {
                    return "";
                }
        }
    }
}
