import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doubt_out/model/userData.dart';
import 'package:doubt_out/widgets/alertBox.dart';
import 'package:flutter/material.dart';

class SubmitAnswer extends StatefulWidget {
  SubmitAnswer({
    @required this.answers,
    @required this.question,
    @required this.documentId,
    @required this.answer,
  });

  final String question;
  final String answer;
  final String documentId;

  final List<dynamic> answers;
  @override
  _SubmitAnswerState createState() => _SubmitAnswerState();
}

class _SubmitAnswerState extends State<SubmitAnswer> {
  List<String> options = ['A', 'B', 'C', 'D', 'E'];
  Color color = Color(0xFFffce45);
  List<bool> tapped = [];
  bool onTapped = false;
  Firestore _firestore = Firestore.instance;
  String name, answer,uid;
  //uid assigned by firebase 
  getUserData() async {
    var data = await UserData().getUserData();
    uid=data[0];
    name = data[1];
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    List.generate(widget.answers.length, (index) {
      tapped.add(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a option'),
      ),
      bottomNavigationBar: onTapped
          ? MaterialButton(
              height: height * 0.07,
              color: Color(0xFFffce45),
              child: Text(
                'Submit',
                style: TextStyle(fontSize: height * 0.03),
              ),
              onPressed: () {
                //add data to database
                var ref = _firestore.collection('postedQuestions')
                  .document('${widget.documentId}')
                      .collection('answersSubmitted');
                ref.document(uid).setData({
                  'submittedBy': name,
                  'submittedTime': DateTime.now(),
                  'submittedAnswer': answer,
                  'submitted': true,
                  'correct': answer == widget.answer,
                });

                // _firestore
                //     .collection('postedQuestions')
                //     .document('${widget.documentId}')
                //     .collection('answersSubmitted')
                //     .add();
                //checking for answer is correct or not
                //showing a alert dialog to user
                (answer == widget.answer)
                    ? disapperDialog(
                        context,
                        Text('Correct Answer'),
                      )
                    : disapperDialog(
                        context,
                        Text('Wrong Answer'),
                      );
              },
            )
          : MaterialButton(
              child: Text(
                '',
                style: TextStyle(fontSize: height * 0.03),
              ),
              onPressed: () {},
            ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Q:  ${widget.question}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: height * 0.05),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return MaterialButton(
                    onPressed: () {
                      for (var i = 0; i < tapped.length; i++) {
                        index == i ? tapped[i] = true : tapped[i] = false;
                      }
                      setState(() {
                        tapped = tapped;
                        onTapped = true;
                        answer = widget.answers[index];
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: tapped[index] ? color : Colors.white,
                      ),
                      width: width,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              options[index],
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          SizedBox(width: width * 0.1),
                          Text(
                            widget.answers[index],
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: height * 0.04,
                  );
                },
                itemCount: widget.answers.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
