import 'package:doubt_out/auth/google.dart';
import 'package:doubt_out/loginPage.dart';
import 'package:doubt_out/model/userData.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  var data;
  TextEditingController nameController,
      emailController,
      idController,
      dobController = TextEditingController();
  String image;
  bool editing = true;

  saveProfile(BuildContext context, Widget content) {
    // Create button
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      // contentPadding: EdgeInsets.all(0),
      content: content,
      contentTextStyle: TextStyle(
        fontSize: 24.0,
        color: Colors.black,
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('Discard'),
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              editing = false;
            });
          },
        ),
        FlatButton(
          child: Text('Save'),
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              editing = true;
            });
          },
        )
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  getData() async {
    data = await UserData().getUserData();
    setState(() {
      nameController = TextEditingController(text: data[1]);
      emailController = TextEditingController(text: data[2]);
      idController = TextEditingController(text: data[4]);
      image = data[3];
    });
    print(data);
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        if (!editing) {
          await saveProfile(context, Text('Unsaved Changes'));
        } else if (editing) {
          return editing;
        }
      },
      child: SingleChildScrollView(
        physics: ScrollPhysics(parent: BouncingScrollPhysics()),
        child: Container(
            margin: EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: image != null
                      ? ClipOval(
                          child: CircleAvatar(
                            radius: width * 0.12,
                            child: Image.network(image),
                          ),
                        )
                      : CircleAvatar(
                          radius: width * 0.12,
                        ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: editing
                      ? FlatButton(
                          color: Color(0xFFffce45),
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          onPressed: () {
                            setState(() {
                              editing = false;
                            });
                          },
                        )
                      : FlatButton(
                          color: Color(0xFFffce45),
                          child: Text(
                            'Save Profile',
                            style: TextStyle(fontSize: 12.0),
                          ),
                          onPressed: () {
                            setState(() {
                              editing = true;
                            });
                          },
                        ),
                ),
                Text('Name'),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        controller: nameController,
                        readOnly: editing,
                        decoration: InputDecoration(
                            hintText: 'Enter your name (required)',
                            suffixIcon: editing
                                ? Icon(Icons.verified_user)
                                : Icon(Icons.edit),
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Text('Student Id'),
                // SizedBox(width: width * 0.05),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        readOnly: true,
                        controller: idController,
                        decoration: InputDecoration(
                            hintText: 'Enter your Id',
                            fillColor: Colors.grey[300],
                            // focusColor: Colors.grey,
                            focusedBorder: OutlineInputBorder(),
                            filled: true,
                            border: OutlineInputBorder()
                            // border: InputBorder.none,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Text('Email'),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        readOnly: true,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your Email',
                          border: OutlineInputBorder(),
                          fillColor: Colors.grey[300],
                          focusedBorder: OutlineInputBorder(),
                          // focusColor: Colors.grey,
                          filled: true,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.s,
                  children: <Widget>[
                    Expanded(
                      child: Text('Class'),
                    ),
                    Expanded(
                      child: Text('Section'),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        readOnly: editing,
                        decoration: InputDecoration(
                          suffixIcon: editing
                              ? Icon(Icons.verified_user)
                              : Icon(Icons.edit),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.05),
                    Flexible(
                      child: TextFormField(
                        readOnly: editing,
                        decoration: InputDecoration(
                          suffixIcon: editing
                              ? Icon(Icons.verified_user)
                              : Icon(Icons.edit),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
                Text('Date of birth'),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
                        controller: dobController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Add your DOB',
                          border: OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: editing
                                ? Container()
                                : Icon(Icons.calendar_today),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return CalendarDatePicker(
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1980),
                                    lastDate: DateTime(2025),
                                    onDateChanged: (val) {
                                      setState(() {
                                        dobController = TextEditingController(
                                            text:
                                                '${val.day}-${val.month}-${val.year}');
                                      });
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20,),
                Center(
                  child: RaisedButton(
                    color: Colors.yellow,
                    child: Text('Sign Out'),
                    onPressed: () async {
                      signOutGoogle();
                      await UserData().logoutUser();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
        ),
      ),
    );
  }
}
