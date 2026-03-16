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

namespace JessesPizza.MobileAppService.Controllers
{
    [DisableRequestSizeLimit]
    public class UploadController : Controller
    {
        private readonly IPizzaRepo _pizzaRepo;

        public UploadController(IPizzaRepo pizzaRepo)
        {
            _pizzaRepo = pizzaRepo;
        }

        [HttpPost("upload/single/{id}")]
        public async Task<IActionResult> Single(IFormFile file,string id)
        {
            try
            {
                var timestamp = DateTime.Now.TimeOfDay.ToString();
                var assembly = Directory.GetCurrentDirectory();
                var ext = string.Concat("/wwwroot/JessesImages/", id, ".jpg");
                var filePath = string.Concat(assembly, ext);
                if (!System.IO.File.Exists(filePath))
                {
                    using (var imageFileStream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                    {
                        await file.CopyToAsync(imageFileStream);
                    }
                    return StatusCode(200);

                }
                else
                {
                    ext= string.Concat("/wwwroot/JessesImages/", id, "new.jpg");
                    filePath = string.Concat(assembly, ext);
                    using (var imageFileStream = new FileStream(filePath, FileMode.Create, FileAccess.Write))
                    {
                        if (file.Length > 0)
                        {
                            using (var ms = new MemoryStream())
                            {
                                file.CopyTo(ms);
                                var fileBytes = ms.ToArray();
                                imageFileStream.Write(fileBytes, 0, fileBytes.Length);
                                imageFileStream.Flush();
                            }
                        }
                    }
                    return StatusCode(200);
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, ex.Message);
            }
        }

       
    }
}