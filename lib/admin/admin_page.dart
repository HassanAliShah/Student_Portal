import 'package:flutter/material.dart';
import 'package:test_project/admin/all_attendance_report.dart';
import 'package:test_project/admin/student_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminPage extends StatefulWidget {
  static String id = 'AdminPage';
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  List<String> Userid = [];
  void getUserId() async {
    var documents = await _fireStore.collection('user').get();
    print(documents.docs);
    for (var x in documents.docs) {
      print(x.id);
      Userid.add(x.id);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.teal.shade900,
              centerTitle: true,
              title: Text('Admin Portal'),
              actions: [
                IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () async {
                      await _auth.signOut();
                      Navigator.pop(context);
                    })
              ],
            ),
            body: Container(
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return StudentRecord(
                            collection: Userid,
                          );
                        }));
                      },
                      child: Text(
                        'View Student Record',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.teal.shade900,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 80),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return AllAttendanceReport(alliID: Userid);
                        }));
                      },
                      child: Text(
                        'Create Report',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.teal.shade900,
                    ),
                  ),
                ],
              ),
            )));
  }
}
