import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../homePage.dart';
import '../model/userData.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class PostDoubtScreen extends StatefulWidget {
  PostDoubtScreen(
      {@required this.image,
      @required this.uid,
      @required this.accountStatus,
      this.subject});
  final String subject;
  final File image;
  final String uid;
  final int accountStatus;
  @override
  _PostDoubtScreenState createState() => _PostDoubtScreenState();
}

class _PostDoubtScreenState extends State<PostDoubtScreen> {
  List<String> data = [];
  String email, uid, name, imageUrl, profilePic;
  // TextEditingController _subject = TextEditingController();
  TextEditingController _question = TextEditingController();
  final _firestore = Firestore.instance;
  ProgressDialog pr;
  int accountStatus;

  getUserData() async {
    data = await UserData().getUserData();
    accountStatus = await UserData().getAccountStatus();
    print(data);
    name = data[1];
    email = data[2];
    profilePic = data[3];
    uid = data[4];
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String uid = widget.uid;
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Uploading your Doubt',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w700),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 14.0, fontWeight: FontWeight.w600));

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ask Your Doubt'),
        backgroundColor: Color(0xFFF57F17),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(14.0),
          child: Column(
            children: <Widget>[
              // Row(
              //   children: <Widget>[
              //     Text(
              //       'Subject: ',
              //       style: TextStyle(
              //         fontSize: height * 0.025,
              //       ),
              //     ),
              //     Flexible(
              //       child: TextField(
              //         controller: _subject,
              //         decoration:
              //             InputDecoration(hintText: 'Name of the subject'),
              //       ),
              //     ),
              //   ],
              // ),
              Row(
                children: <Widget>[
                  Text(
                    'Question: ',
                    style: TextStyle(
                      fontSize: height * 0.025,
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: _question,
                      decoration:
                          InputDecoration(hintText: 'Type your question'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.1),
              Container(
                height: height * 0.3,
                width: width,
                child: Image(
                  image: FileImage(widget.image),
                  // fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(height: height * 0.1),
              FlatButton(
                color: Color(0xFFffce45),
                child: Text(
                  "SUBMIT",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                onPressed: () async {
                  print('submitted');
                  print(uid);
                  print(name);

                  pr.show();
                  // int accountStatus = widget.accountStatus;

                  // Future.delayed(Duration(seconds: 4)).then((value) {
                  //   pr.hide().whenComplete(() {

                  //   });
                  // });

                  /*   Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));*/

                  Toast.show('Your Doubt is Submitted', context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

                  int random = Random().nextInt(100000);

                  StorageReference _storageReference =
                      FirebaseStorage().ref().child('questions/$random/$name');
                  StorageUploadTask uploadTask =
                      _storageReference.putFile(widget.image);
                  //upload images to cloud storage
                  await uploadTask.onComplete;
                  _storageReference.getDownloadURL().then((fileURL) {
                    imageUrl = fileURL;
                    String id_doubt = widget.uid;

                    int time = DateTime.now().millisecondsSinceEpoch ~/ 1000;

                    if (imageUrl != null) {
                      //update the databse with details
                      _firestore
                          .collection('Feed')
                          .document(widget.subject)
                          .collection(widget.subject)
                          .add({
                        'name': name,
                        'email': email,
                        'subject_name': widget.subject,
                        'question': _question.text,
                        'question_time_stamp': time,
                        'question_image_url': imageUrl,
                        'profile_doubt_asked_url': profilePic,
                        'status': 0,
                        'uid': id_doubt
                      });
                      Navigator.of(context).pop();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(),
                        ),
                      );
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*InkWell(
                  child: Container(
                    //width: ScreenUtil.getInstance().setWidth(250),
                    //height: ScreenUtil.getInstance().setHeight(100),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFFffce45), Color(0xFFffce45)]),
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: [
                          BoxShadow(
                              color: Color(0xFFF9A825).withOpacity(.3),
                              offset: Offset(0.0, 8.0),
                              blurRadius: 8.0)
                        ]),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: Center(
                          child: Text("SUBMIT",
                              style: GoogleFonts.handlee(
                                  fontSize: 20, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ),
                ),*/
