import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_project/admin/admin_page.dart';
import 'package:test_project/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_project/student/student_portal.dart';
import 'package:test_project/student/student_registration.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginPage extends StatefulWidget {
  static String id = 'LoginPage';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool textHide = true;
  Icon visibleIcon = Icon(Icons.visibility);
  Icon lockIcon = Icon(Icons.visibility_off);
  Icon _icon = Icon(Icons.visibility_off);
  final emailfieldText = TextEditingController();
  final passwordfieldText = TextEditingController();
  bool circleprogrss = false;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  void _showSnackbar() {
    final snack = SnackBar(
      content: Text("Sign in Failed"),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
    );
    _globalKey.currentState.showSnackBar(snack);
  }

  void clearText() {
    emailfieldText.clear();
    passwordfieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return SafeArea(
        child: Scaffold(
            key: _globalKey,
            backgroundColor: Colors.white,
            body: GestureDetector(
              onTap: () {
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
              child: ModalProgressHUD(
                inAsyncCall: circleprogrss,
                progressIndicator: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.teal.shade900),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.school,
                            color: Colors.teal.shade900,
                            size: 150,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Student Portal',
                              style: TextStyle(
                                  color: Colors.teal.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: TextField(
                              controller: emailfieldText,
                              decoration: KTextField.copyWith(
                                labelText: 'Email',
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                      color: Colors.teal.shade900, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                      color: Colors.teal.shade900, width: 2.0),
                                ),
                              ),
                              onChanged: (value) {
                                email = value;
                              },
                              onSubmitted: (value) {
                                email = value;
                              },
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: TextField(
                              controller: passwordfieldText,
                              decoration: KTextField.copyWith(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                      color: Colors.teal.shade900, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(
                                      color: Colors.teal.shade900, width: 2.0),
                                ),
                                labelText: 'Password',
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (textHide == true) {
                                        textHide = false;
                                        _icon = visibleIcon;
                                      } else {
                                        textHide = true;
                                        _icon = lockIcon;
                                      }
                                    });
                                  },
                                  icon: _icon,
                                  color: Colors.teal.shade900,
                                ),
                              ),
                              obscureText: textHide,
                              keyboardType: TextInputType.text,
                              onSubmitted: (value) {
                                password = value;
                              },
                              onChanged: (value) {
                                password = value;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          RaisedButton(
                            onPressed: () async {
                              currentFocus.unfocus();
                              setState(() {
                                circleprogrss = true;
                              });
                              try {
                                final user =
                                    await _auth.signInWithEmailAndPassword(
                                        email: email, password: password);
                                final currentuser =
                                    await _auth.currentUser.email;
                                print(currentuser);
                                if (user != null) {
                                  if (currentuser == 'xyz@email.com') {
                                    clearText();
                                    setState(() {
                                      circleprogrss = false;
                                    });
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return AdminPage();
                                    }));
                                  } else {
                                    setState(() {
                                      circleprogrss = false;
                                    });
                                    clearText();
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return StudentPortal();
                                    }));
                                  }
                                }
                              } catch (e) {
                                print(e);
                                setState(() {
                                  circleprogrss = false;
                                });
                                _showSnackbar();
                              }
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.teal.shade900,
                          ),
                          Text(
                            'OR',
                            style: TextStyle(
                                color: Colors.teal.shade900,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, StudentRegistration.id);
                            },
                            child: Text(
                              'Create Account',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.teal.shade900,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }
}
