import 'dart:io';
import 'package:doubt_out/doubts/showImage.dart';
import 'package:doubt_out/ui/chatrooms.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({this.email});
  String email;
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _textController = TextEditingController();
  final _firestore = Firestore.instance;
  final db = FirebaseStorage.instance;
  String message;
  String currentUser = 'manikanta14038@gmail.com';
  bool isMe = false;

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.documents) {
        print(message.data);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // messagesStream();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Chat',
            style: TextStyle(
              fontFamily: 'Handlee',
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              color: Color(0xffffce45),
              child: Text('One on One chat'),
              onPressed: ()=>{
              Navigator.push(
              context,
              MaterialPageRoute(
              builder: (context) => ChatRoom(email:widget.email),
              )),

              },
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('messages')
                      .orderBy('date')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    final messages = snapshot.data.documents.reversed;
                    List<MessageBubble> messageWidgets = [];
                    for (var message in messages) {
                      final messageText = message['text'];
                      final messageSender = message['user'];
                      final messageTime = message['date'];
                      // print(messageTime);
                      var date = new DateTime.fromMillisecondsSinceEpoch(
                        messageTime.seconds * 1000,
                      );
                      // print(date);
                      var time = '${date.hour}:${date.minute}';
                      isMe = messageSender == currentUser;
                      final messageWidget = MessageBubble(
                        isMe: isMe,
                        messageText: messageText,
                        messageTime: time,
                      );
                      messageWidgets.add(messageWidget);
                    }
                    return Expanded(
                      child: ListView(
                        reverse: true,
                        children: messageWidgets,
                      ),
                    );
                  }),
              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(12.0),
                    width: width * 0.8,
                    child: TextField(
                      controller: _textController,
                      onChanged: (val) {
                        message = val;
                      },
                      decoration: InputDecoration(
                          hintText: 'Type your message',
                          hintStyle: TextStyle(fontFamily: 'Handlee'),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.attach_file),
                            onPressed: () async {
                              PickedFile image = await ImagePicker().getImage(
                                source: ImageSource.gallery,
                                maxHeight: height,
                                maxWidth: width,
                              );
                              StorageReference ref = db.ref().child(
                                  'chat/${DateTime.now().toIso8601String()}');
                              StorageUploadTask uploadTask =
                                  ref.putFile(File(image.path));
                              await uploadTask.onComplete;
                              ref.getDownloadURL().then((url) {
                                _firestore.collection('messages').add({
                                  'text': url,
                                  'user': currentUser,
                                  'date': DateTime.now()
                                });
                              });
                            },
                          )),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: Color(0xffffce45),
                      child: IconButton(
                        // color: Color(0xffffce45),
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (_textController.text != "") {
                            message = _textController.text;
                            _textController.clear();
                            _firestore.collection('messages').add({
                              'text': message,
                              'user': currentUser,
                              'date': DateTime.now()
                            });
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    @required this.isMe,
    @required this.messageText,
    @required this.messageTime,
  });

  final bool isMe;
  final String messageText;
  final String messageTime;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            elevation: 6.0,
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                  ),
            // color: isMe ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  messageText.contains('https')
                      ? GestureDetector(
                          child: Container(
                            height: height / 3,
                            width: width / 2,
                            child: Image.network(
                              messageText,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShowImage(
                                  image: messageText,
                                ),
                              ),
                            );
                          },
                        )
                      : Text(
                          '$messageText',
                          style: TextStyle(
                            fontFamily: 'Handlee',
                            fontSize: 20,
                            // color: isMe ? Colors.white : Colors.black,
                          ),
                        ),
                  Text('$messageTime'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
