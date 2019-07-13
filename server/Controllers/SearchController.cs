using System;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Caching.Memory;
using RestSharp;

namespace EinthuStream.Controllers {
  [Route("api/[controller]")]
  [ApiController]
  public class SearchController : ControllerBase {
    private IMemoryCache _cache;

    public SearchController(IMemoryCache cache) {
      _cache = cache;
    }

    [HttpGet]
    public async Task<Result[]> GetAsync([FromQuery] string query, [FromQuery] string language = "hindi",
      [FromQuery] int page = 1) {
      if (query == null) throw new ArgumentNullException(nameof(query), "Searching requires a query");

      var key = new { Query = query, Language = language, Page = page };

      return await _cache.GetOrCreateAsync(key, async entry => {
        entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(3);
        // _logger.LogInformation("Caching new value for page {PAGE} of search {QUERY} in {LANG}", page, query, language);
        Console.WriteLine("Caching new value for page {0} of search {1} in {2}", page, query, language);

        var getReq = new RestRequest($"/movie/results/?lang={language}&page={page}&query={query}");
        var doc = await Requester.GetDocumentAsync(getReq);
        return doc.QuerySelectorAll("#UIMovieSummary > ul > li").Select(_ => {
          var r = Scraper.ScrapeAsync(_);
          if (r.Description != null) _cache.Set(new { Id = r.Id }, r.Description);
          return r;
        }).ToArray();
      });
    }
  }

  [Route("api/[controller]")]
  [ApiController]
  public class PopularController : ControllerBase {
    private IMemoryCache _cache;

    public PopularController(IMemoryCache cache) {
      _cache = cache;
    }

    [HttpGet]
    public async Task<Result[]> GetAsync([FromQuery] string language = "hindi") {
      var key = new { Language = language };

      return await _cache.GetOrCreateAsync(key, async entry => {
        entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromHours(3);
        Console.WriteLine("Caching new value for popular in {0}", language);

        var getReq = new RestRequest($"/movie/browse/?lang={language}");
        var doc = await Requester.GetDocumentAsync(getReq);
        return doc.QuerySelectorAll("#UIFeaturedFilms div.tabview").Select(_ => {
          var r = Scraper.ScrapePopularAsync(_);
          if (r.Description != null) _cache.Set(new { Id = r.Id }, r.Description);
          return r;
        }).ToArray();
      });
    }
  }

  [Route("api/[controller]")]
  [ApiController]
  public class DescController : ControllerBase {
    private IMemoryCache _cache;

    public DescController(IMemoryCache cache) {
      _cache = cache;
    }

    [HttpGet]
    public async Task<string> GetAsync([FromQuery] string id) {
      var key = new { Id = id };
      var cached = _cache.Get<string>(key);
      if (cached != null) return cached;
      var getReq = new RestRequest($"https://einthusan.tv/movie/watch/{id}/");
      var doc = await Requester.GetDocumentAsync(getReq);
      var refresh = Scraper.ScrapeAsync(doc.QuerySelector("#UIMovieSummary > ul > li"));
      _cache.Set(key, refresh.Description);
      return refresh.Description;
    }
  }
}
