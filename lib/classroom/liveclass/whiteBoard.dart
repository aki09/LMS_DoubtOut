import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doubt_out/widgets/alertBox.dart';
import 'package:flutter/material.dart';
// import 'package:web_socket_channel/io.dart';
import 'package:whiteboardkit/drawing_controller.dart';
import 'package:whiteboardkit/whiteboard.dart';
import 'package:whiteboardkit/whiteboardkit.dart';

String documentId;
Firestore _firestore = Firestore.instance;

class WhiteBoardDemo extends StatefulWidget {
  WhiteBoardDemo({@required this.accountStatus});

  final int accountStatus;
  @override
  _WhiteBoardDemoState createState() => _WhiteBoardDemoState();
}

class _WhiteBoardDemoState extends State<WhiteBoardDemo> {
  DrawingController controller1;

  // final channel = IOWebSocketChannel.connect('ws://echo.websocket.org');

  // PlayerController controller;

  @override
  void initState() {
    var ref = _firestore.collection('whiteBoard').add({
      'data': '',
    });
    ref.then((value) {
      print(value.documentID);
      documentId = value.documentID;
    });
    controller1 = new DrawingController(enableChunk: true);

    controller1.onChange().listen((draw) {
      // channel.sink.add(draw.toJson());
      var ref = _firestore
          .collection('whiteBoard')
          .document(documentId)
          .updateData({'data': draw.toJson()});
    });
    super.initState();
  }

  @override
  void dispose() {
    controller1.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: WillPopScope(
        onWillPop: () async {
          await exitWhiteBoard(
            context,
            Text('Do you want to exit?'),
          );
        },
        child: Center(
            child:
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                widget.accountStatus == 1
                    ? Expanded(
                        child: Whiteboard(
                          controller: controller1,
                          style: WhiteboardStyle(),
                        ),
                      )
                    : Container(
                        height: height * 0.5,
                        child: StreamBuilder(
                          stream: _firestore
                              .collection('whiteBoard')
                              .document(documentId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            // print(snapshot.data['data']);
                            if (snapshot.hasData && snapshot.data != null) {
                              return Container(
                                height: height * 0.5,
                                child: CustomPaint(
                                  painter:
                                      LiveBoard(snapshot.data, height, width),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      )),
      ),
    );
  }
}

class LiveBoard extends CustomPainter {
  LiveBoard(this.document, this.height, this.width);
  final DocumentSnapshot document;
  final double width;
  final double height;
  @override
  void paint(Canvas canvas, Size size) async {
    // var ref =
    //     await _firestore.collection('whiteBoard').document(documentId).get();
    var start, end;
    // print(ref.data['data']['lines'];
    var heightRatio = document.data['data']['height'] / height;
    var widthRatio = document.data['data']['width'] / width;
    var lines = document.data['data']['lines'];
    var paint = Paint();
    for (int line = 0; line < lines.length; line++) {
      // print(lines[line]);
      paint.strokeWidth = lines[line]['width'];
      for (int point = 0; point < lines[line]['points'].length - 1; point++) {
        // print(lines[line]['points'][point]);
        start = lines[line]['points'][point];
        end = lines[line]['points'][point + 1];
        // print(start);
        paint.color = Colors.blue;
        canvas.drawLine(
          Offset(start['x'] * heightRatio, start['y'] * widthRatio),
          Offset(end['x'] * heightRatio, end['y'] * widthRatio),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
