using System;
using System.Net;
using System.Threading.Tasks;
using AngleSharp.Dom.Html;
using AngleSharp.Parser.Html;
using RestSharp;

namespace EinthuStream {
    public static class Requester {
        private static RestClient _client;
        private static RestClient Client {
            get {
                if (_client is null)_client = new RestClient {
                    CookieContainer = new CookieContainer(),
                        BaseUrl = new Uri("https://einthusan.tv"),
                        UserAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0"
                };
                return _client;
            }
        }

        private static HtmlParser _parser;
        private static HtmlParser Parser {
            get {
                if (_parser is null)_parser = new HtmlParser();
                return _parser;
            }
        }

        public static async Task<IHtmlDocument> GetDocumentAsync(RestRequest req) {
            return await Parser.ParseAsync(await GetContentAsync(req));
        }

        public static async Task<string> GetContentAsync(RestRequest req) {
            var getResponse = await Client.ExecuteTaskAsync(req);
            return getResponse.Content;
        }
    }
}
