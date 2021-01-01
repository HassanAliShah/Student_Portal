import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:test_project/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_project/login_page.dart';

class StudentRegistration extends StatefulWidget {
  static String id = 'StudentRegistration';
  @override
  _StudentRegistrationState createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String name, email, password;
  bool textHide = true;
  Icon visibleIcon = Icon(Icons.visibility);
  Icon lockIcon = Icon(Icons.visibility_off);
  Icon _icon = Icon(Icons.visibility_off);
  final namefieldText = TextEditingController();
  final emailfieldText = TextEditingController();
  final passwordfieldText = TextEditingController();
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  bool circleprogrss = false;

  void _showSnackbar() {
    final snack = SnackBar(
      content: Text("Registration Failed"),
      duration: Duration(seconds: 3),
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
    );
    _globalKey.currentState.showSnackBar(snack);
  }

  void clearText() {
    namefieldText.clear();
    emailfieldText.clear();
    passwordfieldText.clear();
  }

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Scaffold(
            key: _globalKey,
            body: ModalProgressHUD(
              inAsyncCall: circleprogrss,
              progressIndicator: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.teal.shade900),
              ),
              child: SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
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
                            controller: namefieldText,
                            decoration: KTextField.copyWith(
                              labelText: 'Name',
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
                            onSubmitted: (value) {
                              name = value;
                            },
                            onChanged: (value) {
                              name = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
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
                              labelText: 'Password',
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
                          height: 30,
                        ),
                        FlatButton(
                          onPressed: () async {
                            currentFocus.unfocus();
                            setState(() {
                              circleprogrss = true;
                            });
                            currentFocus.unfocus();
                            try {
                              final user =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                              final currentUser =
                                  FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                await _fireStore
                                    .collection(currentUser.uid)
                                    .doc('profile')
                                    .set({
                                  'email': email,
                                  'name': name,
                                });
                                await _fireStore
                                    .collection('user')
                                    .doc(currentUser.uid)
                                    .set({});
                                clearText();
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Icon(
                                      Icons.check_circle,
                                      color: Colors.green.shade900,
                                    ),
                                    content: Padding(
                                      padding: const EdgeInsets.only(left: 50),
                                      child: Text(
                                        'Account Create Successfully',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                );
                                setState(() {
                                  circleprogrss = false;
                                });
                              }
                            } catch (e) {
                              print('Error');
                              setState(() {
                                circleprogrss = false;
                              });
                              _showSnackbar();
                            }
                          },
                          child: Text(
                            'Register',
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
                          onPressed: () {
                            Navigator.pushNamed(context, LoginPage.id);
                          },
                          child: Text(
                            'Already Have Account',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Colors.teal.shade900,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
