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
            var getReq = new RestRequest($"/movie/results/?lang={language}&page={page}&query={query}", Method.GET);
            var getResponse = await new RestClient("https://einthusan.tv").ExecuteTaskAsync(getReq);
            var doc = await new HtmlParser().ParseAsync(getResponse.Content);
            return doc.QuerySelectorAll("#UIMovieSummary > ul > li").Select(_ => Scraper.Scrape(_)).ToArray();
        }
    }
}
