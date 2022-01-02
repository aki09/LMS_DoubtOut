
import 'package:doubt_out/CheckProfile.dart';
import 'package:doubt_out/homePage.dart';
import 'package:doubt_out/services/authentication.dart';
import 'package:doubt_out/services/verification_page.dart';
import 'package:flutter/material.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}
class RootPageStudent extends StatefulWidget{
  RootPageStudent({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RootPageStateStudent();
  }

}

class _RootPageStateStudent extends State<RootPageStudent> {
  AuthStatus authStatus = AuthStatus.NOT_LOGGED_IN;
  String _userId = "";

  @override
  // ignore: must_call_super
  void initState() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null)
          _userId = user?.uid;
        authStatus =
        user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        loginCallback();
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return  TeacherCodeCheck(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return Verification(userId: _userId,);
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
