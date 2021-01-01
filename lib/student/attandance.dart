import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:date_format/date_format.dart';
import 'package:image_picker/image_picker.dart';

class Attendance extends StatefulWidget {
  static String id = 'Attendance';
  final String name;

  Attendance({this.name});

  @override
  _AttendanceState createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  final _fireStore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance.currentUser;
  int selectedRadio = 0;
  int presentRadio = 0;
  int absentRadio = 0;
  bool present, absent;
  int day, month, year;
  File _image;
  bool disableButton = false;

  Future getimage() async {
    final packedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (packedFile != null) {
        _image = File(packedFile.path);
      }
    });
  }

  getDate() {
    day = int.parse(formatDate(DateTime.now(), [dd]));
    month = int.parse(formatDate(DateTime.now(), [mm]));
    year = int.parse(formatDate(DateTime.now(), [yyyy]));
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  setPresent() {
    setState(() {
      present = true;
      absent = false;
    });
  }

  setAbsent() {
    setState(() {
      present = false;
      absent = true;
    });
  }

  getLastDate() async {
    final docref = await _fireStore.collection(auth.uid).get();
    for (int i = 0; i < docref.size - 1; i++) {
      String docName = docref.docs[i].id;
      if (docName == '$day$month$year') {
        setState(() {
          disableButton = true;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDate();
    presentRadio = 0;
    absentRadio = 0;
    getLastDate();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal.shade900,
          centerTitle: true,
          title: Text('Student Portal'),
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipOval(
                child: GestureDetector(
                  onTap: () {
                    getimage();
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: _image == null
                        ? Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 90,
                          )
                        : Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Mark Your Attendance',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Date : $day/$month/$year",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Present',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Radio(
                          value: 1,
                          groupValue: selectedRadio,
                          activeColor: Colors.teal.shade900,
                          onChanged: (value) {
                            setSelectedRadio(value);
                            setPresent();
                          }),
                    ],
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      Text(
                        'Absent',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Radio(
                          value: 2,
                          activeColor: Colors.teal.shade900,
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setSelectedRadio(value);
                            setAbsent();
                          }),
                    ],
                  )
                ],
              ),
              RaisedButton(
                color: Colors.teal,
                onPressed: disableButton
                    ? null
                    : () async {
                        Center(
                            child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation(Colors.teal.shade900),
                        ));
                        await _fireStore
                            .collection(auth.uid)
                            .doc("$day$month$year")
                            .set({
                          'present': present,
                          'absent': absent,
                          'Day': day,
                          'Month': month,
                          'year': year,
                        });
                        setState(() {
                          disableButton = true;
                        });
                      },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.teal.shade900,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "You Can't change your Attendance once you submitted",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 20,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
