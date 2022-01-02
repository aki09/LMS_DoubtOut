import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doubt_out/widgets/alertBox.dart';
import 'package:file_picker/file_picker.dart';
// import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class AddAssignment extends StatefulWidget {
  AddAssignment(
      {@required this.subject, @required this.uid, @required this.name});

  final String subject;
  final String uid;
  final String name;
  @override
  _AddAssignmentState createState() => _AddAssignmentState();
}

class _AddAssignmentState extends State<AddAssignment> {
  final _firestore = Firestore.instance;
  String title, description, fileName;
  bool loading = false;
  File file;
  List<File> files = [];
  List<String> fileNames = [];
  List<String> attachedFiles = [];
  TextEditingController linkController = TextEditingController();

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      // contentPadding: EdgeInsets.all(0),
      content: Text('Uploaded Assignment'),
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

  selectFile() async {
    file = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'doc'],
    );
    print(file);
    files.add(file);
    if (file != null) {
      setState(() {
        file = file;
      });
      int lastIndex = file.toString().lastIndexOf('/');
      fileName =
          file.toString().substring(lastIndex + 1, file.toString().length - 1);
      print(fileName);
      fileNames.add(fileName);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Add Assignment')),
      body: ModalProgressHUD(
        inAsyncCall: loading,
        child: Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Subject : ${widget.subject}',
                style: TextStyle(fontSize: 20.0),
              ),
              SizedBox(height: height * 0.02),
              Flexible(
                child: TextField(
                  decoration:
                      InputDecoration(hintText: 'Enter the assignment title'),
                  onChanged: (val) {
                    title = val;
                  },
                ),
              ),
              SizedBox(height: height * 0.02),
              Flexible(
                child: TextField(
                  decoration:
                      InputDecoration(hintText: 'Enter the description'),
                  onChanged: (val) {
                    description = val;
                  },
                ),
              ),
              SizedBox(height: height * 0.04),
              Text(
                'You can attach Documents, Internet links, images and videos.',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: height * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Container(
                      color: Color(0xffffce45),
                      child: IconButton(
                        tooltip: 'Attach a Link',
                        // splashColor: Color(0xffffce45),
                        icon: Icon(Icons.insert_link),
                        onPressed: () {
                          // bool showError = false;
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                  ),
                                  // contentPadding: EdgeInsets.all(0),

                                  content: TextFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Add a link',
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        linkController.text = val;
                                        linkController.text.length;
                                      });
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
                                      onPressed: () async {
                                        if (linkController.text.length != 0) {
                                          try {
                                            http.Response response = await http
                                                .get(linkController.text);
                                            if (response.statusCode == 200) {
                                              Navigator.pop(
                                                context,
                                                linkController.text,
                                              );
                                            } else {
                                              Navigator.pop(context);
                                              dialogBox(
                                                context,
                                                Text('Not a valid link'),
                                              );
                                              print('not a valid link');
                                            }
                                          } catch (e) {
                                            Navigator.pop(context);
                                            dialogBox(
                                              context,
                                              Text('Not a valid link'),
                                            );
                                            print('not a valid link');
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                  contentTextStyle: TextStyle(
                                    fontSize: 24.0,
                                    color: Colors.black,
                                  ),
                                );
                              }).then((value) {
                            print(value);
                            if (value != null) {
                              attachedFiles.add(value);
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: width * 0.1),
                  ClipOval(
                    child: Container(
                      color: Color(0xffffce45),
                      child: IconButton(
                        tooltip: 'Upload files',
                        icon: Icon(Icons.file_upload),
                        onPressed: () {
                          selectFile();
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.04),
              Expanded(
                flex: files.length != 0 ? 1 * files.length : 1,
                child: ListView.builder(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: width * 0.7,
                            child: RaisedButton(
                              color: Color(0xFFffce45),
                              child: Text(
                                fileNames[index],
                                softWrap: true,
                                maxLines: 3,
                              ),
                              onPressed: () async {
                                print(files[index]);
                                OpenFile.open(files[index].path);
                              },
                            ),
                          ),
                          FlatButton(
                            child: Icon(Icons.remove_circle),
                            onPressed: () {
                              setState(() {
                                fileNames.remove(fileNames[index]);
                                files.remove(files[index]);
                                print(fileNames);
                              });
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: attachedFiles.length != 0 ? 1 * attachedFiles.length : 1,
                child: ListView.builder(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  itemCount: attachedFiles.length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            width: width * 0.7,
                            child: RaisedButton(
                              color: Color(0xFFffce45),
                              child: Text(
                                attachedFiles[index],
                                softWrap: true,
                                maxLines: 3,
                              ),
                              onPressed: () async {
                                if (await canLaunch(attachedFiles[index])) {
                                  await launch(attachedFiles[index]);
                                } else {
                                  print(files[index]);
                                  OpenFile.open(files[index].path);
                                }
                              },
                            ),
                          ),
                          FlatButton(
                            child: Icon(Icons.remove_circle),
                            onPressed: () {
                              setState(() {
                                attachedFiles.remove(attachedFiles[index]);
                              });
                            },
                          )
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
      bottomNavigationBar: MaterialButton(
          height: height * 0.07,
          color: Color(0xFFffce45),
          child: Text(
            'Submit',
            style: TextStyle(fontSize: height * 0.03),
          ),
          onPressed: () async {
            List<String> urls = [];

            print(title);
            print(description);
            if (files != null && title != null && description != null) {
              setState(() {
                loading = true;
              });
              for (var index = 0; index < files.length; index++) {
                StorageReference _storageReference = FirebaseStorage()
                    .ref()
                    .child('downloadAssignment/$title/${fileNames[index]}');
                StorageUploadTask uploadTask = _storageReference.putFile(file);
                await uploadTask.onComplete;
                var url = await _storageReference.getDownloadURL();
                urls.add(url);
              }
              // if (attachedFiles.length != 0) {
              //   urls.addAll(attachedFiles);
              // }

              // DocumentReference ref =
              await _firestore.collection('assignments').document(widget.subject).collection(widget.subject).add({
                'userName': widget.name,
                'title': title,
                'description': description,
                'postedDate': DateTime.now(),
                'dueDate': DateTime.now(),
                'attachedUrls': attachedFiles,
                'submitted': false,
                'attachedFiles': urls,
                'attachedFileNames': fileNames,
              });
              // print(ref.documentID);
              print('uploaded the assignment');
              setState(() {
                loading = false;
              });
              showAlertDialog(context);
            }
          }),
    );
  }
}
