using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace EinthuStream {
    public class Result {
        public class Professional {
            public string Name { get; set; }
            public string Role { get; set; }
            public string Avatar { get; set; }
        }

        public string Title { get; set; }
        public string CoverImageUrl { get; set; }
        public int Year { get; set; }
        public List<string> Qualities { get; set; }
        public bool HasSubtitles { get; set; }
        public string Description { get; set; }
        public double Rating { get; set; }
        public string Language { get; set; }
        public bool IsPopular { get; set; }
        public string Wiki { get; set; }
        public string Trailer { get; set; }

        public List<Professional> Professionals { get; set; }

        public string Id { get; set; }
    }
}
