import 'package:einthu_stream/adapter.dart';
import 'package:einthu_stream/cast/cast.dart';
import 'package:einthu_stream/lang.dart';
import 'package:einthu_stream/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:einthu_stream/search.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() : super() {
    CastEngine.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.dark,
      data: (brightness) {
        return ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.green.shade900,
          brightness: brightness,
        );
      },
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
          title: 'Einthu Stream',
          theme: theme,
          home: PopularScreen(),
        );
      },
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
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
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
                children: snapshot.data.map((i) => i.build(context)).toList(),
              );
            }
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.error),
                  Text('Could not load popular movies'),
                ],
              ),
            );
          default:
            return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Einthu Stream'),
        actions: buildActions(
          context: context,
          search: true,
          refresh: () {
            this.refresh();
          },
        ),
      ),
      body: _generate(),
    );
  }
}

List<Widget> buildActions(
    {BuildContext context, bool search, Function refresh}) {
  var list = <Widget>[];
  if (search) {
    list.add(IconButton(
      icon: Icon(Icons.search),
      onPressed: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchScreen(),
          ),
        );
      },
      tooltip: 'Search',
    ));
  }
  list.addAll(<Widget>[
    IconButton(
      icon: Icon(CastEngine.isConnected ? Icons.cast_connected : Icons.cast),
//            onPressed: () async {
//              await CastEngine.pickDevice(context);
//              print(CastEngine.isConnected);
//              setState(() {});
//            },
      tooltip: 'Chromecast',
    ),
    PopupMenuButton(
      itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem(
              child: Text('Select language ...'),
              value: 0,
            ),
            PopupMenuItem(
              child: Text('Switch theme'),
              value: 1,
            ),
          ],
      onSelected: (i) async {
        switch (i) {
          case 0:
            if (await Lang.ask(context)) refresh();
            break;
          case 1:
            DynamicTheme.of(context).setBrightness(
                Theme.of(context).brightness == Brightness.dark
                    ? Brightness.light
                    : Brightness.dark);
            break;
          default:
        }
      },
    ),
  ]);
  return list;
}
