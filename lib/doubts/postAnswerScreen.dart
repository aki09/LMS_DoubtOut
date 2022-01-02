import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../homePage.dart';
import '../model/userData.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

class PostAnswerScreen extends StatefulWidget {
  PostAnswerScreen(
      {@required this.image,
      this.record,
      @required this.ida,
      @required this.accountStatus});
  final File image;
  final record;
  final String ida;
  final int accountStatus;

  @override
  _PostAnswerScreenState createState() => _PostAnswerScreenState();
}

class _PostAnswerScreenState extends State<PostAnswerScreen> {
  List<String> data = [];
  String email, uid, name, imageUrl, profilePic;
  int accountStatus;
  TextEditingController _answer = TextEditingController();
  final _firestore = Firestore.instance;
  ProgressDialog pr;

  getUserData() async {
    data = await UserData().getUserData();
    accountStatus=await UserData().getAccountStatus();
    print(data);
    email = data[2];
    name = data[1];
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
    pr = new ProgressDialog(context);
    pr.style(
        message: 'Uploading Solution',
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
        title: Text('Enter the solution'),
        backgroundColor: Color(0xFFF57F17),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(14.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Solution: ',
                    style: TextStyle(
                      fontSize: height * 0.025,
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: _answer,
                      decoration:
                          InputDecoration(hintText: 'Type your solution'),
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
                  "UPDATE",
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

                  Future.delayed(Duration(seconds: 4)).then((value) {
                    pr.hide().whenComplete(() {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            // uid: uid,
                            // accountStatus: accountStatus,
                          ),
                        ),
                      );
                    });
                  });

                  print('This is the record : ${widget.record}');

                  Toast.show('Your Solution is Submitted', context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

                  int random = Random().nextInt(100000);

                  StorageReference _storageReference =
                      FirebaseStorage().ref().child('answers/$random/$name');
                  StorageUploadTask uploadTask =
                      _storageReference.putFile(widget.image);
                  //upload images to cloud storage
                  await uploadTask.onComplete;
                  _storageReference.getDownloadURL().then((fileURL) {
                    imageUrl = fileURL;

                    String idanswer = widget.ida;
                    print(
                        'THIS IS ANSWER UID CHECK FROM ANSWER PAGE : $idanswer');

                    int time = DateTime.now().millisecondsSinceEpoch ~/ 1000;

                    if (imageUrl != null) {
                      //updating answers to database to the selected list item by using DocumentReference()
                      widget.record.reference.updateData({
                        'answer': _answer.text,
                        'answer_time_stamp': time,
                        'answer_image_url': imageUrl,
                        'status': 1,
                        'answer_uid': widget.ida
                      });
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
