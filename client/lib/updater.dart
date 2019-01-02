import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'package:http/http.dart' as http;
import 'package:package_info/package_info.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:simple_permissions/simple_permissions.dart';

class Updater {
  Updater._();

  static final String url =
      "https://api.github.com/repos/mittsquared/einthu-stream/releases/latest";
  static String version;
  static const platform = const MethodChannel('me.basak.einthustream/apk');

  static Future update(BuildContext context) async {
    if (version == null) version = (await PackageInfo.fromPlatform()).version;

    final response = (await http.get(url));
    if (response.statusCode != 200) return;

    final json = jsonDecode(response.body);

    final name = json['tag_name'] as String;
    final remote = splitVersion(name);
    final local = splitVersion(version);
    for (var i = 0; i < 3; ++i) {
      if (remote[i] > local[i]) {
        final response = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text('Update available'),
              content: SingleChildScrollView(
                child: Text(json['body']),
              ),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text('UPDATE'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('DISMISS'),
                ),
              ],
            );
          },
        );
        if (response) {
          // Scaffold.of(context).showSnackBar(
          //   SnackBar(
          //     content: Text('Downloading update ...'),
          //   ),
          // );
          final apk = (json['assets'] as List)[0]['browser_download_url'];
          final perm = await SimplePermissions.requestPermission(
              Permission.WriteExternalStorage);
          if (perm != PermissionStatus.authorized) return;
          final bytes = (await http.get(apk)).bodyBytes;
          final ext = (await path.getExternalStorageDirectory()).path;
          final dir = await Directory('$ext/Download/einthu-stream/updates')
              .create(recursive: true);
          await dir
              .list()
              .where((file) => file.path.endsWith('.apk'))
              .forEach((file) => file.delete());
          final file = File('${dir.path}/update-$name.apk');
          await file.writeAsBytes(bytes);
//          await launcher.launch(file.path);
          await platform.invokeMethod('installApk', {'path': '${file.path}'});
        }
        break;
      }
    }
  }

  static List<int> splitVersion(String v) =>
      v.split('.').map((i) => int.parse(i)).toList();
}
