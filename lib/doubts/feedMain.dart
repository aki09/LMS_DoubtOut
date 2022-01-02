import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'QuestionAndAnswer.dart';
import '../model/userData.dart';
import 'postAnswerScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../RecordUsers.dart';

class FeedMain extends StatefulWidget {
  FeedMain({
    @required this.email,
    @required this.uid,
    @required this.name,
    @required this.photoUrl,
    @required this.accountStatus,
    @required this.subject,
  });

  final String email;
  final String uid;
  final String name;
  final String photoUrl;
  final int accountStatus;
  final String subject;

  @override
  _FeedMainState createState() => _FeedMainState();
}

class _FeedMainState extends State<FeedMain> {
  final _firestore = Firestore.instance;
  bool val = false;
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
  String uid, name, pic, email;
  int accountStatus;

  getUserData() async {
    // print(widget.subject);
    data = await UserData().getUserData();
    email = data[0];
    uid = data[1];
    name = data[2];
    pic = data[3];
    // print('THIS IS CURRENT USER NAME CHECK FROM FEED MAIN PAGE $name');
    setState(() {
      accountStatus = widget.accountStatus;
    });
    // print(accountStatus);
  }

  setImage(ImageSource source, DocumentSnapshot data) async {
    String ida = widget.uid;
    int accountStatus = widget.accountStatus;
    // print(accountStatus);
    PickedFile image = await ImagePicker().getImage(
      source: source,
    );
    if (image.path != null) {
      // print(image.path);
      final record = RecordFeed.fromSnapshot(data);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostAnswerScreen(
            image: File(image.path),
            record: record,
            ida: ida,
            accountStatus: accountStatus,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    int accountStatus = widget.accountStatus;
    return Scaffold(body: _card(context));
  }

  Widget _card(BuildContext context) {
    String checkID = widget.uid;
    // print('This is ID check from Feed Page $checkID');

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            child: Container(
              padding:
                  EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
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
                  child: Row(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                            ),
                            Text(
                              'Doubts posted by others',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5),
                            ),
                            InkWell(
                              child: Center(
                                child: Checkbox(
                                    value: val,
                                    onChanged: (value) {
                                      setState(() {
                                        String checkID = widget.uid;
                                        // print(
                                        //     'This is ID check from Feed Page $checkID');
                                        val = value;
                                      });
                                    }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ),
          Flexible(
            child: _buildBodyMain(context),
          ),
        ],
      ),
    );
  }

  Stream _getStream() {
    var epochVal = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    epochVal = epochVal - 86400;
    var firestore = Firestore.instance;
    String currentUser = name;
    bool stuff = val;
    // print(stuff);
    String checkID = widget.uid;
    // print('.................................$checkID');
    // print('This is ID check from Feed Page $checkID');
    if (stuff == true) {
      var qs = firestore
          .collectionGroup("Feed")
          // .document(widget.subject)
          // .collection(widget.subject)
          .where('subject_name', isEqualTo: widget.subject)
          .orderBy('question_time_stamp')
          .snapshots();
      return qs;
    } else if (stuff == false) {
      var qs = firestore
          .collectionGroup("Feed")
          // .document(widget.subject)
          // .collection(widget.subject)
          .where('email', isEqualTo: widget.email)
          .where('subject_name', isEqualTo: widget.subject)
          .orderBy("question_time_stamp")
          .snapshots();
      return qs;
    }
  }

  Widget _buildBodyMain(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _getStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          }

          // if(!snapshot.hasData && snapshot.data.documents.length==0){
          //   return Container(child: Text('No doubts posted'),);
          // }
          return _buildList(context, snapshot.data.documents);
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Scaffold(
      body: ListView(
        children:
            (snapshot.map((data) => _buildListTile(context, data)).toList()),
      ),
    );
  }

  alertForUpload(DocumentSnapshot data) {
    final controller = TextEditingController();
    final record = RecordFeed.fromSnapshot(data);
    int time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return Alert(
      context: context,
      title: 'Upload the Solution',
      desc: 'Please choose the option to upload',
      content: Form(
        child: Column(
          children: <Widget>[
            /*TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Reason for Disapproval'),
            )*/
          ],
        ),
      ),
      buttons: [
        DialogButton(
          color: Color(0xFFF9A825),
          child: Text('Open Camera'),
          onPressed: () {
            setImage(ImageSource.camera, data);
            record.reference.updateData({
              'answer_time_stamp': time,
              'answer': controller.text,
            });
            Navigator.pop(context);
          },
        ),
        DialogButton(
          color: Color(0xFFF9A825),
          child: Text('Open Gallery'),
          onPressed: () {
            setImage(ImageSource.gallery, data);
            record.reference.updateData({
              'answer_time_stamp': time,
              'answer': controller.text,
            });
            Navigator.pop(context);
          },
        )
      ],
    ).show();
  }

  Widget _buildListTile(BuildContext context, DocumentSnapshot data) {
    final record = RecordFeed.fromSnapshot(data);
    int myvalue = record.question_time_stamp;
    int accountStatus = widget.accountStatus;
    final df = new DateFormat('dd-MM-yyyy hh:mm a');
    String finalTime =
        df.format(new DateTime.fromMillisecondsSinceEpoch(myvalue * 1000));
    String question = record.question;
    // print('Question is $question');
    String subject_name = record.subject_name;
    // print('Subject is $subject_name');
    String url = record.question_image_url;
    // print(url);
    String name = record.name;
    int solved = data.data['status'];
    String defaultPhoto =
        'https://banner2.cleanpng.com/20190717/icr/kisspng-computer-icons-race-14-business-avatar-application-5d2f03c184ded7.4186435015633622415443.jpg';
    String photo = record.profile_doubt_asked_url;
    photoMethod() {
      if (photo != null) {
        return photo;
      } else {
        return defaultPhoto;
      }
    }

    optionForAnswerUpload() {
      if (accountStatus == 1) {
        return IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            alertForUpload(data);
          },
        );
      } else {
        return Container(
          width: 10,
        );
      }
    }

    // print(name);

    return Container(
      padding: EdgeInsets.all(10),
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QandAList(
                record: record,
              ),
            ),
          );
        },
        child: Card(
          borderOnForeground: true,
          color: Colors.yellow,
          child: Center(
            child: Container(
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.circular(25.0),
              ),
              padding: EdgeInsets.fromLTRB(0, 0, 5, 5),
              height: MediaQuery.of(context).size.height * 0.14,
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    image: NetworkImage(photoMethod()),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                title: Container(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Text(
                    'Subject : $subject_name',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                subtitle: Column(
                  children: <Widget>[
                    Text(
                      'Question : $question',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    solved == 1
                        ? Text(
                            'Solved',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16.0,
                            ),
                          )
                        : Text(''),
                  ],
                ),
                trailing: optionForAnswerUpload(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getAnswer(record) {
    String url = record.answer_image_url;
    if (url != null) {
      return NetworkImage(record.answer_image_url);
    } else {
      return AssetImage('assets/logo.png');
    }
  }
}

/* Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Row(
                  children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QandAList(
                                        record: record,
                                      )));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Center(
                            child: ClipOval(
                              child: Image(
                                image: NetworkImage(url),
                                width: 120,
                                height: 120,
                                semanticLabel: 'Question',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        )),
                    InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QandAList(
                                        record: record,
                                      )));
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: ClipOval(
                              child: Image(
                                image: getAnswer(record),
                                width: 120,
                                height: 120,
                                semanticLabel: 'Answer',
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),*/
