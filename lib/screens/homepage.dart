import 'package:flutter/material.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/personal_info.dart';
import 'package:pec_student/screens/time_table.dart';
import 'package:pec_student/services/networking.dart';

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
        body: SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Hero(
              tag: 'side_bar',
              child: Container(
                color: kLightAccentColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 100.0,
                      margin: EdgeInsets.only(left: 10.0, right: 20.0),
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Text(
                            'Home Page',
                            style: TextStyle(
                              color: kBackgroundColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        thickness: 3.0,
                        color: kBackgroundColor,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildNavigatorButtons(
                              context: context,
                              id: PersonalInfo.id,
                              text: 'Personal Info'),
                          buildNavigatorButtons(
                              context: context,
                              id: TimeTable.id,
                              text: 'Time Table'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 80.0,
            color: kBackgroundColor,
          ),
        ],
      ),
    ));
  }

  GestureDetector buildNavigatorButtons(
      {@required BuildContext context, @required id, @required text}) {
    return GestureDetector(
      child: Container(
        height: 80.0,
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: kBackgroundColor,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Center(
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              text,
              style: TextStyle(
                color: kLightAccentColor,
                fontSize: 30.0,
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, id);
      },
    );
  }
}
