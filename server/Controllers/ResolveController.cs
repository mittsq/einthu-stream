using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using AngleSharp.Parser.Html;
using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json.Linq;
using RestSharp;

namespace EinthuStream.Controllers {
    [Route("api/[controller]")]
    [ApiController]
    public class ResolveController : ControllerBase {
        [HttpGet]
        public async Task<string> Get([FromQuery] string id) {
            if (id == null) throw new ArgumentNullException("id", "Cannot resolve a null id");

            return await Resolver.Resolve(id);
        }

        class Resolver {
            public static async Task<string> Resolve(string id) {
                var data = await GetResultPage(id);
                var encoded = await GetEncodedUrl(id, data);
                return await DecodeUrl(encoded);
            }

            private static async Task<string[]> GetResultPage(string id) {
                var doc = await Requester.GetDocumentAsync(new RestRequest("/movie/watch/" + id));
                var pageId = doc.GetElementsByTagName("html")[0].GetAttribute("data-pageid");
                var pingables = doc.GetElementById("UIVideoPlayer").GetAttribute("data-ejpingables");

                return new [] { pageId, pingables };
            }

            private static async Task<string> GetEncodedUrl(string id, string[] data) {
                var postReq = new RestRequest("/ajax/movie/watch/" + id, Method.POST);
                postReq.AddHeader("Accept", "application/json");

                postReq.AddParameter("xEvent", "UIVideoPlayer.PingOutcome");
                postReq.AddParameter("xJson", "{\"EJOutcomes\":\"" + data[1] + "\",\"NativeHLS\":false}");
                postReq.AddParameter("gorilla.csrf.Token", data[0]);

                var json = JObject.Parse(await Requester.GetContentAsync(postReq));
                return json["Data"]["EJLinks"].Value<string>();
            }

            private static async Task<string> DecodeUrl(string encoded) => await Task.Run(() => {
                var sub = encoded.Substring(0, 10) +
                    encoded[encoded.Length - 1] +
                    encoded.Substring(12, encoded.Length - 13);
                var json = Encoding.UTF8.GetString(Convert.FromBase64String(sub));
                return JObject.Parse(json)["MP4Link"].Value<string>();
            });
        }
    }
}
