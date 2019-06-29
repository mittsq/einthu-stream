import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lang {
  Lang._();

  static Map<String, String> languages = {
    'hindi': 'Hindi\nहिंदी',
    'tamil': 'Tamil\nதமிழ்',
    'telegu': 'Telugu\nతెలుగు',
    'bengali': 'Bengali\nবাংলা',
    'malayalam': 'Malayalam\nമലയാളം',
    'kannada': 'Kannada\nಕನ್ನಡ',
    'marathi': 'Marathi\nमराठी',
    'punjabi': 'Punjabi\nਪੰਜਾਬੀ / پنجابی',
  };

  static Future<bool> ask(BuildContext context) async {
    var list = <Widget>[];
    languages.forEach((k, v) => list.add(SimpleDialogOption(
          child: Text(v),
          onPressed: () => Navigator.pop(context, k),
        )));

    final choice = await showDialog<String>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Select a language ...'),
            children: list,
          );
        });

    final prefs = await SharedPreferences.getInstance();
    if (choice != null && prefs.getString('language') != choice) {
      prefs.setString('language', choice);
      return true;
    }
    return false;
  }
}
