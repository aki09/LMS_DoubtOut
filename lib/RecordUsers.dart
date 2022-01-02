import 'package:cloud_firestore/cloud_firestore.dart';

class RecordUsers {
  String email;
  int login_time_stamp;
  String name;
  String profile_photo_url;
  String uid;
  DocumentReference reference;

  RecordUsers.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.email = map['email'];
    this.login_time_stamp = map['login_time_stamp'];
    this.name = map['name'];
    this.profile_photo_url = map['profile_photo_url'];
    this.uid = map['uid'];
  }

  RecordUsers.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  RecordUsers(
      {this.email,
      this.login_time_stamp,
      this.name,
      this.profile_photo_url,
      this.uid});
}

class RecordFeed {
  String answer;
  String answer_image_url;
  int answer_time_stamp;
  String question;
  String question_image_url;
  int question_time_stamp;
  String subject_name;
  String name;
  String profile_doubt_asked_url;
  int status;
  String uid;
  DocumentReference reference;

  RecordFeed.fromMap(Map<String, dynamic> map, {this.reference}) {
    this.answer = map['answer'];
    this.answer_image_url = map['answer_image_url'];
    this.answer_time_stamp = map['answer_time_stamp'];
    this.question = map['question'];
    this.question_image_url = map['question_image_url'];
    this.question_time_stamp = map['question_time_stamp'];
    this.subject_name = map['subject_name'];
    this.name = map['name'];
    this.profile_doubt_asked_url = map['profile_doubt_asked_url'];
    this.status = map['status'];
    this.uid = map['uid'];
  }

  RecordFeed.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  RecordFeed(
      {this.answer,
      this.answer_image_url,
      this.answer_time_stamp,
      this.question,
      this.question_image_url,
      this.question_time_stamp,
      this.subject_name,
      this.name,
      this.profile_doubt_asked_url,
      this.status,
      this.uid});
}

/* return Container(
      child: Container(
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, data) {
            return Container(
              color: Colors.white,
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
                        Row(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image(
                                image: NetworkImage(
                                    record.profile_doubt_asked_url),
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              name,
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),

                  InkWell(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xFFffce45), Color(0xFFffce45)]),
                          borderRadius: BorderRadius.circular(12.0),
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
                                style: GoogleFonts.handlee(
                                    fontSize: 20, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),

                  //images
                  Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 30, right: 50, top: 50),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              image: AssetImage('assets/logo.png'),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image(
                              image: AssetImage('assets/logo.png'),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      )),

                  Padding(
                    padding: EdgeInsets.only(top: 30),
                  ),
                  // post date
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 14,
                    ),
                    alignment: Alignment.topLeft,
                    child: Text(finalTime,
                        style: GoogleFonts.handlee(
                            fontSize: 15, fontWeight: FontWeight.w100)),
                  ),

                  Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );*/

/*
class CombineStream {
  final Messages messages;
  final Users users;

  CombineStream(this.messages, this.users);
}

Stream<List<CombineStream>> _combineStream;


@override
void initState() {
  super.initState();
  _combineStream = Firestore.instance
      .collection('chat')
      .orderBy("timestamp", descending: true)
      .snapshots()
      .map((convert) {
    return convert.documents.map((f) {

      Stream<Messages> messages = Stream.value(f)
          .map<Messages>((document) => Messages.fromSnapshot(document));

      Stream<Users> user = Firestore.instance
          .collection("users")
          .document(f.data['uid'])
          .snapshots()
          .map<Users>((document) => Users.fromSnapshot(document));

      return Rx.combineLatest2(
          messages, user, (messages, user) => CombineStream(messages, user));
    });
  }).switchMap((observables) {
    return observables.length > 0
        ? Rx.combineLatestList(observables)
        : Stream.value([]);
  })
}
*/
