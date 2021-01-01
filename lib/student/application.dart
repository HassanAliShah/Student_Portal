import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_format/date_format.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Application extends StatefulWidget {
  static String id = 'Application';
  final String date;

  Application({this.date});

  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final _fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser;
  String subject, body;
  String from = 'From';
  String to = 'TO';
  bool circleprogrss = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.teal.shade900,
            title: Text('Student Portal'),
          ),
          body: ModalProgressHUD(
            inAsyncCall: circleprogrss,
            progressIndicator: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.teal.shade900),
            ),
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.school,
                      color: Colors.teal.shade900,
                      size: 150,
                    ),
                    Divider(
                      height: 5,
                      color: Colors.transparent,
                    ),
                    Center(
                      child: Text(
                        'Leave Application',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.teal.shade900),
                      ),
                    ),
                    Divider(
                      height: 20,
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2022))
                                .then((value) {
                              setState(() {
                                from =
                                    formatDate(value, [dd, '/', mm, '/', yyyy]);
                              });
                            });
                          },
                          child: Text(
                            from == null ? 'From' : from,
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.teal.shade900,
                        ),
                        VerticalDivider(
                          width: 20,
                        ),
                        FlatButton(
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2022))
                                .then((value) {
                              setState(() {
                                to =
                                    formatDate(value, [dd, '/', mm, '/', yyyy]);
                              });
                            });
                          },
                          child: Text(
                            to == null ? 'TO' : to,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          color: Colors.teal.shade900,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Subject",
                          labelStyle: TextStyle(color: Colors.teal.shade900),
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.teal.shade900, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.teal.shade900, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.teal.shade900, width: 2),
                          ),
                        ),
                        onChanged: (String value) {
                          subject = value;
                        },
                        onSubmitted: (String value) {
                          subject = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.teal.shade900, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.teal.shade900, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.teal.shade900, width: 2),
                          ),
                        ),
                        maxLines: 8,
                        onChanged: (String value) {
                          body = value;
                        },
                        onSubmitted: (String value) {
                          body = value;
                        },
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                      child: RaisedButton(
                        onPressed: () async {
                          if (from == 'From' || to == 'To') {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Padding(
                                  padding: const EdgeInsets.only(left: 50),
                                  child: Text(
                                    'Select Date !',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            setState(() {
                              circleprogrss = true;
                            });
                            await _fireStore
                                .collection(auth.uid)
                                .doc(widget.date)
                                .update({
                              'From': from,
                              'To': to,
                              'Subject': subject,
                              'Body': body
                            });
                            setState(() {
                              circleprogrss = false;
                            });
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Padding(
                                  padding: const EdgeInsets.only(left: 50),
                                  child: Text(
                                    'Application Submitted !',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.teal.shade900,
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
