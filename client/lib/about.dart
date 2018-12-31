import 'package:einthu_stream/updater.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => buildDialog(context);

  static Widget buildDialog(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8),
          child: Image.asset(
            'assets/icon.png',
            width: 64,
          ),
        ),
        Text(
          'Einthu Stream',
          style: TextStyle(fontSize: 24),
        ),
        Text('Version ${Updater.version}'),
        Text(
          '\nA client for Einthusan with casting and downloads.\n'
              'Made with ♥ using Flutter.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(
            width: 32,
            height: 32,
            child: FlutterLogo(),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text('WEBSITE'),
              onPressed: () async {
                await launcher.launch('https://basak.me/einthu');
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('GITHUB'),
              onPressed: () async {
                await launcher.launch('https://github.com/mittsquared/einthu-stream');
                Navigator.pop(context);
              },
            ),
          ],
        )
      ],
    );
  }
}
