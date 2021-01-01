import 'package:flutter/material.dart';
import 'package:test_project/admin/admin_page.dart';
import 'package:test_project/admin/all_attendance_report.dart';
import 'package:test_project/admin/student_record.dart';
import 'package:test_project/login_page.dart';
import 'package:test_project/student/application.dart';
import 'package:test_project/student/attandance.dart';
import 'package:test_project/student/student_portal.dart';
import 'package:test_project/student/student_registration.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: LoginPage.id,
      routes: {
        AllAttendanceReport.id: (context) => AllAttendanceReport(),
        StudentRecord.id: (context) => StudentRecord(),
        AdminPage.id: (context) => AdminPage(),
        Application.id: (context) => Application(),
        StudentPortal.id: (context) => StudentPortal(),
        StudentRegistration.id: (context) => StudentRegistration(),
        Attendance.id: (context) => Attendance(),
        LoginPage.id: (context) => LoginPage()
      },
    );
  }
}
