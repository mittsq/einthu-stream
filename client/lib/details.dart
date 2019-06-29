import 'package:einthu_stream/adapter.dart';
import 'package:einthu_stream/result.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class DetailScreen extends StatefulWidget {
  DetailScreen({this.movie});

  final Result movie;

  @override
  State<StatefulWidget> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Widget _icon = Icon(Icons.play_arrow);
  bool _isResolving = false;
  Future<String> _desc;

  @override
  void initState() {
    super.initState();
    _desc = widget.movie.description;
  }

  Future<String> _getUrl() async {
    return Adapter.resolve(widget.movie.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.movie.title),
        actions: <Widget>[
          // IconButton(icon: Icon(Icons.cast)),
          PopupMenuButton(
            itemBuilder: (context) => <PopupMenuEntry>[
                  PopupMenuItem(
                    child: Text('Watch trailer'),
                    value: 1,
                    enabled: widget.movie.trailer != null,
                  ),
                  PopupMenuItem(
                    child: Text('Visit wiki page'),
                    value: 2,
                    enabled: widget.movie.wiki != null,
                  ),
                ],
            onSelected: (i) async {
              switch (i) {
                case 1:
                  await launcher.launch(widget.movie.trailer);
                  break;
                case 2:
                  await launcher.launch(widget.movie.wiki);
                  break;
                default:
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).accentColor,
        tooltip: 'Watch',
        onPressed: () async {
          setState(() {
            _icon = SizedBox.fromSize(
              size: Size(24, 24),
              child: CircularProgressIndicator(),
            );
          });
          _isResolving = true;
          final url = await _getUrl();
          _isResolving = false;
          setState(() {
            _icon = Icon(Icons.play_arrow);
          });
          launcher.launch(url);
        },
        child: _icon,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        primary: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(8),
              child: Center(
                child: CoverHero(
                  movie: widget.movie,
                  width: 180,
                  height: 270,
                ),
              ),
            ),
            Center(
              child: Text(
                '${widget.movie.language} • ${widget.movie.year}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: FutureBuilder(
                future: _desc,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.done:
                      if (snapshot.hasError)
                        return Text('Could not load description ...');
                      return Text(snapshot.data, textAlign: TextAlign.justify);
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Text('Loading description ...');
                    default:
                      return Text('');
                  }
                },
              ),
            ),
            //            Padding(
            //              padding: EdgeInsets.all(8),
            //              child: Column(
            //                crossAxisAlignment: CrossAxisAlignment.stretch,
            //                children: <Widget>[
            //                  Text('Action'),
            //                  Text('Comedy'),
            //                  Text('Romance'),
            //                  Text('Story'),
            //                  Text('Acting'),
            //                ],
            //              ),
            //            ),
            Text(
              'Starring ...',
              style: TextStyle(fontSize: 18),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.movie.professionals.length,
                primary: false,
                itemBuilder: (context, i) {
                  final p = widget.movie.professionals[i];
                  return Padding(
                    padding: EdgeInsets.all(4),
                    child: Row(
                      children: <Widget>[
                        p.avatar == null
                            ? Image.asset(
                                'assets/placeholder.png',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                p.avatar,
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                p.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(p.role),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
