import 'package:flutter/material.dart';
import 'package:pec_student/screens/announcements.dart';
import 'package:pec_student/screens/assignments.dart';
import 'package:pec_student/screens/edit_announcements.dart';
import 'package:pec_student/screens/edit_assignments.dart';
import 'package:pec_student/screens/edit_time_table.dart';
import 'package:pec_student/screens/email_screen.dart';
import 'package:pec_student/screens/homepage.dart';
import 'package:pec_student/screens/initialize.dart';
import 'package:pec_student/screens/new_user_screen.dart';
import 'package:pec_student/screens/password_screen.dart';
import 'package:pec_student/screens/settings.dart';
import 'package:pec_student/screens/time_table.dart';

import 'constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        backgroundColor: kPrimaryColor,
        scaffoldBackgroundColor: kPrimaryColor,
        accentColor: kSecondaryColor,
        textTheme: TextTheme(
          bodyText1: TextStyle(color: kLightColor),
        ),
      ),
      initialRoute: InitializeScreen.id,
      routes: {
        InitializeScreen.id: (context) => InitializeScreen(),
        EmailScreen.id: (context) => EmailScreen(),
        PasswordScreen.id: (context) => PasswordScreen(),
        NewUserScreen.id: (context) => NewUserScreen(),
        Homepage.id: (context) => Homepage(),
        TimeTable.id: (context) => TimeTable(),
        EditTimeTable.id: (context) => EditTimeTable(),
        Assignments.id: (context) => Assignments(),
        EditAssignments.id: (context) => EditAssignments(),
        Announcements.id: (context) => Announcements(),
        EditAnnouncements.id: (context) => EditAnnouncements(),
        Settings.id: (context) => Settings(),
      },
    );
  }
}
