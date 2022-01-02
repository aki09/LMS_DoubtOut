// import 'package:doubt_out/model/userData.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';
// import 'package:jitsi_meet/jitsi_meeting_listener.dart';
// import 'package:jitsi_meet/room_name_constraint.dart';
// import 'package:jitsi_meet/room_name_constraint_type.dart';

// class JitsiMeetPage extends StatefulWidget {
//   JitsiMeetPage({@required this.subject});
//   final String subject;
//   @override
//   _JitsiMeetPageState createState() => _JitsiMeetPageState();
// }

// class _JitsiMeetPageState extends State<JitsiMeetPage> {
//   final serverText = TextEditingController();
//   TextEditingController roomText = TextEditingController();
//   TextEditingController subjectText = TextEditingController();
//   TextEditingController nameText = TextEditingController();
//   var isAudioOnly = true;
//   var isAudioMuted = true;
//   var isVideoMuted = true;
//   List<String> userData = [];
//   String name, uid, subject;

//   getUserData() async {
//     userData = await UserData().getUserData();
//     uid = userData[0];
//     name = userData[1];

//     setState(() {
//       roomText = TextEditingController(text: userData[0]);
//       nameText = TextEditingController(text: userData[1]);
//       subjectText = TextEditingController(text: '${widget.subject} class');
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     getUserData();
//     JitsiMeet.addListener(
//       JitsiMeetingListener(
//         onConferenceWillJoin: _onConferenceWillJoin,
//         onConferenceJoined: _onConferenceJoined,
//         onConferenceTerminated: _onConferenceTerminated,
//         onError: _onError,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     JitsiMeet.removeAllListeners();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create meeting'),
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(
//           horizontal: 16.0,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             children: <Widget>[
//               SizedBox(
//                 height: 24.0,
//               ),
//               TextField(
//                 controller: nameText,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Display Name",
//                 ),
//               ),
//               SizedBox(
//                 height: 16.0,
//               ),
//               TextField(
//                 controller: subjectText,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: "Subject",
//                 ),
//               ),
//               SizedBox(
//                 height: 16.0,
//               ),
//               Text('Room id : ${roomText.text}'),
//               Divider(
//                 height: 48.0,
//                 thickness: 2.0,
//               ),
//               SizedBox(
//                 height: 64.0,
//                 width: double.maxFinite,
//                 child: RaisedButton(
//                   onPressed: () {
//                     _joinMeeting();
//                   },
//                   child: Text(
//                     "Create Meeting",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   color: Colors.blue,
//                 ),
//               ),
//               SizedBox(
//                 height: 48.0,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   _joinMeeting() async {
//     String serverUrl =
//         serverText.text?.trim()?.isEmpty ?? "" ? null : serverText.text;

//     try {
//       var options = JitsiMeetingOptions()
//         ..room = roomText.text
//         ..serverURL = serverUrl
//         ..subject = subjectText.text
//         ..userDisplayName = nameText.text
//         ..audioOnly = isAudioOnly
//         ..audioMuted = isAudioMuted
//         ..videoMuted = isVideoMuted
//         ..chatEnabled = true
//         ..inviteEnabled = true;

//       debugPrint("JitsiMeetingOptions: $options");
//       await JitsiMeet.joinMeeting(
//         options,
//         // listener: JitsiMeetingListener(onConferenceWillJoin: ({message}) {
//         //   debugPrint("${options.room} will join with message: $message");
//         // }, onConferenceJoined: ({message}) {
//         //   debugPrint("${options.room} joined with message: $message");
//         // }, onConferenceTerminated: ({message}) {
//         //   debugPrint("${options.room} terminated with message: $message");
//         // }),
//         // by default, plugin default constraints are used
//         //roomNameConstraints: new Map(), // to disable all constraints
//         roomNameConstraints: customContraints, // to use your own constraint(s)
//       );
//     } catch (error) {
//       debugPrint("error: $error");
//     }
//   }

//   static final Map<RoomNameConstraintType, RoomNameConstraint>
//       customContraints = {
//     RoomNameConstraintType.MAX_LENGTH: new RoomNameConstraint((value) {
//       return value.trim().length <= 50;
//     }, "Maximum room name length should be 30."),
//     RoomNameConstraintType.FORBIDDEN_CHARS: new RoomNameConstraint((value) {
//       return RegExp(r"[$€£]+", caseSensitive: false, multiLine: false)
//               .hasMatch(value) ==
//           false;
//     }, "Currencies characters aren't allowed in room names."),
//   };

//   void _onConferenceWillJoin({message}) {
//     debugPrint("_onConferenceWillJoin broadcasted with message: $message");
//   }

//   void _onConferenceJoined({message}) {
//     debugPrint("_onConferenceJoined broadcasted with message: $message");
//   }

//   void _onConferenceTerminated({message}) {
//     debugPrint("_onConferenceTerminated broadcasted with message: $message");
//   }

//   _onError(error) {
//     debugPrint("_onError broadcasted: $error");
//   }
// }
