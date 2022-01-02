import 'package:animated_button/animated_button.dart';
import 'package:doubt_out/classroom/liveclass/goLive.dart';
import 'package:doubt_out/classroom/liveclass/whiteBoard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'createMeeting.dart';
import 'joinMeeting.dart';

class LiveClasses extends StatefulWidget {
  LiveClasses({
    @required this.subjectName,
    @required this.accountStatus,
  });
  final String subjectName;
  final int accountStatus;
  @override
  _LiveClassesState createState() => _LiveClassesState();
}

class _LiveClassesState extends State<LiveClasses> {
  Firestore _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Expanded(
      child: Column(
        children: <Widget>[
          SizedBox(height: height * 0.05),
          widget.accountStatus == 2
              ? Container(
                  //join meeting
                  child: AnimatedButton(
                    color: Colors.amberAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Join a meeting',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JoinMeeting(
                            subject: widget.subjectName,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  //create meeting
                  child: AnimatedButton(
                    color: Colors.amberAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Create a meeting',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateMeeting(
                            subject: widget.subjectName,
                          ),
                        ),
                      );
                    },
                  ),
                ),
          SizedBox(height: height * 0.02),
          Container(
            //White board
            child: AnimatedButton(
              color: Colors.amberAccent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'White Board',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WhiteBoardDemo(accountStatus: widget.accountStatus,),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: height * 0.03),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width * 0.3,
                child: Divider(
                  color: Color(0xFFffce45),
                ),
              ),
              Text('or'),
              Container(
                width: width * 0.3,
                child: Divider(
                  color: Color(0xFFffce45),
                ),
              ),
            ],
          ),
          SizedBox(height: height * 0.03),
          Container(
            //create meeting
            child: AnimatedButton(
              color: Colors.amberAccent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Go live ',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoLive(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
