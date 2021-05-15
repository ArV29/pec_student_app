import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/services/networking.dart';

class PersonalInfo extends StatefulWidget {
  static String id = 'personal_info_screen';
  const PersonalInfo({Key key}) : super(key: key);

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  Map info = {};
  Widget infoCard = Text('Loading...');
  TextStyle labelTextStyle =
      TextStyle(color: kYellowAccentColor, fontSize: 25.0);

  TextStyle valueTextStyle = TextStyle(color: kBackgroundColor, fontSize: 30.0);

  void getUserInfo() async {
    info = await Networking().getUserInfo();
    buildPersonalInfoCard();
  }

  void buildPersonalInfoCard() {
    Widget card = Container(
      padding:
          EdgeInsets.only(top: 15.0, bottom: 30.0, left: 20.0, right: 20.0),
      margin: EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
      decoration: BoxDecoration(
        color: kLightAccentColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Name:',
                style: labelTextStyle,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                info['name'],
                style: valueTextStyle,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Branch:',
                style: labelTextStyle,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                info['branch'].toUpperCase(),
                style: valueTextStyle,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text('Year:', style: labelTextStyle)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                info['year'].toString(),
                style: valueTextStyle,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text('Email:', style: labelTextStyle)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                FirebaseAuth.instance.currentUser.email,
                style: TextStyle(color: kBackgroundColor, fontSize: 15.0),
              )
            ],
          ),
        ],
      ),
    );

    setState(() {
      infoCard = card;
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'side_bar',
              child: Container(
                color: kLightAccentColor,
                width: 80.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100.0,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: kBackgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 100.0,
                      margin: EdgeInsets.only(left: 10.0, right: 20.0),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                          'Personal Info',
                          style: TextStyle(
                            color: kLightAccentColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        thickness: 3.0,
                        color: kLightAccentColor,
                      ),
                    ),
                    Container(child: Center(child: infoCard)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
