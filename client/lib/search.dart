import 'package:einthu_stream/adapter.dart';
import 'package:einthu_stream/main.dart';
import 'package:einthu_stream/result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _query;
  Future<List<Result>> _results;
  TextEditingController _controller = TextEditingController();

  void refresh() async {
    final prefs = await SharedPreferences.getInstance();
    _results =
        Adapter.search(_query, prefs.getString('language') ?? 'hindi', 1);
  }

  Widget _buildResults() {
    return FutureBuilder<List<Result>>(
      future: _results,
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
                    'No results',
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
                  Text('Could not perform search'),
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
        title: TextField(
          textInputAction: TextInputAction.search,
          decoration: null,
          // decoration: InputDecoration(
          //   hintText: 'Search ...',
          // ),
          // style: TextStyle(color: Theme.of(context).backgroundColor),
          autofocus: true,
          onSubmitted: (text) async {
            this.setState(() {
              _query = text;
              _controller.text = text;
              refresh();
            });
          },
        ),
        actions: buildActions(
          context: context,
          search: false,
          refresh: () {
            this.refresh();
          },
        ),
      ),
      body: _buildResults(),
    );
  }
}
