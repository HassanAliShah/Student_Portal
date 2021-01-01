import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllAttendanceReport extends StatefulWidget {
  static String id = 'AllAttendanceReport';
  final List alliID;
  AllAttendanceReport({this.alliID});
  @override
  _AllAttendanceReportState createState() => _AllAttendanceReportState();
}

class _AllAttendanceReportState extends State<AllAttendanceReport> {
  final _fireStore = FirebaseFirestore.instance;
  List<Widget> record = [];
  persondata() async {
    for (String id in widget.alliID) {
      String date;
      bool present;
      bool absent;
      int day, month, year;
      getData() async {
        return await _fireStore.collection(id).get().then((value) {
          for (var i in value.docs) {
            if (i.id == 'profile') {
              //get documentSnapshot of specific Document
              //end of user id
            } else {
              getDatadoc() async {
                return await _fireStore.collection(id).doc(i.id).get();
              } //end of function

              getDatadoc().then((value) {
                setState(() {
                  present = value.get('present');
                  absent = value.get('absent');
                  day = value.get('Day');
                  month = value.get('Month');
                  year = value.get('year');
                  date = '$day$month$year';
                  print(date);
                });
                final widget = Row(
                  children: [
                    Text(date),
                    Text('$present'),
                    Text('$absent'),
                  ],
                );
                record.add(widget);
                //record of one person
              });
              //end of else
            }
            //end of for loop
          }
        });
      }
      //end of first for loop
    }
    //end if if snapshotstatement
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    persondata();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Admin Portal'),
        backgroundColor: Colors.teal.shade900,
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Create Report of All Attendance',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
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
                                lastDate: DateTime(2022));
                          },
                          child: Text(
                            'Select Date',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.teal.shade900,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'To',
                          style: TextStyle(
                              color: Colors.teal.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FlatButton(
                          onPressed: () {
                            showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2022));
                          },
                          child: Text(
                            'Select Date',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.teal.shade900,
                        ),
                      ],
                    ),
                    RaisedButton(
                      onPressed: () {},
                      child: Text(
                        'Show Attendance',
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.teal.shade900,
                    )
                  ],
                ),
              ),
            ),
            Column(
              children: record,
            )
          ],
        ),
      ),
    ));
  }
}
