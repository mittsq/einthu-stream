import 'package:einthu_stream/adapter.dart';
import 'package:einthu_stream/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:einthu_stream/search.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

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
    refresh();
  }

  void refresh() async {
    final prefs = await SharedPreferences.getInstance();
    this.setState(() {
      _popItems = Adapter.getPopular(prefs.getString('language') ?? 'hindi');
    });
  }

  Widget _generate() {
    return FutureBuilder<List<Result>>(
      future: _popItems,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                'Nothing to show',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            );
          }
          return ListView(
            children: snapshot.data.map((i) => i.build()).toList(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.error),
                Text('Could not load popular movies'),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einthu Stream'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchScreen(null),
                ),
              );
            },
            tooltip: 'Search',
          ),
          IconButton(
            icon: Icon(Icons.cast),
            onPressed: () {},
            tooltip: 'Chromecast',
          ),
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text('Refresh'),
                    value: 0,
                    enabled: false,
                  ),
                  // PopupMenuDivider(),
                  PopupMenuItem(
                    child: Text('Settings'),
                    value: 1,
                  ),
                ],
            onSelected: (i) {
              switch (i) {
                case 0:
                  this.refresh();
                  break;
                default:
              }
            },
          ),
        ],
      ),
      body: _generate(),
    );
  }
}
