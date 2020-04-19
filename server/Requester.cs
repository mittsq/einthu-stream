using System;
using System.Net;
using System.Threading.Tasks;
using AngleSharp.Html.Dom;
using AngleSharp.Html.Parser;
using RestSharp;

namespace EinthuStream {
  public static class Requester {
    private static RestClient _client;

    private static RestClient Client =>
      _client ??= new RestClient {
        CookieContainer = new CookieContainer(),
        BaseUrl = new Uri("https://einthusan.ca"),
        UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0"
      };

    private static HtmlParser _parser;
    private static HtmlParser Parser => _parser ??= new HtmlParser();

    public static async Task<IHtmlDocument> GetDocumentAsync(RestRequest req) {
      return await Parser.ParseDocumentAsync(await GetContentAsync(req));
    }

    public static async Task<string> GetContentAsync(RestRequest req) {
      var getResponse = await Client.ExecuteAsync(req);
      return getResponse.Content;
    }
  }
}
