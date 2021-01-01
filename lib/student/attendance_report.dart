import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AttendanceReport extends StatefulWidget {
  @override
  _AttendanceReportState createState() => _AttendanceReportState();
}

class _AttendanceReportState extends State<AttendanceReport> {
  final _fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser;
  int size;

  getlength() async {
    var doc = await _fireStore.collection(auth.uid).doc().snapshots().length;
    size = doc;
  }

  void fetchData() async {
    final documents = await _fireStore.collection(auth.uid).get();
    for (int i = 0; i < documents.size - 1; i++) {
      var docName = documents.docs[i].id;
      var doc = await _fireStore.collection(auth.uid).doc(docName).get();
      doc.get('Day');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.teal.shade900,
          title: Text('Student Portal'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _fireStore.collection(auth.uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final documents = snapshot.data.docs;
                List<Widget> view = [];
                var data;
                int day, month, year;
                bool present, absent;
                for (var doc in documents) {
                  if (doc.id == 'profile') {
                  } else {
                    data = doc.data();
                    day = data['Day'];
                    month = data['Month'];
                    year = data['year'];
                    present = data['present'];
                    absent = data['absent'];
                    final dataWidget = Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.white10,
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                    child: Text(
                                      "$day/$month/$year",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.grey.shade900,
                                thickness: 1,
                                width: 2,
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.white10,
                                  padding: EdgeInsets.all(10),
                                  child: Center(
                                      child: present
                                          ? Icon(
                                              Icons.done,
                                              color: Colors.green.shade900,
                                            )
                                          : Icon(
                                              Icons.clear,
                                              color: Colors.red.shade900,
                                            )),
                                ),
                              ),
                              VerticalDivider(
                                color: Colors.grey.shade900,
                                thickness: 1,
                                width: 2,
                              ),
                              Expanded(
                                  child: Container(
                                color: Colors.white10,
                                padding: EdgeInsets.all(10),
                                child: Center(
                                  child: present
                                      ? Icon(
                                          Icons.clear,
                                          color: Colors.red.shade900,
                                        )
                                      : Icon(
                                          Icons.done,
                                          color: Colors.green.shade900,
                                        ),
                                ),
                              ))
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey.shade900,
                          height: 1,
                          thickness: 1,
                        ),
                      ],
                    );
                    view.add(dataWidget);
                  }
                }
                return Column(
                  children: [
                    Icon(
                      Icons.school,
                      size: 100,
                      color: Colors.teal.shade900,
                    ),
                    Text(
                      'Attendance Report',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.white10,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                'Date',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white10,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                'Present',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white10,
                            padding: EdgeInsets.all(10),
                            child: Center(
                              child: Text(
                                'Absent',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.grey.shade900,
                      height: 1,
                      thickness: 1,
                    ),
                    Container(
                      child: Column(
                        children: view,
                      ),
                    ),
                  ],
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }
}
