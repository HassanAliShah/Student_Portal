import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_project/admin/by_name_record.dart';
import 'package:test_project/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentRecord extends StatefulWidget {
  static String id = 'StudentRecord';
  final collection;
  StudentRecord({this.collection});
  @override
  _StudentRecordState createState() => _StudentRecordState();
}

class _StudentRecordState extends State<StudentRecord> {
  final auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  var userid;
  List<Widget> view = [];
  String name;
  String email;
  String password = '123456';

  getdetail() async {
    print('snapshot has data');
    for (String id in widget.collection) {
      String name;
      getData() async {
        return await _fireStore.collection(id).get().then((value) {
          for (var i in value.docs) {
            if (i.id == 'profile') {
              //get documentSnapshot of specific Document
              getDatadoc() async {
                return await _fireStore.collection(id).doc(i.id).get();
              }

              getDatadoc().then((value) {
                setState(() {
                  name = value.get('name');
                });
                print(name);
                final widget = GestureDetector(
                  child: Container(
                    height: 80,
                    child: Card(
                      child: IntrinsicHeight(
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.teal.shade900,
                              size: 50,
                            ),
                            VerticalDivider(
                              color: Colors.grey,
                              width: 0,
                              thickness: 1,
                              indent: 1,
                              endIndent: 1,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ByNameRecord(
                            userid: id,
                          );
                        },
                      ),
                    );
                  },
                );
                view.add(widget);
              });
            }
          }
        });
      }

      getData();

      //end or for loop
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdetail();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal.shade900,
            centerTitle: true,
            title: Text('Admin Portal'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: view,
            ),
          )),
    );
  }
}
