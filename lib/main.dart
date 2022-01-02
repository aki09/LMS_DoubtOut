import 'package:flutter/material.dart';
import 'splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Handlee',
        primaryColor: Color(0xffffce45)
      ),
      home: SplashScreen(),
    );
  }
}
