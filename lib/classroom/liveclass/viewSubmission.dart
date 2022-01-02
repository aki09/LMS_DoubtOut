import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewSubmission extends StatefulWidget {
  ViewSubmission({@required this.documentId});
  final String documentId;
  @override
  _ViewSubmissionState createState() => _ViewSubmissionState();
}

class _ViewSubmissionState extends State<ViewSubmission> {
  Firestore _firestore = Firestore.instance;

  @override
  void initState() {
    print(widget.documentId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var headingStyle = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Answers Submitted'),
      ),
      body: Container(
        margin: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  // width: width*0.3,
                  child: Center(
                    child: Text(
                      'Name',
                      style: headingStyle,
                    ),
                  ),
                ),
                Expanded(
                  // width: width*0.3,
                  child: Center(
                    child: Text(
                      'Answer',
                      style: headingStyle,
                    ),
                  ),
                ),
                Expanded(
                  // width: width*0.3,
                  child: Center(
                    child: Text(
                      'Status',
                      style: headingStyle,
                    ),
                  ),
                ),
              ],
            ),
            StreamBuilder(
              stream: _firestore
                  .collection('postedQuestions')
                  .document(widget.documentId)
                  .collection('answersSubmitted')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.documents.length == 0) {
                  return Container(
                    child: Center(
                      child: Text(
                        'No Submissions yet',
                        style: TextStyle(fontSize: 26.0),
                      ),
                    ),
                  );
                }
                // print(snapshot.data);
                List<Container> cards = [];
                var submittedAnswers = snapshot.data.documents;
                print(submittedAnswers.length);

                for (var submit in submittedAnswers) {
                  final name = submit['submittedBy'];
                  final answer = submit['submittedAnswer'];
                  final correct=submit['correct'];
                  print(name);
                  // final answer=
                  final card = Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          // width: width * 0.3,
                          child: Center(
                            child: Text(name),
                          ),
                        ),
                         Expanded(
                          // width: width * 0.3,
                          child: Center(
                            child: Text(answer),
                          ),
                        ),
                        Expanded(
                          child:correct? Icon(Icons.check,color: Colors.green,):Icon(
                            Icons.close,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );

                  cards.add(card);
                }
                return Expanded(
                  child: ListView(
                    children: cards,
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
