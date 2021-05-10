import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pec_student/screens/homepage.dart';

import 'email_screen.dart';

class InitializeScreen extends StatefulWidget {
  static String id = 'initializeScreen';
  const InitializeScreen({Key key}) : super(key: key);

  @override
  _InitializeScreenState createState() => _InitializeScreenState();
}

class _InitializeScreenState extends State<InitializeScreen> {
  void initialize() async {
    await Firebase.initializeApp();
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushNamed(context, Homepage.id);
    } else {
      Navigator.pushNamed(context, EmailScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Hero(
            tag: 'logo',
            child: Center(
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
        ),
        SizedBox(
          height: 64,
        ),
        MaterialButton(
          onPressed: () {
            Navigator.pushNamed(context, EmailScreen.id);
          },
          child: Icon(Icons.arrow_forward_rounded),
        ),
      ],
    );
  }
}
