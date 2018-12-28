class Result {
  String title;
  String coverImageUrl;
  int year;
  List<String> qualities;
  bool hasSubtitles;
  String description;
  double rating;
  String language;
  bool isPopular;
  Class genre;
  String wiki;
  String trailer;
  List<Professionals> professionals;
  String id;

  Result(
      {this.title,
      this.coverImageUrl,
      this.year,
      this.qualities,
      this.hasSubtitles,
      this.description,
      this.rating,
      this.language,
      this.isPopular,
      this.genre,
      this.wiki,
      this.trailer,
      this.professionals,
      this.id});

  Result.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    coverImageUrl = json['coverImageUrl'];
    year = json['year'];
    qualities = json['qualities'].cast<String>();
    hasSubtitles = json['hasSubtitles'];
    description = json['description'];
    rating = json['rating'];
    language = json['language'];
    isPopular = json['isPopular'];
    genre = Class.values[json['genre'] + 1];
    wiki = json['wiki'];
    trailer = json['trailer'];
    if (json['professionals'] != null) {
      professionals = List<Professionals>();
      json['professionals'].forEach((v) {
        professionals.add(Professionals.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['title'] = this.title;
    data['coverImageUrl'] = this.coverImageUrl;
    data['year'] = this.year;
    data['qualities'] = this.qualities;
    data['hasSubtitles'] = this.hasSubtitles;
    data['description'] = this.description;
    data['rating'] = this.rating;
    data['language'] = this.language;
    data['isPopular'] = this.isPopular;
    data['genre'] = this.genre.index - 1;
    data['wiki'] = this.wiki;
    data['trailer'] = this.trailer;
    if (this.professionals != null) {
      data['professionals'] =
          this.professionals.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    return data;
  }
}

enum Class { Unknown, Action, Comedy, Romance }

class Professionals {
  String name;
  String role;
  String avatar;

  Professionals({this.name, this.role, this.avatar});

  Professionals.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    role = json['role'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['role'] = this.role;
    data['avatar'] = this.avatar;
    return data;
  }
}
