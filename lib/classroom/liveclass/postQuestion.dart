import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doubt_out/model/userData.dart';
import 'package:doubt_out/widgets/alertBox.dart';
import 'package:flutter/material.dart';

class PostQuestion extends StatefulWidget {
  PostQuestion({this.subject});
  String subject;
  @override
  _PostQuestionState createState() => _PostQuestionState();
}

class _PostQuestionState extends State<PostQuestion> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = '4', name;
  Firestore _firestore = Firestore.instance;
  String question;
  int answerIndex;
  bool answerSelected = true;
  List<String> answers = [];
  List<bool> checkedAnswers = [];
  getUserData() async {
    var data = await UserData().getUserData();
    name = data[1];
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
      appBar: AppBar(
        title: Text('Add a question'),
      ),
      body: Container(
        margin: EdgeInsets.all(height * 0.02),
        child: Form(
          key: _formKey,
          child: ListView(
            physics: ScrollPhysics(parent: BouncingScrollPhysics()),
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'Enter the question'),
                validator: (val) {
                  if (val.length == 0) return 'Question cannot be empty';
                },
                onChanged: (val) {
                  question = val;
                },
              ),
              SizedBox(height: height * 0.02),
              Row(
                children: <Widget>[
                  Text('Select Number of options'),
                  SizedBox(width: width * 0.1),
                  DropdownButton(
                      value: dropdownValue,
                      items: <String>['2', '3', '4', '5']
                          .map<DropdownMenuItem<dynamic>>((String value) {
                        return DropdownMenuItem<String>(
                          child: Text(value),
                          value: value,
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() {
                          dropdownValue = val;
                        });
                      }),
                ],
              ),
              SizedBox(height: height * 0.02),
              Container(
                height: height * 0.14 * int.parse(dropdownValue),
                child: ListView.separated(
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  itemCount: int.parse(dropdownValue),
                  separatorBuilder: (context, index) {
                    return SizedBox(height: height * 0.05);
                  },
                  itemBuilder: (context, index) {
                    answers = [];

                    List.generate(int.parse(dropdownValue), (index) {
                      checkedAnswers.add(false);
                      // answers.add('');
                    });
                    return Row(
                      children: <Widget>[
                        Flexible(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Option ${index + 1}',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            // ignore: missing_return
                            validator: (value) {
                              if (value.length == 0) {
                                return "Invalid option";
                              } else {
                                answers.add(value);
                              }
                            },
                          ),
                        ),
                        Checkbox(
                          value: checkedAnswers[index],
                          onChanged: (val) {
                            for (var i = 0; i < checkedAnswers.length; i++) {
                              index == i
                                  ? checkedAnswers[i] = true
                                  : checkedAnswers[i] = false;
                              // checkedAnswers[i]=!checkedAnswers[i];
                            }
                            // print(checkedAnswers);
                            // setState(() {
                            //   checked=val;
                            //   checkedAnswers = checkedAnswers;

                            // });

                            setState(() {
                              checkedAnswers = checkedAnswers;
                              answerIndex = index;
                            });
                          },
                        )
                      ],
                    );
                  },
                ),
              ),
              answerSelected
                  ? Container()
                  : Text(
                      'Select one correct option.',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                      ),
                    )
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
        onPressed: () {
          if (_formKey.currentState.validate()) {
            if (answerIndex == null) {
              print(answers);
              print('Select the correct option');
              setState(() {
                answerSelected = false;
              });
            } else {
              print('validating the inputs from user');
              print(answers);
              print(answerIndex);
              _firestore
                  .collection('postedQuestions')
                  .document(widget.subject.toLowerCase())
                  .collection(widget.subject.toLowerCase())
                  .add({
                'question': question,
                'answer': answers[answerIndex],
                'answers': answers,
                'postedBy': name,
                'postedTime': DateTime.now(),
                'submitted': false,
                'subject': widget.subject
              });
              disapperDialog(
                context,
                Text('Question Posted'),
              );
            }
          }
        },
      ),
    );
  }
}
