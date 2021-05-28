import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pec_student/screens/announcements.dart';
import 'package:pec_student/screens/assignments.dart';
import 'package:pec_student/screens/homepage.dart';
import 'package:pec_student/screens/initialize.dart';
import 'package:pec_student/screens/notes.dart';
import 'package:pec_student/screens/time_table.dart';
import 'package:pec_student/services/miscellaneous.dart';

import 'constants.dart';

class TimeTableCard extends StatelessWidget {
  TimeTableCard({@required this.classDetails, @required this.classTime}) {
    this.time = MiscellaneousFunctions().readableTime(militaryTime: classTime);
    this.duration = classDetails['duration'] + 'hr';
    this.name = classDetails['name'];
    this.groups = 'Groups: ' + classDetails['groups'];
  }

  final Map classDetails;
  final String classTime;
  String time, duration, name, groups;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: kNormalTextStyle.copyWith(
                    color: kLightHighlightColor, fontSize: 20),
              ),
              Text(
                duration,
                style: kNormalTextStyle.copyWith(
                    color: kLightHighlightColor, fontSize: 20),
              ),
            ],
          ),
          SizedBox(
            width: 8.0,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: kYellowAccentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      style: kNormalTextStyle.copyWith(
                          fontSize: 25, color: kDarkHighlightColor),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      groups,
                      style: kNormalTextStyle.copyWith(
                          fontSize: 12, color: kSecondaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  RoundIconButton({
    @required this.icon,
    @required this.onPress,
    this.backgroundColor = kSecondaryColor,
    this.foregroundColor = kLightHighlightColor,
    this.radius = 35.0,
  });
  final IconData icon;
  final Function onPress;
  final Color backgroundColor;
  final Color foregroundColor;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
          height: radius,
          width: radius,
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(radius)),
          child: Center(
            child: Icon(
              icon,
              size: radius - 10.0,
              color: foregroundColor,
            ),
          )),
    );
  }
}

class BottomBar extends StatelessWidget {
  BottomBar({@required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 1,
          color: kLightColor,
        ),
        Container(
          width: double.infinity,
          color: kPrimaryColor,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoundIconButton(
                      icon: Icons.person,
                      onPress: () {
                        if (index != 0) {
                          Navigator.pushNamedAndRemoveUntil(
                              context,
                              Homepage.id,
                              ModalRoute.withName(InitializeScreen.id));
                        }
                      },
                      backgroundColor:
                          (index == 0) ? kLightHighlightColor : kLightColor,
                      foregroundColor: kPrimaryColor,
                      radius: 40,
                    ),
                    RoundIconButton(
                      icon: Icons.calendar_today_rounded,
                      onPress: () {
                        if (index < 1) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: TimeTable()));
                        } else if (index > 1) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: TimeTable()));
                        }
                      },
                      backgroundColor:
                          (index == 1) ? kLightHighlightColor : kLightColor,
                      foregroundColor: kPrimaryColor,
                      radius: 40,
                    ),
                    RoundIconButton(
                      icon: Icons.assignment,
                      onPress: () {
                        if (index < 2) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: Assignments()));
                        } else if (index > 2) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: Assignments()));
                        }
                      },
                      backgroundColor:
                          (index == 2) ? kLightHighlightColor : kLightColor,
                      foregroundColor: kPrimaryColor,
                      radius: 40,
                    ),
                    RoundIconButton(
                      icon: Icons.notifications,
                      onPress: () {
                        if (index < 3) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: Announcements()));
                        } else if (index > 3) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: Announcements()));
                        }
                      },
                      backgroundColor:
                          (index == 3) ? kLightHighlightColor : kLightColor,
                      foregroundColor: kPrimaryColor,
                      radius: 40,
                    ),
                    RoundIconButton(
                      icon: Icons.edit,
                      onPress: () {
                        if (index < 4) {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: Notes()));
                        }
                      },
                      backgroundColor:
                          (index == 4) ? kLightHighlightColor : kLightColor,
                      foregroundColor: kPrimaryColor,
                      radius: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AssignmentCard extends StatelessWidget {
  AssignmentCard(
      {@required this.assignmentTime, @required this.assignmentDetails}) {
    Map readableTime =
        MiscellaneousFunctions().epochToReadableTime(epoch: assignmentTime);
    time = readableTime['time'];
    date = readableTime['date'];
    name = assignmentDetails['name'];
    groups = 'Groups: ' + assignmentDetails['groups'];
  }

  final Map assignmentDetails;
  final int assignmentTime;
  String name, time, date, groups;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: kYellowAccentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      name,
                      style: kNormalTextStyle.copyWith(
                          fontSize: 25, color: kDarkHighlightColor),
                    ),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text(
                      groups,
                      style: kNormalTextStyle.copyWith(
                          fontSize: 12, color: kSecondaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Due: ',
                style: kNormalTextStyle.copyWith(
                    color: kLightHighlightColor, fontSize: 20),
              ),
              Text(
                time,
                style: kNormalTextStyle.copyWith(
                    color: kLightHighlightColor, fontSize: 20),
              ),
              Text(
                date,
                style: kNormalTextStyle.copyWith(
                    color: kLightHighlightColor, fontSize: 20),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  InfoCard({@required this.heading, @required this.content});

  final String heading;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: kLightColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                heading,
                style: kHeadingTextStyle2.copyWith(
                    color: kPrimaryColor, fontSize: 20.0),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(color: kYellowAccentColor, width: 1.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  content,
                  style: kNormalTextStyle.copyWith(
                      color: kLightColor, fontSize: 15.0),
                ),
              ),
            )
          ],
        ));
  }
}
