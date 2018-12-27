import 'package:einthu_stream/result.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Adapter {
  Adapter._();
  static const String _base = 'https://einthu-stream.herokuapp.com/api';

  static Future<List<Result>> getPopular(String lang) async {
    final response = await http.get('$_base/popular?language=$lang');
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((i) => new Result.fromJson(i))
          .toList();
    } else {
      throw Exception;
    }
  }

  static Future<List<Result>> search(
      String query, String lang, int page) async {
    final response = await http.get(
        '$_base/search?query=$query&language=$lang&page=${page.toString()}');
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((i) => new Result.fromJson(i))
          .toList();
    } else {
      throw Exception;
    }
  }

  static Future<String> resolve(String id) async {
    final response = await http.get('$_base/resolve?id=$id');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception;
    }
  }
}
