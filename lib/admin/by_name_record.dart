import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

class ByNameRecord extends StatefulWidget {
  final String userid;
  ByNameRecord({this.userid});
  @override
  _ByNameRecordState createState() => _ByNameRecordState();
}

class _ByNameRecordState extends State<ByNameRecord> {
  final _fireStore = FirebaseFirestore.instance;
  int presentinDay = 0;
  int Days = 0;
  int result;
  String grade;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Student Portal'),
          centerTitle: true,
          backgroundColor: Colors.teal.shade900,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal.shade900,
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                builder: (context) => BottomSheet(
                      id: widget.userid,
                    ));
          },
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection(widget.userid).snapshots(),
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
                      String Date = '$day$month$year';
                      Days++;
                      if (present == true) {
                        presentinDay++;
                      }

                      final dataWidget = Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              children: [
                                Expanded(
                                  child: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: Center(
                                          child: Text(
                                            'Delete',
                                          ),
                                        ),
                                        value: 1,
                                        height: 30,
                                      ),
                                    ],
                                    offset: Offset(0, 5),
                                    initialValue: 1,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    onSelected: (v) async {
                                      await _fireStore
                                          .collection(widget.userid)
                                          .doc(Date)
                                          .delete();
                                      print('data deleted');
                                    },
                                    child: Container(
                                      color: Colors.white,
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
                                ),
                                VerticalDivider(
                                  color: Colors.grey.shade900,
                                  thickness: 1,
                                  width: 2,
                                ),
                                Expanded(
                                  child: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: Center(
                                          child: Icon(
                                            Icons.done,
                                            color: Colors.green.shade900,
                                          ),
                                        ),
                                        value: 1,
                                        height: 5,
                                      ),
                                      PopupMenuItem(
                                        child: Center(
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.red.shade900,
                                          ),
                                        ),
                                        value: 2,
                                      ),
                                    ],
                                    onSelected: (v) async {
                                      if (v == 1) {
                                        print(v);
                                        await _fireStore
                                            .collection(widget.userid)
                                            .doc(Date)
                                            .update({
                                          'absent': false,
                                          'present': true,
                                        });
                                      } else {
                                        print(v);
                                        await _fireStore
                                            .collection(widget.userid)
                                            .doc(Date)
                                            .update({
                                          'absent': true,
                                          'present': false,
                                        });
                                      }
                                    },
                                    offset: Offset(0, 5),
                                    child: Container(
                                      color: Colors.white,
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
                                ),
                                VerticalDivider(
                                  color: Colors.grey.shade900,
                                  thickness: 1,
                                  width: 2,
                                ),
                                Expanded(
                                    child: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Center(
                                        child: Icon(
                                          Icons.done,
                                          color: Colors.green.shade900,
                                        ),
                                      ),
                                      value: 1,
                                      height: 5,
                                    ),
                                    PopupMenuItem(
                                      child: Center(
                                        child: Icon(
                                          Icons.clear,
                                          color: Colors.red.shade900,
                                        ),
                                      ),
                                      value: 2,
                                    ),
                                  ],
                                  offset: Offset(0, 5),
                                  onSelected: (v) async {
                                    if (v == 1) {
                                      print(v);
                                      await _fireStore
                                          .collection(widget.userid)
                                          .doc(Date)
                                          .update({
                                        'absent': true,
                                        'present': false,
                                      });
                                    } else {
                                      print(v);
                                      await _fireStore
                                          .collection(widget.userid)
                                          .doc(Date)
                                          .update({
                                        'absent': false,
                                        'present': true,
                                      });
                                    }
                                  },
                                  child: Container(
                                    color: Colors.white,
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
                  double percent = presentinDay / Days;
                  percent = percent * 100;
                  result = percent.ceil();
                  print(result);
                  if (result >= 80 && result <= 100) {
                    grade = 'A';
                  } else if (result >= 70 && result < 80) {
                    grade = 'B';
                  } else if (result >= 60 && result < 70) {
                    grade = 'C';
                  } else {
                    grade = 'D';
                  }
                  final datewidget = Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Your Attendance Grade is $grade',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                  view.add(datewidget);
                  return Column(
                    children: [
                      Icon(
                        Icons.school,
                        size: 100,
                        color: Colors.teal.shade900,
                      ),
                      Text(
                        'Attendance Report',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
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
      ),
    );
  }
}

class BottomSheet extends StatefulWidget {
  final String id;
  BottomSheet({this.id});
  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  final _fireStore = FirebaseFirestore.instance;
  bool present = true;
  bool absent = false;
  int presentSelected = 1;
  int absentSelected = 2;
  String date = 'Select Date';
  int day, month, year;

  @override
  Widget build(BuildContext context) {
    print(widget.id);
    return Container(
      height: 250,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add Attendance',
                  style: TextStyle(
                    color: Colors.teal.shade900,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                )
              ],
            ),
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
          ),
          IntrinsicHeight(
            child: Row(
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
                        date = formatDate(value, [dd, '/', mm, '/', yyyy]);
                        day = int.parse(formatDate(value, [dd]));
                        month = int.parse(formatDate(value, [mm]));
                        year = int.parse(formatDate(value, [yyyy]));
                        print('$day$month$year');
                      });
                    });
                  },
                  child: Text(
                    date,
                    style: TextStyle(color: Colors.black),
                  ),
                  color: Colors.white,
                ),
                VerticalDivider(
                  color: Colors.grey.shade900,
                  thickness: 1,
                  width: 2,
                ),
                Expanded(
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Center(
                          child: Icon(
                            Icons.done,
                            color: Colors.green.shade900,
                          ),
                        ),
                        value: 1,
                        height: 5,
                      ),
                      PopupMenuItem(
                        child: Center(
                          child: Icon(
                            Icons.clear,
                            color: Colors.red.shade900,
                          ),
                        ),
                        value: 2,
                      ),
                    ],
                    onSelected: (v) async {
                      setState(() {
                        if (v == 1) {
                          setState(() {
                            present = true;
                            absent = false;
                            presentSelected = 1;
                            absentSelected = 2;
                          });
                        } else {
                          setState(() {
                            present = false;
                            absent = true;
                            presentSelected = 2;
                            absentSelected = 1;
                          });
                        }
                      });
                    },
                    offset: Offset(0, 5),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Center(
                          child: presentSelected == 1
                              ? Icon(
                                  Icons.done,
                                  color: Colors.teal.shade900,
                                )
                              : Icon(
                                  Icons.clear,
                                  color: Colors.red.shade900,
                                )),
                    ),
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey.shade900,
                  thickness: 1,
                  width: 2,
                ),
                Expanded(
                  child: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Center(
                          child: Icon(
                            Icons.done,
                            color: Colors.green.shade900,
                          ),
                        ),
                        value: 1,
                        height: 5,
                      ),
                      PopupMenuItem(
                        child: Center(
                          child: Icon(
                            Icons.clear,
                            color: Colors.red.shade900,
                          ),
                        ),
                        value: 2,
                      ),
                    ],
                    onSelected: (v) async {
                      if (v == 1) {
                        setState(() {
                          present = false;
                          absent = true;
                          presentSelected = 2;
                          absentSelected = 1;
                        });
                      } else {
                        setState(() {
                          present = true;
                          absent = false;
                          presentSelected = 1;
                          absentSelected = 2;
                        });
                      }
                    },
                    offset: Offset(0, 5),
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(10),
                      child: Center(
                          child: absentSelected == 1
                              ? Icon(
                                  Icons.done,
                                  color: Colors.teal.shade900,
                                )
                              : Icon(
                                  Icons.clear,
                                  color: Colors.red.shade900,
                                )),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey.shade900,
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: RaisedButton(
              onPressed: () async {
                if (date == 'Select Date') {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Padding(
                        padding: const EdgeInsets.only(left: 50),
                        child: Text(
                          'Select Date to Add Attendance !',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  );
                } else {
                  await _fireStore
                      .collection(widget.id)
                      .doc('$day$month$year')
                      .set({
                    'present': present,
                    'absent': absent,
                    'Day': day,
                    'Month': month,
                    'year': year,
                  });
                  setState(() {
                    date = 'Select Date';
                    Navigator.pop(context);
                  });
                }
              },
              child: Text(
                'ADD',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              color: Colors.teal.shade900,
            ),
          )
        ],
      ),
    );
  }
}
