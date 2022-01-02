import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:http/http.dart' as http;

class GoLive extends StatefulWidget {
  @override
  _GoLiveState createState() => _GoLiveState();
}

class _GoLiveState extends State<GoLive> {
  getUser() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // final user = await FirebaseAuth.instance.currentUser();
    // final idToken = await user.getIdToken();
    // final token = idToken.token;
    // print(token);
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuth =
        await googleSignInAccount.authentication;

    final header = {"Authorization": 'Bearer ${googleSignInAuth.accessToken}'};

    http.Response res = await http.post(
      'https://www.googleapis.com/youtube/v3/liveStreams?key=AIzaSyA0d_JeJhlEPb1laJXYPgTxqVUNWOwxQIw',
      headers: header,
    );
    print(res.body);
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go Live'),
      ),
      body: Container(),
    );
  }
}
