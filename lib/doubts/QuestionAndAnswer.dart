import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/userData.dart';
import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
// import 'package:google_fonts/google_fonts.dart';

class QandAList extends StatefulWidget {
  QandAList({@required this.record});
  final record;
  @override
  _QandAListState createState() => _QandAListState();
}

class _QandAListState extends State<QandAList> {
  final _firestore = Firestore.instance;

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'April',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  List<String> data;
  String uid, name, pic;

  getUserData() async {
    data = await UserData().getUserData();
    uid = data[0];
    name = data[1];
    pic = data[2];
    print(name);
  }

  @override
  void initState() {
    super.initState();
    print(widget.record.question);
    print(widget.record.question_image_url);
  }

  @override
  Widget build(BuildContext context) {
    final record1 = widget.record;
    String question = record1.question;
    String answer = record1.answer;
    String subject = record1.subject_name;

    return Material(
        child: Scaffold(
            appBar: AppBar(
              title: Text('DoubtOut Q&A'),
              backgroundColor: Color(0xFFF57F17),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color(0xFFffce45),
                            Color(0xFFF9A825),
                            Color(0xFFffce45)
                          ]),
                          borderRadius: BorderRadius.circular(0.0),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFFF9A825).withOpacity(.3),
                                offset: Offset(0.4, 0.4),
                                blurRadius: 8.0)
                          ]),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: Center(
                            child: Text('SUBJECT : $subject',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlipCard(
                    direction: FlipDirection.HORIZONTAL, // default
                    front: Container(
                      color: Colors.yellow,
                      height: 500,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Question',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          Center(
                            child: Image(
                              image: NetworkImage(
                                record1.question_image_url,
                              ),
                              height: 450,
                            ),
                          ),
                        ],
                      ),
                    ),
                    back: Container(
                      color: Colors.yellow,
                      height: 500,
                      child: Column(
                        children: <Widget>[
                          Center(
                              child: Text('ANSWER',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold))),
                          Image(
                            image: getAnswer(record1),
                            height: 450,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  getAnswer(record1) {
    String url = record1.answer_image_url;
    if (url != null) {
      return NetworkImage(record1.answer_image_url);
    } else {
      return AssetImage('assets/logo.png');
    }
  }
}
