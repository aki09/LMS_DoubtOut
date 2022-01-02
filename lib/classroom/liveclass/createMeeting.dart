import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doubt_out/model/userData.dart';
import 'package:doubt_out/widgets/alertBox.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:jitsi_meet/jitsi_meeting_listener.dart';
import 'package:jitsi_meet/room_name_constraint.dart';
import 'package:jitsi_meet/room_name_constraint_type.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:permission_handler/permission_handler.dart';

class CreateMeeting extends StatefulWidget {
  CreateMeeting({@required this.subject});
  final String subject;
  @override
  _CreateMeetingState createState() => _CreateMeetingState();
}

class _CreateMeetingState extends State<CreateMeeting> {
  final serverText = TextEditingController();
  TextEditingController roomText = TextEditingController();
  TextEditingController subjectText = TextEditingController();
  TextEditingController nameText = TextEditingController();
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;
  bool meetingEnded = false;
  List<String> userData = [];
  String name, uid, subject;

  getUserData() async {
    userData = await UserData().getUserData();
    uid = userData[0];
    name = userData[1];

    setState(() {
      // roomText = TextEditingController(text: userData[0]);
      nameText = TextEditingController(text: userData[1]);
      subjectText = TextEditingController(text: '${widget.subject} class');
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    JitsiMeet.addListener(
      JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create meeting'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 24.0,
              ),
              TextField(
                controller: nameText,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Display Name",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: subjectText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Subject",
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              TextField(
                controller: roomText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Room Name",
                ),
              ),
              Divider(
                height: 48.0,
                thickness: 2.0,
              ),
              SizedBox(
                height: 64.0,
                width: double.maxFinite,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xFFffce45),
                        Color(0xFFFFFF8D),
                      ]),
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Color(0xFFF9A825).withOpacity(.3),
                            offset: Offset(0.4, 0.4),
                            blurRadius: 8.0)
                      ]),
                  child: FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Do you want to record the class ?'),
                              content: Builder(builder: (context) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () async {
                                        Firestore.instance
                                            .collection('meeting')
                                            .add({
                                          'name': nameText.text,
                                          'subject': subjectText.text,
                                          'room_name': roomText.text
                                        });
                                        _joinMeeting();
                                      },
                                      child: Container(
                                        height: height * 0.04,
                                        width: width * 0.2,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Color(0xFFffce45),
                                              Color(0xFFFFFF8D),
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xFFF9A825)
                                                      .withOpacity(.3),
                                                  offset: Offset(0.4, 0.4),
                                                  blurRadius: 8.0)
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text('No'),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width * 0.1),
                                    InkWell(
                                      onTap: () async {
                                        Navigator.of(context).pop();
                                        Firestore.instance
                                            .collection('meeting')
                                            .add({
                                          'name': nameText.text,
                                          'subject': subjectText.text,
                                          'room_name': roomText.text
                                        });

                                        Map<Permission, PermissionStatus>
                                            status = await [
                                          Permission.microphone,
                                          Permission.storage,
                                        ].request();

                                        await FlutterScreenRecording
                                            .startRecordScreenAndAudio(
                                          roomText.text,
                                        );
                                        _joinMeeting();

                                      },
                                      child: Container(
                                        height: height * 0.04,
                                        width: width * 0.2,
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(colors: [
                                              Color(0xFFffce45),
                                              Color(0xFFFFFF8D),
                                            ]),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Color(0xFFF9A825)
                                                      .withOpacity(.3),
                                                  offset: Offset(0.4, 0.4),
                                                  blurRadius: 8.0)
                                            ]),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Text('Yes'),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            );
                          });
                    },
                    child: Text(
                      "Create Meeting",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  endMeeting() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    print(path);
  }

  _joinMeeting() async {
    String serverUrl =
        serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

    try {
      var options = JitsiMeetingOptions()
        ..room = roomText.text
        ..serverURL = serverUrl
        ..subject = subjectText.text
        ..userDisplayName = nameText.text
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted;
      //..chatEnabled = true;

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
          debugPrint("${options.room} will join with message: $message");
        }, onConferenceJoined: ({message}) {
          debugPrint("${options.room} joined with message: $message");
        }, onConferenceTerminated: ({message}) {
          debugPrint("${options.room} terminated with message: $message");
        }),
        // by default, plugin default constraints are used
        //roomNameConstraints: new Map(), // to disable all constraints
        roomNameConstraints: customContraints, // to use your own constraint(s)
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  static final Map<RoomNameConstraintType, RoomNameConstraint>
      customContraints = {
    RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
      return value.trim().length <= 50;
    }, "Maximum room name length should be 30."),
    RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
      return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
              .hasMatch(value) ==
          false;
    }, "Currencies characters aren't allowed in room names."),
  };

  void _onConferenceWillJoin({message}) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined({message}) {
    // debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated({message}) {
    endMeeting();
    // debugPrint("_onConferenceTerminated broadcasted with message: $message");
  }

  _onError(error) {
    // debugPrint("_onError broadcasted: $error");
  }
}
