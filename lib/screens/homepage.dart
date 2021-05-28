import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/email_screen.dart';
import 'package:pec_student/services/networking.dart';

import '../widgets.dart';
import 'initialize.dart';
import 'settings.dart';

class Homepage extends StatefulWidget {
  static String id = 'homepage';
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map userInfo;
  String name = '';
  Map timetable;
  Map assignments;
  Widget nextClass = Text('Loading...');
  Widget nextAssignment = Text('Loading...');
  String dayDate = weekdays[DateTime.now().weekday - 1] +
      ', ' +
      DateTime.now().day.toString() +
      ' ' +
      months[DateTime.now().month];
  void getData() async {
    userInfo = await Networking().getUserInfo();
    timetable = await Networking().getTimeTable();
    assignments = await Networking().getAssignments();
    print(assignments);
    setState(() {
      name = userInfo['name'].split(' ')[0];
      print(name);
      String nextClassTime = getNextClass();
      if (nextClassTime == '') {
        nextClass = Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: kYellowAccentColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'No more classes for today!',
                style: kHeadingTextStyle2.copyWith(
                    fontSize: 25, color: kDarkHighlightColor),
              ),
            ),
          ),
        );
      } else {
        String day = weekdays[DateTime.now().weekday];
        nextClass = TimeTableCard(
          classDetails: timetable[day][nextClassTime],
          classTime: nextClassTime,
        );
      }

      int nextAssignmentTime = getNextAssignment();
      if (nextAssignmentTime == 0) {
        nextAssignment = Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: kYellowAccentColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'No upcoming assignments!',
                style: kHeadingTextStyle2.copyWith(
                    fontSize: 25, color: kDarkHighlightColor),
              ),
            ),
          ),
        );
      } else {
        nextAssignment = AssignmentCard(
          assignmentDetails: assignments[nextAssignmentTime],
          assignmentTime: nextAssignmentTime,
        );
      }
    });
  }

  String getNextClass() {
    DateTime currentDateTime = DateTime.now();
    String day = weekdays[currentDateTime.weekday];
    String hours = currentDateTime.hour.toString();
    if (hours.length == 1) {
      hours = '0' + hours;
    }
    String minutes = currentDateTime.minute.toString();
    if (minutes.length == 1) {
      minutes = '0' + minutes;
    }
    String currentTime = hours + minutes;
    String nextClass = '';
    for (String time in timetable[day.toLowerCase()].keys) {
      if (time.compareTo(currentTime) >= 0) {
        if (nextClass == '' || time.compareTo(nextClass) <= 0) {
          nextClass = time;
        }
      }
    }
    return nextClass;
  }

  int getNextAssignment() {
    int currentDateTime = DateTime.now().millisecondsSinceEpoch;
    List assignmentDates = assignments.keys.toList();
    if (assignmentDates.length == 0) {
      return 0;
    }
    assignmentDates.sort();
    for (int time in assignmentDates) {
      if (time >= currentDateTime) {
        return time;
      }
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Networking().signOut();
                Navigator.pushNamedAndRemoveUntil(context, EmailScreen.id,
                    ModalRoute.withName(InitializeScreen.id));
              }),
        ),
        elevation: 0.0,
        backgroundColor: kPrimaryColor,
      ),
      backgroundColor: kPrimaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello,',
                          style: kNormalTextStyle.copyWith(
                              color: kLightColor, fontSize: 35.0),
                        ),
                        Text(
                          name,
                          style: kHeadingTextStyle2.copyWith(
                              color: kLightHighlightColor, fontSize: 40),
                        )
                      ],
                    ),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        FluttermojiCircleAvatar(
                          backgroundColor: kLightColor,
                          radius: 75.0,
                        ),
                        RoundIconButton(
                          icon: Icons.edit,
                          onPress: () {
                            Navigator.pushNamed(context, Settings.id);
                          },
                          backgroundColor: kLightColor,
                          foregroundColor: kPrimaryColor,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 32.0,
              ),
              Container(
                width: double.infinity,
                height: 1.0,
                color: kSecondaryColor,
              ),
              SizedBox(
                height: 32.0,
              ),
              Text(
                dayDate,
                style: kHeadingTextStyle1.copyWith(
                    color: kLightHighlightColor, fontSize: 35),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                      child: Text(
                        'Next Class:',
                        style: kHeadingTextStyle2.copyWith(
                            color: kLightColor, fontSize: 17),
                      ),
                    ),
                    nextClass,
                    SizedBox(
                      height: 32.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                      child: Text(
                        'Upcoming Assignment:',
                        style: kHeadingTextStyle2.copyWith(
                            color: kLightColor, fontSize: 17),
                      ),
                    ),
                    nextAssignment,
                  ],
                ),
              )
            ],
          ),
          BottomBar(index: 0),
        ],
      ),
    );
  }
}
