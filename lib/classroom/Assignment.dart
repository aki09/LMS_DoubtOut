import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doubt_out/widgets/alertBox.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/userData.dart';
import 'package:file_picker/file_picker.dart';

class Assignment extends StatefulWidget {
  Assignment({
    @required this.title,
    @required this.subject,
    @required this.dueDate,
    @required this.postedDate,
    @required this.userName,
    @required this.documentRef,
    @required this.description,
    @required this.documentId,
    @required this.submitted,
    @required this.attachedUrls,
    @required this.attachedFileNames,
    @required this.attachedFiles,

  });
  final String title;
  final String subject;
  final DateTime postedDate;
  final DateTime dueDate;
  final String userName;
  final String documentRef;
  final String description;
  final String documentId;
  final bool submitted;
  final List<dynamic> attachedUrls;
  final List<dynamic> attachedFiles;
  final List<dynamic> attachedFileNames;

  @override
  _AssignmentState createState() => _AssignmentState();
}

class _AssignmentState extends State<Assignment> {
  final _firestore = Firestore.instance;

  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'April',
    'May',
    'June',
    'July',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  DateTime dueDate;
  DateTime postedDate;
  String userName, uid, name, documentId;
  List<String> data;
  bool _loading = false, submitted = false, downloading = false;
  Dio dio = Dio();

  getUserData() async {
    data = await UserData().getUserData();
    uid = data[0];
    name = data[1];
    documentId = widget.documentId;
    setState(() {
      submitted = widget.submitted;
    });
    print(documentId);
  }

  createPath(String fileName) async {
    final String appDir =
        await getExternalStorageDirectory().then((value) => value.path);
    // print(appDir);
    final Directory appDirFolder = Directory('$appDir/assignment');
    final dir = Directory('$appDir/assignment/$fileName')
        .create(recursive: true)
        .then((value) => value.path);
    print('Folder created');
    return dir;
  }

  getPathExists(String fileName) async {
    final String appDir =
        await getExternalStorageDirectory().then((value) => value.path);
    final Directory appDirFolder = Directory('$appDir/assignment/$fileName');
    return await appDirFolder.exists();
  }

  @override
  void initState() {
    getUserData();
    super.initState();
    dueDate = widget.dueDate;
    postedDate = widget.postedDate;
    userName = widget.userName;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Due ${months[dueDate.month - 1]} ${dueDate.day}, ${dueDate.hour}:${dueDate.minute}',
              ),
              Text(
                'Topic',
                style: TextStyle(fontSize: height * 0.04),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(userName),
                  // SizedBox(width: width * 0.05),
                  Text(
                    'Posted on: ${months[postedDate.month - 1]} ${postedDate.day}, ${postedDate.hour}:${postedDate.minute}',
                  ),
                ],
              ),
              Divider(thickness: 2.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Description',
                    style: TextStyle(fontSize: height * 0.04),
                  ),
                ],
              ),
              //from here the details of assignment are shown...
              Container(
                child: Text('${widget.description}'),
              ),
              SizedBox(height: height * 0.05),
              Text(
                'Attachments',
                style: TextStyle(fontSize: 24.0),
              ),
               Expanded(
                child: ListView.builder(
                  itemCount: widget.attachedFileNames.length,
                  itemBuilder: (context, index) {
                    var file = widget.attachedFileNames[index].toString();
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      child: Row(children: <Widget>[
                        file.contains('.pdf')
                            ? Icon(Icons.picture_as_pdf)
                            : Icon(Icons.photo_album),
                        SizedBox(width: width * 0.05),
                        Container(
                          width: width * 0.7,
                          child: RaisedButton(
                            color: Color(0xFFffce45),
                            child: Text(
                              widget.attachedFileNames[index],
                              softWrap: true,
                              maxLines: 3,
                            ),
                            onPressed: () async {
                              if (await getPathExists(
                                  widget.attachedFileNames[index])) {
                                var path = await createPath(
                                  widget.attachedFileNames[index],
                                );
                                file.contains('pdf')
                                    ? OpenFile.open(
                                        '$path/${widget.attachedFileNames[index]}.pdf',
                                      )
                                    : OpenFile.open(
                                        '$path/${widget.attachedFileNames[index]}.png',
                                      );
                              } else {
                                var path = await createPath(
                                  widget.attachedFileNames[index],
                                );
                                file.contains('pdf')
                                    ? await dio.download(
                                        widget.attachedFiles[index],
                                        '$path/${widget.attachedFileNames[index]}.pdf',
                                      )
                                    : await dio.download(
                                        widget.attachedFiles[index],
                                        '$path/${widget.attachedFileNames[index]}.png',
                                      );
                                file.contains('pdf')
                                    ? OpenFile.open(
                                        '$path/${widget.attachedFileNames[index]}.pdf',
                                      )
                                    : OpenFile.open(
                                        '$path/${widget.attachedFileNames[index]}.png',
                                      );
                              }
                            },
                          ),
                        ),
                      ]),
                    );
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.attachedUrls.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.attach_file),
                          SizedBox(width: width * 0.05),
                          Container(
                            width: width * 0.7,
                            child: RaisedButton(
                              color: Color(0xFFffce45),
                              child: Text(
                                widget.attachedUrls[index],
                                softWrap: true,
                                maxLines: 3,
                              ),
                              onPressed: () async {
                                if (await canLaunch(
                                    widget.attachedUrls[index])) {
                                  await launch(widget.attachedUrls[index]);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      //Button for uploading the assignment..
      floatingActionButton: StreamBuilder<DocumentSnapshot>(
        stream: _firestore
            .collection('assignments')
            .document(widget.subject).collection(widget.subject).document(documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // print(snapshot.data['submitted']);
            if (!snapshot.data['submitted']){
              return FloatingActionButton(
                backgroundColor: Color(0xffffce45),
                child: Icon(Icons.file_upload),
                onPressed: () async {
                  StorageReference _storageReference =
                      FirebaseStorage().ref().child('uploadAssignment/$uid');
                  File file = await FilePicker.getFile(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                  );
                  print(file);
                  if (file != null) {
                    setState(() {
                      _loading = true;
                    });
                    StorageUploadTask uploadTask =
                        _storageReference.putFile(file);
                    await uploadTask.onComplete;
                    print('uploaded the assignment');
                    int lastIndex = file.toString().lastIndexOf('/');
                    var fileName = file
                        .toString()
                        .substring(lastIndex + 1, file.toString().length - 1);
                    print(fileName);
                    _firestore
                        .collection('assignments')
                        .document(documentId)
                        .updateData({'submitted': true, 'fileName': fileName});
                    setState(() {
                      _loading = false;
                    });
                    dialogBox(
                      context,
                      Text('Uploaded Assignment'),
                    );
                  }
                },
              );
            } else {
              var fileName = snapshot.data['fileName'];
              return Container(
                margin: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(thickness: 2.0),
                    Text(
                      'Submitted.',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 18.0,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: width * 0.75,
                          child: Text(
                            '$fileName',
                            softWrap: true,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            print('deleted assignment');
                            StorageReference _storageReference =
                                FirebaseStorage()
                                    .ref()
                                    .child('uploadAssignment/$uid');
                            _storageReference.delete();
                            _firestore
                                .collection('assignments')
                                .document(documentId)
                                .updateData({'submitted': false});
                          },
                        )
                      ],
                    )
                  ],
                ),
              );
            }
          } else {
            return Container();
          }
        },
      ),
    );
  }
}

// Button for downloading assignment
// FlatButton(
//   child: Icon(Icons.file_download),
//   onPressed: () async {
//     setState(() {
//       _loading = true;
//     });

//     final String appDir = await getExternalStorageDirectory()
//         .then((value) => value.path);
//     print(appDir);
//     final Directory appDirFolder =
//         Directory('$appDir/assignment');
//     print(appDirFolder.path);

//     if (await appDirFolder.exists()) {
//       print('yes');
//       Dio dio = Dio();
//       await dio.download(
//         widget.documentRef,
//         '$appDir/assignment/${widget.title}.pdf',
//       );
//       setState(() {
//         _loading = false;
//       });
//       dialogBox(
//         context,
//         Text('Downloaded Assignment'),
//       );
//     } else {
//       print('no');
//       Directory('$appDir/assignment/')
//           .create(recursive: true)
//           .then((value) => value.path);
//       print('Folder created');
//       Dio dio = Dio();
//       await dio.download(
//         widget.documentRef,
//         '$appDir/assignment/${widget.title}.pdf',
//       );
//       setState(() {
//         _loading = false;
//       });
//       dialogBox(
//         context,
//         Text('Downloaded Assignment'),
//       );
//     }
//   },
// ),
