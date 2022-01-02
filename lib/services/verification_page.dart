import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:doubt_out/classroom/classroom.dart';
import 'package:doubt_out/homePage.dart';
import 'package:doubt_out/home_page_teacher.dart';
import 'package:doubt_out/loginPage.dart';
import 'package:doubt_out/model/userData.dart';
import 'package:doubt_out/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Verification extends StatefulWidget {
  Verification({this.userId});
  String userId;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VerificationState();
  }
}

class _VerificationState extends State<Verification> {
  String _userEmail;
  String getEmail() {
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        _userEmail = user.email;
      });
    });
    return _userEmail;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser().then((user) {
      setState(() {
        _userEmail = user.email;
      });
    });
  }

//Small issue here while loading it takes null value first then start our code
  //will work in this when our app will have major issue due to this
  @override
  Widget build(BuildContext context) {
    print(_userEmail);
    return Scaffold(
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('UserRole')
            .where('email', isEqualTo: _userEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Text(
                'PLEASE WAIT ',
                style: DefaultTextStyle.of(context)
                    .style
                    .apply(fontSizeFactor: 2.0),
              ),
            );
          }
          if (snapshot.hasError) {
            _roleValidation();
          }
          var doc;
          if (snapshot.data.documents.length != 0)
            doc = snapshot.data.documents[0];

          if (snapshot.data.documents.length != 0 && doc['role'] == 'teacher') {
            UserData().setAccountStatus(1);
            UserData()
                .setUserLoggedIn(_userEmail, widget.userId, doc['name'], '');
            UserData().setUserStatus();
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            // builder: (context) =>
            return HomePageTeacher(
              uid: widget.userId,
              name: doc['name'],
              email: _userEmail,
              school: doc['school'],
              classOrSubject: doc['classOrSubject'],
            );
            // ),
            // );
          }
          if (snapshot.data.documents.length != 0 && doc['role'] == 'student') {
            UserData().setAccountStatus(2);
            UserData()
                .setUserLoggedIn(_userEmail, widget.userId, doc['name'], '');
            UserData().setUserStatus();
              
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            return ClassRoom(
              uid: widget.userId,
              name: doc['name'],
              email: _userEmail,
              school: doc['school'],
              classOrSubject: doc['classOrSubject'],
            );

            // );
          }
          return _roleValidation();
        },
      ),
    );
  }

  _roleValidation() {
    Auth auth = new Auth();
    return Scaffold(
      appBar: AppBar(title: Text('NO ENTRY FOUND')),
      body: AlertDialog(
        title: Text('NO ENTRY POINT'),
        content: Text('PLEASE CONTACT ADMISSION DEPARTMENT'),
        actions: <Widget>[
          RaisedButton(
            child: Text(
              'EXIT',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () => {
              auth.signOut(),
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => LoginPage()))
            },
          )
        ],
      ),
    );
  }
}
