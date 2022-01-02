// import 'package:doubt_out/model/userData.dart';
import 'package:doubt_out/CheckProfile.dart';
// import 'package:doubt_out/model/userData.dart';
import 'package:flutter/material.dart';

// import 'package:doubt_out/homePage.dart';

import 'auth/google.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // FirebaseUser _user;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        resizeToAvoidBottomPadding: true,
        body: Container(
          margin: EdgeInsets.all(6.0),
          child: Column(
            children: <Widget>[
              Container(
                height: height * 0.3,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Image.asset('assets/logo.png'),
                ),
              ),
              Text("DOUBT ?",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
              Text("OUT !",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
              SizedBox(
                height: height * 0.06,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AuthButtons(
                        buttonName: 'Sign In', width: width, height: height),
                    AuthButtons(
                        buttonName: 'Sign Up', width: width, height: height),

                    // Padding(
                    //   padding: EdgeInsets.all(20),
                    // ),
                    // InkWell(
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //         gradient: LinearGradient(
                    //             colors: [Color(0xFFffce45), Color(0xFFffce45)]),
                    //         borderRadius: BorderRadius.circular(6.0),
                    //         boxShadow: [
                    //           BoxShadow(
                    //               color: Color(0xFFF9A825).withOpacity(.3),
                    //               offset: Offset(0.0, 8.0),
                    //               blurRadius: 8.0)
                    //         ]),
                    //     child: Material(
                    //       color: Colors.transparent,
                    //       child: InkWell(
                    //         onTap: () {
                    //           Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //               builder: (context) => HomePage(),
                    //             ),
                    //           );
                    //         },
                    //         child: Center(
                    //           child: Text(
                    //             "SIGN UP",
                    //             style: TextStyle(
                    //               fontSize: 20,
                    //               fontWeight: FontWeight.w700,
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
              SizedBox(height: height * 0.1),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  horizontalLine(),
                  Text(
                    "or",
                    style: TextStyle(
                      fontSize: height * 0.025,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  horizontalLine(),
                ],
              ),
              SizedBox(
                height: height * 0.1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlineButton(
                    splashColor: Colors.black54,
                    onPressed: () async {
                      // bool data = await signInWithGoogle();
                      // if (data) {
                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => CheckProfile(),
                      //     ),
                      //   );
                      // }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40)),
                    highlightElevation: 0,
                    borderSide: BorderSide(color: Colors.grey),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/google_logo.png',
                            cacheHeight: 30,
                            cacheWidth: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  // OutlineButton(
                  //   child: Text(
                  //     "GOOGLE",
                  //     style: TextStyle(
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.w700,
                  //         color: Colors.black54),
                  //   ),
                  //   onPressed: () {
                  //     signInWithGoogle().then((value) {
                  //       if (value) {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => HomePage(),
                  //           ),
                  //         );
                  //       }
                  //     });
                  //   },
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.0),
        child: Container(
          width: 80,
          height: 2.0,
          color: Color(0xFFffce45).withOpacity(0.9),
        ),
      );
}

class AuthButtons extends StatelessWidget {
  const AuthButtons({
    @required this.buttonName,
    @required this.width,
    @required this.height,
  });

  final double width;
  final double height;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckProfile(),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.all(12.0),
          width: width * 0.2,
          height: height * 0.06,
          decoration: BoxDecoration(
            gradient:
                LinearGradient(colors: [Color(0xFFffce45), Color(0xFFffce45)]),
            borderRadius: BorderRadius.circular(6.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFFF9A825).withOpacity(.3),
                  offset: Offset(0.0, 8.0),
                  blurRadius: 8.0)
            ],
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              buttonName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
