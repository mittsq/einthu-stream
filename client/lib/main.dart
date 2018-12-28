import 'package:einthu_stream/adapter.dart';
import 'package:einthu_stream/result.dart';
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Einthu Stream',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: PopularScreen(),
    );
  }
}

class PopularScreen extends StatefulWidget {
  PopularScreen({Key key}) : super(key: key);

  @override
  _PopularScreenState createState() => _PopularScreenState();
}

class _PopularScreenState extends State<PopularScreen> {
  Future<List<Result>> _popItems;

  @override
  void initState() {
    super.initState();
    // refresh();
    _popItems = Adapter.getPopular('hindi');
  }

  // void refresh() {
  //   // final prefs = await SharedPreferences.getInstance();
  //   _popItems =
  //       Adapter.getPopular(/* prefs.getString('language') ?? */ 'hindi');
  // }

  Widget _generate() {
    return FutureBuilder<List<Result>>(
      future: _popItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return new Center(
              child: new Text(
                'Nothing to show',
                style: new TextStyle(fontStyle: FontStyle.italic),
              ),
            );
          }
          return new ListView(
            children: snapshot.data.map((i) => new Text(i.title)).toList(),
          );
        } else if (snapshot.hasError) {
          return new Center(
            child: new Column(
              children: <Widget>[
                new Icon(Icons.error),
                new Text('Could not load popular movies'),
              ],
            ),
          );
        }
        return new Center(
          child: new CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einthu Stream"),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.settings),
        //     onPressed: () => {},
        //     tooltip: 'Settings',
        //   ),
        // ],
      ),
      body: _generate(),
    );
  }
}
