import 'package:doubt_out/homePage.dart';
import 'package:flutter/material.dart';
import 'AssignmentList.dart';

// ignore: must_be_immutable
class ClassRoom extends StatefulWidget {
  ClassRoom(
      {this.uid, this.name, this.email, this.school, this.classOrSubject});
  String email;
  String name;
  String uid;
  String school;
  String classOrSubject;
  @override
  _ClassRoomState createState() {
    return _ClassRoomState();
  }
}

class _ClassRoomState extends State<ClassRoom> {
  List<String> subjects = ['English', 'Hindi', 'Maths', 'Physics', 'Chemistry'];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          title: Text('Doubt Out'),
          centerTitle: true,
          leading: Container(),
        ),
        body: Container(
          height: height,
          child: ListView.separated(
            physics: ScrollPhysics(parent: BouncingScrollPhysics()),
            itemCount: subjects.length,
            separatorBuilder: (context, index) {
              return SizedBox(height: height * 0.03);
            },
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(
                        uid: widget.uid,
                        name: widget.name,
                        email: widget.email,
                        school: widget.school,
                        classOrSubject: subjects[index].toLowerCase(),
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  height: height * 0.1,
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
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      subjects[index],
                      style: TextStyle(
                        fontSize: height * 0.04,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
