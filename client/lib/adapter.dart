import 'dart:convert';

import 'package:einthu_stream/result.dart';
import 'package:http/http.dart' as http;

/// Interface with einthu-stream REST api
class Adapter {
  Adapter._();

  static const String _base = 'https://einthu-stream.herokuapp.com/api';

//  static const String _base = 'http://192.168.0.119:5000/api';

  /// Retrieves the popular movies for a given [lang].
  static Future<List<Result>> getPopular(String lang) async {
    final response = await http.get('$_base/popular?language=$lang');
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((i) => Result.fromJson(i))
          .toList();
    } else {
      throw Exception;
    }
  }

  /// Searches for movies with a given [query].
  /// Unlike the call itself, [search] requires
  /// the [page] number and the [lang].
  static Future<List<Result>> search(
      String query, String lang, int page) async {
    final response = await http.get(
        '$_base/search?query=$query&language=$lang&page=${page.toString()}');
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((i) => Result.fromJson(i))
          .toList();
    } else {
      throw Exception;
    }
  }

  /// Resolves a direct link to a movie given its [id].
  static Future<String> resolve(String id) async {
    final response = await http.get('$_base/resolve?id=$id');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception;
    }
  }

  /// Gets the description of a movie given its [id].
  static Future<String> describe(String id) async {
    final response = await http.get('$_base/desc?id=$id');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception;
    }
  }
}
