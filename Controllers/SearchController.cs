using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AngleSharp.Parser.Html;
using Microsoft.AspNetCore.Mvc;
using RestSharp;

namespace EinthuStream.Controllers {
    [Route("api/[controller]")]
    [ApiController]
    public class SearchController : ControllerBase {
        [HttpGet]
        public async Task<Result[]> GetAsync([FromQuery] string query, [FromQuery] string language = "hindi", [FromQuery] int page = 1) {
            if (query == null)throw new ArgumentNullException("query", "Searching requires a query");

            var getReq = new RestRequest($"/movie/results/?lang={language}&page={page}&query={query}", Method.GET);
            var getResponse = await new RestClient("https://einthusan.tv").ExecuteTaskAsync(getReq);
            var doc = await new HtmlParser().ParseAsync(getResponse.Content);
            return doc.QuerySelectorAll("#UIMovieSummary > ul > li").Select(_ => Scraper.ScrapeAsync(_)).ToArray();
        }
    }

    [Route("api/[controller]")]
    [ApiController]
    public class PopularController : ControllerBase {
        [HttpGet]
        public async Task<Result[]> GetAsync([FromQuery] string language = "hindi") {
            var getReq = new RestRequest($"/movie/browse/?lang={language}", Method.GET);
            var getResponse = await new RestClient("https://einthusan.tv").ExecuteTaskAsync(getReq);
            var doc = await new HtmlParser().ParseAsync(getResponse.Content);
            return doc.QuerySelectorAll("#UIFeaturedFilms div.tabview").Select(_ => Scraper.ScrapePopularAsync(_)).ToArray();
        }
    }
}
