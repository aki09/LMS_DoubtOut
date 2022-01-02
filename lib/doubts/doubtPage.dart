import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/userData.dart';

class DoubtPage extends StatefulWidget {
  DoubtPage({@required this.name, @required this.photoUrl});
  final String name;
  final String photoUrl;

  @override
  _DoubtPageState createState() => _DoubtPageState();
}

class _DoubtPageState extends State<DoubtPage> {
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
  List<String> data;
  String uid, name, pic;

  getUserData() async {
    data = await UserData().getUserData();
    uid = data[0];
    name = data[1];
    pic = data[2];
    print(name);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      child: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Feed')
            // .document('${widget.name}')
            // .collection('questions')
            .orderBy('question_time_stamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Center(
                child: Text('Post your doubts'),
              ),
            );
          final doubts = snapshot.data.documents;
          List<DoubtCard> doubtCards = [];
          for (var doubt in doubts) {
            final name = doubt['name'];
            final subjectName = doubt['subject_name'];
            final question = doubt['question'];
            final questionPhoto = doubt['question_image_url'];
            final questionTime = doubt['question_time_stamp'];
            final profilePic = doubt['profile_doubt_asked_url'];
            var date = DateTime.fromMillisecondsSinceEpoch(
              questionTime * 1000,
            );
            
            var formatDate =
                'Posted on: ${months[date.month - 1]} ${date.day}, ${date.hour}:${date.minute}';

            final doubtCard = DoubtCard(
              name: name,
              pic: profilePic,
              subjectName: subjectName,
              question: question,
              questionPhoto: questionPhoto,
              questionTime: formatDate,
            );

            doubtCards.add(doubtCard);
          }
          return ListView(
            children: doubtCards,
          );
        },
      ),
    );
  }
}

class DoubtCard extends StatelessWidget {
  const DoubtCard({
    @required this.name,
    @required this.pic,
    @required this.subjectName,
    @required this.question,
    @required this.questionPhoto,
    @required this.questionTime,
  });

  final String name;
  final String pic;
  final String subjectName;
  final String question;
  final String questionPhoto;
  final String questionTime;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return Container(
      // color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipOval(
                  // borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: NetworkImage(pic),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    // alertDisapproved(data);
                  },
                ),
              ],
            ),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(15),
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Center(
                    child: Text(
                      'SUBJECT : $subjectName',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFFffce45),
                    Color(0xFFFFFF8D),
                  ]),
                  borderRadius: BorderRadius.circular(0.0),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFFF9A825).withOpacity(.3),
                        offset: Offset(0.4, 0.4),
                        blurRadius: 8.0)
                  ]),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  child: Center(
                    child: Text('Question : $question',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: height * 0.05),
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 14,
            ),
            alignment: Alignment.topRight,
            child: Text('$questionTime'),
          ),
          Container(
            // width: ,
            margin: EdgeInsets.symmetric(
              horizontal: 14,
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 50, top: 50),
                ),
                ClipOval(
                  child: Image(
                    image: NetworkImage(questionPhoto),
                    width: 100,
                    height: 100,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                ClipOval(
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Divider(thickness: 2.0),
        ],
      ),
    );
  }
}
