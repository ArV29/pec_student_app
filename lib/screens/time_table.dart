import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/edit_time_table.dart';
import 'package:pec_student/services/networking.dart';
import 'package:pec_student/widgets.dart';

class TimeTable extends StatefulWidget {
  static String id = 'timetable';
  const TimeTable({Key key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  Map timeTable = {};
  int selectedDay = 0;
  bool isAdmin = false;
  List<Widget> classCards = [Text('Loading...')];

  void buildClassCards() {
    List<Widget> cards = [];
    String day = weekdays[selectedDay];
    Map timeTableForTheDay = timeTable[day.toLowerCase()];
    if (timeTableForTheDay.length == 0) {
      setState(() {
        classCards = [
          SizedBox(
            height: 128.0,
          ),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: kYellowAccentColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'No classes for today!',
              style: kHeadingTextStyle2.copyWith(
                  fontSize: 25, color: kDarkHighlightColor),
            ),
          ),
        ];
      });
      return;
    }
    List<String> classTimings = timeTableForTheDay.keys.toList();
    classTimings.sort((a, b) => a.compareTo(b));
    for (String time in classTimings) {
      cards.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: TimeTableCard(
            classDetails: timeTableForTheDay[time], classTime: time),
      ));
    }
    setState(() {
      classCards = cards;
    });
  }

  void getData() async {
    timeTable = await Networking().getTimeTable();
    buildClassCards();
    Map userData = await Networking().getUserInfo();

    setState(() {
      isAdmin = userData['isAdmin'];
    });
  }

  @override
  void initState() {
    selectedDay = DateTime.now().weekday - 1;
    if (selectedDay == 7) {
      selectedDay = 0;
    }
    super.initState();

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightColor,
        leading: Container(),
        title: Text(
          'Schedule',
          style:
              kHeadingTextStyle1.copyWith(color: kSecondaryColor, fontSize: 44),
        ),
        actions: [
          (isAdmin)
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RoundIconButton(
                    icon: Icons.edit,
                    onPress: () {
                      Navigator.pushNamed(context, EditTimeTable.id,
                          arguments: timeTable);
                    },
                    foregroundColor: kPrimaryColor,
                    backgroundColor: kLightHighlightColor,
                  ),
                )
              : Container(),
        ],
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundIconButton(
                      icon: Icons.arrow_back_ios_rounded,
                      onPress: () {
                        setState(() {
                          selectedDay--;
                          if (selectedDay == -1) {
                            selectedDay = 6;
                          }
                          buildClassCards();
                        });
                      }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      weekdays[selectedDay],
                      style: kHeadingTextStyle1.copyWith(
                          color: kLightHighlightColor, fontSize: 24.0),
                    ),
                  ),
                  RoundIconButton(
                      icon: Icons.arrow_forward_ios_rounded,
                      onPress: () {
                        setState(() {
                          selectedDay++;
                          if (selectedDay == 7) {
                            selectedDay = 0;
                          }
                          buildClassCards();
                        });
                      }),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: kLightColor,
              height: 1.0,
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: classCards,
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
            BottomBar(
              index: 1,
            ),
          ],
        ),
      ),
    );
  }
}
