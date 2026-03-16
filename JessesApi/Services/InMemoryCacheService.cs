using Microsoft.Extensions.Caching.Memory;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace JessesApi.Services
{
    public class InMemoryCacheService : ICacheService
    {
        private readonly MemoryCache _cache = new MemoryCache(new MemoryCacheOptions());

        public Task<string> GetCacheValue(string key)
        {
            return Task.FromResult(_cache.Get<string>(key));
        }

        public Task SetCacheValue(string key, string value)
        {
            _cache.Set(key, value,TimeSpan.FromMinutes(15));
            return Task.CompletedTask;
        }

    }
}
