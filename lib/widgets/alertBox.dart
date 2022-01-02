import 'package:flutter/material.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';

dialogBox(BuildContext context, Widget content) {
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
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

addLinkDialog(BuildContext context) {
  String link;

  AlertDialog alert = AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6.0),
    ),
    // contentPadding: EdgeInsets.all(0),
    content: TextField(
      decoration: InputDecoration(hintText: 'Add a link'),
      onChanged: (val) {
        link = val;
      },
    ),
    actions: <Widget>[
      FlatButton(
        child: Text('Cancel'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text('Add'),
        onPressed: () {
          Navigator.pop(context, link);
        },
      ),
    ],
    contentTextStyle: TextStyle(
      fontSize: 24.0,
      color: Colors.black,
    ),
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  ).then((value) => link);
}

disapperDialog(BuildContext context, Widget content) {
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
  );
  showDialog(
    context: context,
    builder: (BuildContext context) {
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      });
      return alert;
    },
  );
}

exitWhiteBoard(BuildContext context, Widget content) {
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
        child: Text('Keep'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      FlatButton(
        child: Text('Exit'),
        onPressed: () {
          Navigator.pop(context);
          Navigator.pop(context);
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

stopRecording(context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(
          'Stop the Recording',
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Stop Recording'),
            color: Colors.yellow,
            onPressed: () async {
              String path = await FlutterScreenRecording.stopRecordScreen;
              print(path);
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}
