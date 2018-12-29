import 'package:einthu_stream/adapter.dart';
import 'package:einthu_stream/result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen(String q, {Key key}) : super(key: key) {
    _q = q;
  }

  String _q;

  @override
  _SearchScreenState createState() => _SearchScreenState(_q);
}

class _SearchScreenState extends State<SearchScreen> {
  String _query;
  Future<List<Result>> _results;
  TextEditingController _controller = TextEditingController();

  _SearchScreenState(String q) : super() {
    _query = q;
    _controller.text = q;
  }

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() async {
    _results = Adapter.search(_query, 'hindi', 1);
  }

  Widget _buildResults() {
    return FutureBuilder<List<Result>>(
      future: _results,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Center(
              child: Text(
                'No results',
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
              children: <Widget>[
                Icon(Icons.error),
                Text('Could not perform search'),
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
        title: Text(_query),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              final dialog = Dialog(
                child: Container(
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search ...',
                      contentPadding: EdgeInsets.all(16),
                    ),
                    onSubmitted: (text) async {
                      this.setState(() {
                        _query = text;
                        _controller.text = text;
                        refresh();
                        Navigator.pop(context);
                      });
                    },
                  ),
                ),
              );
              showDialog(context: context, builder: (context) => dialog);
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
                  // this.refresh();
                  break;
                default:
              }
            },
          ),
        ],
      ),
      body: _buildResults(),
    );
  }
}
