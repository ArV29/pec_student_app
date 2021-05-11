import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/edit_time_table.dart';
import 'package:pec_student/services/networking.dart';

class TimeTable extends StatefulWidget {
  static String id = 'timetable';
  const TimeTable({Key key}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {
  String branch;
  int year;
  int difference = 0;
  int weekday = DateTime.now().weekday - 1;
  Map timeTable;
  List<Widget> editTimeTable = [];
  Widget timeTableList = Text('Loading');
  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  void getTimeTable() async {
    timeTable = await Networking().getTimeTable();
    setState(() {
      timeTableList = buildTimeTable();
    });
    if (await Networking().isAdmin()) {
      setState(() {
        editTimeTable.add(TextButton(
          child: Text('Edit'),
          onPressed: () {
            Navigator.pushNamed(context, EditTimeTable.id);
          },
        ));
      });
    }
  }

  Widget buildTimeTable() {
    Map tt = timeTable[weekdays[weekday]];
    print(tt);
    List<Widget> timeTableCards = [];
    if (tt.length == 0) {
      print('here');
      return Text('No Classes Today');
    }

    for (String k in tt.keys) {
      Widget card = Container(
        height: 64.0,
        decoration: BoxDecoration(
            color: kElevatedBackgroundColor,
            borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(k),
            ),
            Text(tt[k])
          ],
        ),
      );
      timeTableCards.add(card);
    }
    return ListView(
      children: timeTableCards,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    if (weekday == -1) {
      weekday = 7;
    }
    getTimeTable();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        centerTitle: true,
        title: Text(
          'Time Table',
        ),
        actions: editTimeTable,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      weekday--;
                      if (weekday == -1) {
                        weekday = 7;
                      }
                      timeTableList = buildTimeTable();
                    });
                  }),
              Text(weekdays[weekday]),
              IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      weekday++;
                      if (weekday == 7) {
                        weekday = 0;
                      }
                      timeTableList = buildTimeTable();
                    });
                  }),
            ],
          ),
          Expanded(
            child: timeTableList,
          ),
        ],
      ),
    );
  }
}
