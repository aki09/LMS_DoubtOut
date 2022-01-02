import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doubt_out/classroom/liveclass/submitAnswer.dart';
import 'package:doubt_out/classroom/liveclass/viewSubmission.dart';
import 'package:doubt_out/constants/months.dart';
import 'package:doubt_out/model/userData.dart';
import 'package:flutter/material.dart';

class QuestionPosted extends StatefulWidget {
  QuestionPosted({@required this.subjectName});
  final String subjectName;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return QuestionPostedState();
  }
}

class QuestionPostedState extends State<QuestionPosted> {
  Firestore _firestore = Firestore.instance;
  int accountStatus;
  getUserData() async {
    // data = await UserData().getUserData();
    var status = await UserData().getAccountStatus();
    setState(() {
      accountStatus = status;
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

    return Expanded(
      child: Column(
        children: <Widget>[
          Divider(
            color: Color(0xFFffce45),
          ),
          Text(
            'Questions posted',
            style: TextStyle(fontSize: 20.0),
          ),
          StreamBuilder(
            stream: _firestore
                .collection('postedQuestions')
                .document(widget.subjectName)
                .collection(widget.subjectName)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data.documents.length == 0) {
                return Container(
                  height: height * 0.4,
                  child: Center(
                    child: Text('Not posted questions yet!'),
                  ),
                );
              }
              List<InkWell> cards = [];
              var questions = snapshot.data.documents;
              print(questions);
              for (var question in questions) {
                DocumentSnapshot ref = question;
                final documentId = ref.documentID;
                final questionName = question['question'];
                final answers = question['answers'];
                final postedDate = question['postedTime'];
                final postedBy = question['postedBy'];
                final answer = question['answer'];
                var datePosted = new DateTime.fromMillisecondsSinceEpoch(
                  postedDate.seconds * 1000,
                );
                final card = InkWell(
                  onTap: () {
                    accountStatus == 1
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewSubmission(
                                documentId: documentId,
                              ),
                            ),
                          )
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubmitAnswer(
                                question: questionName,
                                answer: answer,
                                answers: answers,
                                documentId: documentId,
                              ),
                            ),
                          );
                  },
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(10.0),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Question :$questionName',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        Text('Assigned by $postedBy'),
                        Text(
                          'Posted on : ${months[datePosted.month - 1]} ${datePosted.day}, ${datePosted.hour}:${datePosted.minute}',
                        ),
                      ],
                    ),
                  ),
                );
                if (!question['submitted']) {
                  cards.add(card);
                }
              }
              // return Container();
              return Expanded(
                child: ListView(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  children: cards,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
