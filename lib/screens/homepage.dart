import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/edit_time_table.dart';
import 'package:pec_student/screens/time_table.dart';
import 'package:pec_student/services/networking.dart';

import 'initialize.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key key}) : super(key: key);
  static String id = 'homepage';
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String name = '';
  bool showSpinner = false;

  void getData() async {
    Map userInfo = await Networking().getUserInfo();
    setState(() {
      name = userInfo['name'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'HomePage',
                style: TextStyle(
                  fontSize: 45.0,
                  color: kHintLightTextColor,
                ),
              ),
            ),
            SizedBox(
              height: 64.0,
            ),
            Text(
              'Welcome\n' + name,
              style: TextStyle(
                fontSize: 30.0,
                color: kLightTextColor,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(
              height: 250.0,
            ),
            MaterialButton(
              onPressed: () async {
                setState(() {
                  showSpinner = true;
                });
                await Networking().signOut();
                setState(() {
                  showSpinner = false;
                });
                Navigator.pushNamed(context, InitializeScreen.id);
              },
              child: Text('Sign Out'),
              enableFeedback: true,
              color: kRedAccentColor,
              textColor: kLightTextColor,
            ),
            MaterialButton(
              onPressed: () async {
                Navigator.pushNamed(context, TimeTable.id);
              },
              child: Text('Time Table'),
              enableFeedback: true,
              color: kRedAccentColor,
              textColor: kLightTextColor,
            ),
            MaterialButton(
              onPressed: () async {
                Navigator.pushNamed(context, EditTimeTable.id);
              },
              child: Text('Edit Time Table'),
              enableFeedback: true,
              color: kRedAccentColor,
              textColor: kLightTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
