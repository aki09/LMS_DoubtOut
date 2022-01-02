import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doubt_out/classroom/liveclass/postQuestion.dart';
import 'package:doubt_out/classroom/liveclass/question_posted.dart';
import 'package:doubt_out/model/userData.dart';
import 'package:flutter/material.dart';
import 'Assignment.dart';
import 'addAssignment.dart';
import '../constants/months.dart';
import 'liveclass/liveClasses.dart';

class AssignmentList extends StatefulWidget {
  AssignmentList({@required this.subjectName});

  final String subjectName;
  @override
  _AssignmentListState createState() => _AssignmentListState();
}

class _AssignmentListState extends State<AssignmentList> {
  final _firestore = Firestore.instance;
  int accountStatus;

  bool classroom = true, liveclass = false, question = false;
  List<String> data = [];
  getUserData() async {
    data = await UserData().getUserData();
    accountStatus = await UserData().getAccountStatus();
    setState(() {
      accountStatus = accountStatus;
      print(accountStatus);
    });
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButton: classroom && accountStatus==1
          ? FloatingActionButton(
              backgroundColor: Color(0xffffce45),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddAssignment(
                      subject: widget.subjectName,
                      uid: data[0],
                      name: data[1],
                    ),
                  ),
                );
              },
              child: Icon(Icons.assignment),
            )
          : question && accountStatus==1
              ? FloatingActionButton(
                  backgroundColor: Color(0xffffce45),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PostQuestion(subject: widget.subjectName),
                      ),
                    );
                  },
                  child: Icon(Icons.question_answer),
                )
              : Container(),
      body: Container(
        margin: EdgeInsets.all(12.0),
        child: Column(
          children: <Widget>[
            Container(
              width: width,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '10th class Sec-A 2019-2020',
                  style: TextStyle(fontSize: height * 0.03),
                ),
              ),
            ),
            SizedBox(height: height * 0.02),
            //buttons for selecting classroom and liveclass
            Row(
              children: <Widget>[
                FlatButton(
                  color: classroom ? Color(0xffffce45) : Colors.white,
                  child: Text('Classroom'),
                  onPressed: () {
                    setState(() {
                      classroom = true;
                      liveclass = false;
                      question = false;
                    });
                  },
                ),
                SizedBox(width: 10.0),
                FlatButton(
                  color: liveclass ? Color(0xffffce45) : Colors.white,
                  child: Text('Live classses'),
                  onPressed: () {
                    setState(() {
                      classroom = false;
                      liveclass = true;
                      question = false;
                    });
                  },
                ),
                SizedBox(width: 10.0),
                FlatButton(
                  color: question ? Color(0xffffce45) : Colors.white,
                  child: Text(
                    'Question Posted',
                    style: TextStyle(fontSize: 12.0),
                  ),
                  onPressed: () {
                    setState(() {
                      classroom = false;
                      liveclass = false;
                      question = true;
                    });
                  },
                ),
              ],
            ),
            Visibility(
              visible: classroom,
              child: buildStreamBuilder(height),
            ),
            Visibility(
              visible: liveclass,
              child: LiveClasses(
                subjectName: widget.subjectName,
                accountStatus: accountStatus,
              ),
            ),
            Visibility(
              visible: question,
              child: QuestionPosted(
                subjectName: widget.subjectName,
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> buildStreamBuilder(double height) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('assignments')
          .document(widget.subjectName)
          .collection(widget.subjectName)
          .orderBy('postedDate')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data.documents.length == 0) {
          return Container(
            height: height * 0.5,
            child: Center(
              child: Text(
                'No assignments',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        List<AssignmentCard> assignmentCards = [];
        var assignments = snapshot.data.documents;
        for (var assignment in assignments) {
          DocumentSnapshot ref = assignment;

          final title = assignment['title'];
          final userName = assignment['userName'];
          final postedDate = assignment['postedDate'];
          final dueDate = assignment['dueDate'];
          final documentRef = assignment['fileUrl'];
          final description = assignment['description'];
          final submitted = assignment['submitted'];
          final documentId = ref.documentID;
          final attachedUrls = assignment['attachedUrls'];
          final attachedFiles = assignment['attachedFiles'];
          final attachedFileNames = assignment['attachedFileNames'];
          var datePosted = new DateTime.fromMillisecondsSinceEpoch(
            postedDate.seconds * 1000,
          );
          var dateDue = new DateTime.fromMillisecondsSinceEpoch(
            dueDate.seconds * 1000,
          );
          final assignmentCard = AssignmentCard(
            height: height,
            subject: widget.subjectName,
            title: title,
            datePosted: datePosted,
            dateDue: dateDue,
            userName: userName,
            months: months,
            documentRef: documentRef,
            description: description,
            documentId: documentId,
            submitted: submitted,
            attachedUrls: attachedUrls,
            attachedFiles: attachedFiles,
            attachedFileNames: attachedFileNames,
          );
          assignmentCards.add(assignmentCard);
        }
        return Expanded(
          child: ListView(
            children: assignmentCards,
            // children: <Widget>[
            //details of the page....

            //class room

            // // live class
            // Visibility(
            //   visible: liveclass,
            //   child: LiveClasses(
            //     subjectName: widget.subjectName,
            //     accountStatus: accountStatus,
            //   ),
            // ),
            // ],
          ),
        );
      },
    );
  }
}

class AssignmentCard extends StatelessWidget {
  const AssignmentCard({
    Key key,
    @required this.height,
    @required this.subject,
    @required this.title,
    @required this.datePosted,
    @required this.dateDue,
    @required this.userName,
    @required this.months,
    @required this.documentRef,
    @required this.description,
    @required this.documentId,
    @required this.attachedUrls,
    @required this.submitted,
    @required this.attachedFiles,
    @required this.attachedFileNames,
  }) : super(key: key);

  final double height;
  final String title;
  final DateTime datePosted;
  final DateTime dateDue;
  final String userName;
  final List<String> months;
  final String documentRef;
  final String description;
  final String documentId;
  final bool submitted;
  final String subject;
  final List<dynamic> attachedUrls;
  final List<dynamic> attachedFiles;
  final List<dynamic> attachedFileNames;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
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
      height: height * 0.15,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Assignment(
                title: title,
                subject: subject,
                postedDate: datePosted,
                dueDate: dateDue,
                userName: userName,
                documentRef: documentRef,
                description: description,
                documentId: documentId,
                submitted: submitted,
                attachedUrls: attachedUrls,
                attachedFileNames: attachedFileNames,
                attachedFiles: attachedFiles,
              ),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(title),
                Text(
                  'Due ${months[dateDue.month - 1]} ${dateDue.day}, ${dateDue.hour}:${dateDue.minute}',
                ),
              ],
            ),
            Text('Assigned by: $userName'),
            Text(
              'Posted ${months[datePosted.month - 1]} ${datePosted.day}, ${datePosted.hour}:${datePosted.minute}',
            ),
          ],
        ),
      ),
    );
  }
}
