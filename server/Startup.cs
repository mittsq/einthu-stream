using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

namespace EinthuStream {
    public class Startup {
        public Startup(IConfiguration configuration) {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services) {
            services.AddResponseCompression()
                .AddMemoryCache()
                .AddMvc()
                .SetCompatibilityVersion(CompatibilityVersion.Version_2_2);
        }

        public void Configure(IApplicationBuilder app, IHostingEnvironment env) {
            if (env.IsDevelopment()) {
                app.UseDeveloperExceptionPage();
            } else {
                app.UseHsts();
            }

            // app.UseResponseCaching();
            // app.Use(async(context, next) => {
            //     context.Response.GetTypedHeaders().CacheControl =
            //     new Microsoft.Net.Http.Headers.CacheControlHeaderValue() {
            //     Public = true,
            //     MaxAge = TimeSpan.FromMinutes(5),
            //     MaxStaleLimit = TimeSpan.FromMinutes(15)
            //         };
            //     context.Response.Headers[Microsoft.Net.Http.Headers.HeaderNames.Vary] =
            //         new string[] { "Accept-Encoding" };

            //     await next();
            // });

            app.UseResponseCompression();
            app.UseHttpsRedirection();
            app.UseMvc();
        }
    }
}
