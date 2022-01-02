import 'package:doubt_out/classroom/liveclass/liveClasses.dart';
import 'package:doubt_out/classroom/liveclass/submitAnswer.dart';
import 'package:doubt_out/homePage.dart';
import 'package:doubt_out/home_page_teacher.dart';
import 'package:doubt_out/loginPage.dart';
import 'package:doubt_out/model/userData.dart';
import 'package:doubt_out/profilePage.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'classroom/classroom.dart';

// Future<dynamic> myBackgroundHandlere(Map<String, dynamic> message) {
//   if (message.containsKey('Feed')) {
//     print('Feed page');
//   } else if (message.containsKey('poll')) {
//     print('poll page');
//   } else if (message.containsKey('live')) {
//     print('live class');
//   }
// }

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //check for user already logged in or not.....
  initialLogic() async {
    print('firebase messaging checking.............');
    // FirebaseMessaging().configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => ProfilePage(),
    //       ),
    //     );
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {},
    //   onResume: (Map<String, dynamic> message) async {},
    //   onBackgroundMessage: myBackgroundHandlere,
    // );
    var account = await UserData().getAccountStatus();
    var data = await UserData().getUserLoggedIn();
    var status = await UserData().getUserStatus();
    print(status);
    try {
      if (data && status) {
        if (account == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageTeacher(
                  // uid: userData[0],
                  // accountStatus: 0,
                  ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ClassRoom(
                  // uid: userData[0],
                  // accountStatus: 0,
                  ),
            ),
          );
        }
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      }
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    }

    //  else {

    // }
  }

  @override
  void initState() {
    initialLogic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
