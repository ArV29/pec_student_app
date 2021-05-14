import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/services/networking.dart';

class TimeTable extends StatefulWidget {
  static String id = 'timetable';
  const TimeTable({Key key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  Map timeTable = {};
  int selectedDay = 0;
  List<Widget> classCards = [Text('Loading...')];
  List<String> weekdays = [
    'sunday',
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
  ];
  void buildClassCards() {
    List<Widget> cards = [];
    String day = weekdays[selectedDay];
    Map timeTableForTheDay = timeTable[day];
    print(timeTableForTheDay);
    if (timeTableForTheDay.length == 0) {
      print('here');
      setState(() {
        classCards = [
          SizedBox(
            height: 200.0,
          ),
          Container(
              margin: EdgeInsets.only(left: 10.0),
              child: Text(
                'No Classes Scheduled For Today',
                style: TextStyle(color: kLightAccentColor, fontSize: 60.0),
              ))
        ];
      });
      return;
    }
    for (String time in timeTableForTheDay.keys) {
      int hours = int.parse(time.substring(0, 2));
      if (hours > 12) {
        hours -= 12;
      }
      String h = hours.toString();
      if (hours < 10) {
        h = '0' + h;
      }

      String m = (time.substring(2));

      cards.add(
        classCardBuilder(
          subject: timeTableForTheDay[time]['name'],
          time: h + ':' + m,
          classLink: timeTableForTheDay[time]['link'],
          duration: timeTableForTheDay[time]['duration'],
          groups: timeTableForTheDay[time]['groups'],
        ),
      );
    }
    setState(() {
      classCards = [];
      for (int i = cards.length - 1; i >= 0; i--) {
        classCards.add(cards[i]);
      }
    });
  }

  void getTimeTable() async {
    timeTable = await Networking().getTimeTable();
    buildClassCards();
  }

  @override
  void initState() {
    super.initState();
    getTimeTable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: kLightAccentColor,
              width: 80.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100.0,
                  ),
                  buildGestureDetector(index: 0, day: 'S'),
                  buildGestureDetector(index: 1, day: 'M'),
                  buildGestureDetector(index: 2, day: 'T'),
                  buildGestureDetector(index: 3, day: 'W'),
                  buildGestureDetector(index: 4, day: 'T'),
                  buildGestureDetector(index: 5, day: 'F'),
                  buildGestureDetector(index: 6, day: 'S'),
                ],
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
                          'Time Table',
                          style: TextStyle(
                            color: kLightAccentColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        thickness: 5.0,
                        color: kLightAccentColor,
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: classCards,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container classCardBuilder(
      {@required String subject,
      @required String time,
      @required String classLink,
      @required String duration,
      @required String groups}) {
    return Container(
      height: 150,
      margin: EdgeInsets.only(left: 10.0, right: 20.0, top: 30.0),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30.0,
              ),
              Text(
                time,
                style: TextStyle(
                  color: Color(0xFFC4C4C4),
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                duration + ' hr',
                style: TextStyle(
                  color: kLightAccentColor,
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  color: kLightAccentColor,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          subject,
                          style: TextStyle(
                              color: kYellowAccentColor, fontSize: 25.0),
                        ),
                      ),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        'For Group(s) : ' + groups,
                        style:
                            TextStyle(color: kBackgroundColor, fontSize: 15.0),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  GestureDetector buildGestureDetector(
      {@required int index, @required String day}) {
    return GestureDetector(
      child: Container(
        height: 70.0,
        width: 70.0,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: (selectedDay == index) ? kYellowAccentColor : kBackgroundColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            day,
            style: TextStyle(
              color:
                  (selectedDay == index) ? kBackgroundColor : kLightAccentColor,
              fontSize: 35.0,
            ),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          selectedDay = index;
          buildClassCards();
        });
      },
    );
  }
}
