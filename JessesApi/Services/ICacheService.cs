using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace JessesApi.Services
{
    public interface ICacheService
    {
        Task<string> GetCacheValue(string key);
        Task SetCacheValue(string key,string value);

    }
}
