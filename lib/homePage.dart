import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doubt_out/auth/google.dart';
import 'package:doubt_out/classroom/AssignmentList.dart';
import 'package:doubt_out/classroom/classroom.dart';
import 'package:doubt_out/loginPage.dart';
import 'package:doubt_out/model/userData.dart';
import 'package:doubt_out/profilePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'doubts/feedMain.dart';
import 'doubts/postDoubtScreen.dart';
import 'doubts/chatScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({this.uid,this.name,this.email,this.school,this.classOrSubject});
  String email;
  String name;
  String uid;
  String school;
  String classOrSubject;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  Map<String,dynamic> list;
  final FirebaseMessaging _messaging = FirebaseMessaging();
  int _selectedIndex = 0, accountStatus;
  List<String> data = [];
  String name, email, photoUrl, id,uid;
  setImage(ImageSource source) async {
    PickedFile image = await ImagePicker().getImage(
      source: source,
    );
    // print(image.path);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDoubtScreen(
          subject:widget.classOrSubject,
          image: File(image.path),
          uid: id,
          accountStatus: accountStatus,
        ),
      ),
    );
  }
  

  getUserData() async {
    data = await UserData().getUserData();
    var status = await UserData().getAccountStatus();
    setState(() {
      uid=data[0];
      name = data[1];
      email = data[2];
      photoUrl = data[3];
      id = data[4];
      accountStatus = status;
      // print(data);
    });
  }

  @override

  void initState() {
    getUserData();
    super.initState();
    _messaging.getToken().then((token) { 
      // print(token);
      String str;


      Firestore.instance.collection('pushIdTokens').where('tokenId' ,isEqualTo: token).getDocuments().then((value) {
        value.documents.forEach((f)=>
        {
          // print('Hello1234'),
          // print(f.documentID.codeUnitAt(0)),

          Firestore.instance.collection('pushIdTokens')
              .document(f.documentID).delete(),

        } );
        }).then((value) =>Firestore.instance.collection('pushIdTokens').add({'tokenId':token}));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doubt Out'),
      ),
      body: _selectedIndex == 0
          ? FeedMain(
              name: name,
              email: email,
              uid: uid,
              photoUrl: photoUrl,
              accountStatus: accountStatus,
              subject:widget.classOrSubject,
            )
          :_selectedIndex==1? AssignmentList(subjectName: widget.classOrSubject,):ProfilePage(),
      floatingActionButton: _selectedIndex == 0
          ? SpeedDial(
              // onPressed: () {},
              animatedIcon: AnimatedIcons.menu_close,
              backgroundColor: Color(0xFFF57F17),
              children: [
                SpeedDialChild(
                    child: Icon(Icons.chat),
                    backgroundColor: Colors.green,
                    label: 'Chat',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(email: widget.email,),
                        ),
                      );
                    }),
                SpeedDialChild(
                  child: Icon(Icons.pan_tool),
                  label: 'Ask a Doubt',
                  backgroundColor: Colors.pink,
                  onTap: () {
                    setImage(ImageSource.camera);
                  },
                ),
                SpeedDialChild(
                  child: Icon(Icons.photo_library),
                  label: 'Open Gallery',
                  backgroundColor: Colors.cyan,
                  onTap: () {
                    setImage(ImageSource.gallery);
                  },
                ),
              ],
            )
          : Container(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 28.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.message,
              color: Color(0xFFF9A825),
            ),
            title: Text(
              'Doubts',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w100,
                color: Color(0xFFF57F17),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.tv,
              color: Color(0xFFF9A825),
            ),
            title: Text(
              'Classroom',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w100,
                  color: Color(0xFFF57F17)),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Color(0xFFF9A825),
            ),
            title: Text(
              'Profile',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w100,
                  color: Color(0xFFF57F17)),
            ),
          )
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}