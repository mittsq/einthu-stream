import 'package:einthu_stream/adapter.dart';
import 'package:einthu_stream/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';
// import 'package:video_player/video_player.dart';
// import 'package:screen/screen.dart';

class PlayerScreen extends StatefulWidget {
  PlayerScreen({Key key, this.movie}) : super(key: key);

  final Result movie;

  @override
  _PlayerScreenState createState() => _PlayerScreenState(movie: movie);
}

class _PlayerScreenState extends State<PlayerScreen> {
  _PlayerScreenState({this.movie});
  Result movie;
  Future<String> _url;
  VideoPlayerController _controller;
  // bool _showControls = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        body: FutureBuilder(
          future: _url,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              case ConnectionState.done:
                if (snapshot.hasData) {
                  _controller = VideoPlayerController.network(snapshot.data);
                  return Chewie(
                    _controller,
                    autoInitialize: true,
                    autoPlay: true,
                    fullScreenByDefault: true,
                    // placeholder: ,
                  );
                }
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.error),
                      Text('Something went wrong'),
                    ],
                  ),
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // _init();
    _url = Adapter.resolve(movie.id);
  }

  // void _init() async {
  //   final url = await Adapter.resolve(movie.id);
  //   _controller = VideoPlayerController.network(url);
  //   await _controller.initialize();
  //   setState(() {
  //     _controller.play();
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   final bar = AppBar(
  //     backgroundColor: Colors.transparent,
  //   );

  //   //_controller.value.isPlaying
  //   // ? _controller.pause()
  //   // : _controller.play();

  //   final stack = <Widget>[
  //     GestureDetector(
  //       onTap: () {
  //         setState(() {
  //           _showControls = !_showControls;
  //         });
  //       },
  //       child: _controller != null && _controller.value.initialized
  //           ? /* FittedBox(
  //               fit: BoxFit.cover,
  //               alignment: Alignment.center,
  //               child: AspectRatio(
  //                 aspectRatio: _controller.value.aspectRatio,
  //               child: */
  //           VideoPlayer(_controller) //,
  //           // ),
  //           // )
  //           : Center(child: CircularProgressIndicator()),
  //     ),
  //   ];

  //   if (_showControls) {
  //     // SystemChrome.setEnabledSystemUIOverlays(
  //     //     <SystemUiOverlay>[SystemUiOverlay.top]);

  //     stack.add(Column(
  //       children: <Widget>[
  //         Container(
  //           height: bar.preferredSize.height,
  //           child: bar,
  //         ),
  //         Expanded(
  //           child: Container(),
  //         ),
  //         Container(
  //           height: bar.preferredSize.height,
  //           child: Row(
  //             children: <Widget>[
  //               IconButton(
  //                 icon: Icon(_controller != null && _controller.value.isPlaying
  //                     ? Icons.pause
  //                     : Icons.play_arrow),
  //                 onPressed: () {
  //                   setState(() {
  //                     _controller.value.isPlaying
  //                         ? _controller.pause()
  //                         : _controller.play();
  //                   });
  //                 },
  //               )
  //             ],
  //           ),
  //         ),
  //       ],
  //     ));
  //   }

  //   return Theme(
  //     data: ThemeData.dark(),
  //     child: Scaffold(
  //       body: Stack(
  //         children: stack,
  //       ),
  //     ),
  //   );
  // }
}
