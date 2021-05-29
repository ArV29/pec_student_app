import 'package:flutter/material.dart';
import 'package:pec_student/constants.dart';

class EmailNotVerified extends StatelessWidget {
  static String id = 'email_not_verified';
  const EmailNotVerified({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Hero(
              tag: 'logo',
              child: Image.asset('assets/images/logo.png'),
            ),
          ),
          SizedBox(
            height: 128.0,
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: kYellowAccentColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'Email verification link sent!\n Please verify the email by clicking on the link sent on your email ID!',
                style: kHeadingTextStyle2.copyWith(
                    fontSize: 25, color: kDarkHighlightColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
