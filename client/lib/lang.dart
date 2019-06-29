import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lang {
  Lang._();

  static Future<bool> ask(BuildContext context) async {
    final choice = await showDialog<String>(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Select a language ...'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Hindi'),
                onPressed: () {
                  Navigator.pop(context, 'hindi');
                },
              ),
              SimpleDialogOption(
                child: Text('Tamil'),
                onPressed: () {
                  Navigator.pop(context, 'tamil');
                },
              ),
              SimpleDialogOption(
                child: Text('Telugu'),
                onPressed: () {
                  Navigator.pop(context, 'telugu');
                },
              ),
              SimpleDialogOption(
                child: Text('Bengali'),
                onPressed: () {
                  Navigator.pop(context, 'bengali');
                },
              ),
              SimpleDialogOption(
                child: Text('Malayalam'),
                onPressed: () {
                  Navigator.pop(context, 'malayalam');
                },
              ),
              SimpleDialogOption(
                child: Text('Kannada'),
                onPressed: () {
                  Navigator.pop(context, 'kannada');
                },
              ),
              SimpleDialogOption(
                child: Text('Marathi'),
                onPressed: () {
                  Navigator.pop(context, 'marathi');
                },
              ),
              SimpleDialogOption(
                child: Text('Punjabi'),
                onPressed: () {
                  Navigator.pop(context, 'punjabi');
                },
              ),
            ],
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
