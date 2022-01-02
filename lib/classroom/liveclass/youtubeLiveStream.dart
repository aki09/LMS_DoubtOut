import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeLiveStream extends StatefulWidget {
  @override
  _YoutubeLiveStreamState createState() => _YoutubeLiveStreamState();
}

class _YoutubeLiveStreamState extends State<YoutubeLiveStream> {
  final _formKey = GlobalKey<FormState>();
  YoutubePlayerController _controller;
  bool showAppbar = true;
  String url = '', videoId = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    if (url.length != 0) {
      _controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      key: _formKey,
      appBar: showAppbar
          ? AppBar(
              title: Text('Youtube Live Stream'),
            )
          : PreferredSize(
              child: Container(),
              preferredSize: Size(0.0, 0.0),
            ),
      body: url.length == 0
          ? Container(
              margin: EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: TextFormField(
                      decoration: InputDecoration(hintText: 'Enter the Url'),
                      onChanged: (val) {
                        url = val;
                      },
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  FlatButton(
                    color: Color(0xFFffce45),
                    child: Text(
                      'Join Live',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () async {
                      videoId = YoutubePlayer.convertUrlToId(url);
                      print(videoId);
                      _controller = YoutubePlayerController(
                        initialVideoId: videoId,
                        flags: YoutubePlayerFlags(
                          isLive: true,
                          captionLanguage: 'en',
                          autoPlay: true,
                          hideControls: false,
                          controlsVisibleAtStart: true,
                        ),
                      );
                      setState(() {
                        url.length;
                      });
                    },
                  )
                ],
              ),
            )
          : Container(
              child: YoutubePlayerBuilder(
                onEnterFullScreen: () {
                  setState(() {
                    showAppbar = false;
                  });
                },
                onExitFullScreen: () {
                  setState(() {
                    showAppbar = true;
                  });
                },
                player: YoutubePlayer(
                  controller: _controller,
                  liveUIColor: Color(0xFFffce45),
                ),
                builder: (context, player) {
                  return Column(
                    children: <Widget>[
                      player,
                    ],
                  );
                },
              ),
            ),
    );
  }
}
