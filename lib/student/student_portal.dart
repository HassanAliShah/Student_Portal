import 'package:flutter/material.dart';
import 'package:test_project/student/application.dart';
import 'package:test_project/student/attandance.dart';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_project/student/attendance_report.dart';

class StudentPortal extends StatefulWidget {
  static String id = 'StudentPortal';
  @override
  _StudentPortalState createState() => _StudentPortalState();
}

class _StudentPortalState extends State<StudentPortal> {
  final _fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser;
  final authuser = FirebaseAuth.instance;
  String name, email;
  int day, month, year;

  currentDate() {
    day = int.parse(formatDate(DateTime.now(), [dd]));
    month = int.parse(formatDate(DateTime.now(), [mm]));
    year = int.parse(formatDate(DateTime.now(), [yyyy]));
  }

  void fetchData() async {
    final documents =
        await _fireStore.collection(auth.uid).doc('profile').get();
    name = documents.get('name');
    email = documents.get('email');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    currentDate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.teal.shade900,
              title: Text('Student Portal'),
              actions: [
                IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      authuser.signOut();
                      Navigator.pop(context);
                    })
              ],
            ),
            body: FutureBuilder(
                future: _fireStore.collection(auth.uid).doc(auth.uid).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school,
                            size: 150,
                            color: Colors.teal.shade900,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Student Portal',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal.shade900),
                          ),
                          SizedBox(height: 50),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Attendance(
                                  name: name,
                                );
                              }));
                            },
                            child: Text(
                              'Mark Attandance',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.teal.shade900,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return AttendanceReport();
                                  },
                                ),
                              );
                            },
                            child: Text('Attendance Report',
                                style: TextStyle(color: Colors.white)),
                            color: Colors.teal.shade900,
                          ),
                          RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Application(
                                            date: "$day$month$year",
                                          )));
                            },
                            child: Text('Application',
                                style: TextStyle(color: Colors.white)),
                            color: Colors.teal.shade900,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.teal.shade900),
                    ));
                  }
                })));
  }
}
