import 'package:flutter/material.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/services/networking.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditTimeTable extends StatefulWidget {
  static String id = 'edit_time_table';
  const EditTimeTable({Key key}) : super(key: key);

  @override
  _EditTimeTableState createState() => _EditTimeTableState();
}

class _EditTimeTableState extends State<EditTimeTable> {
  Map subjects;
  String day = 'Monday';
  List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  Widget timeTableEditor = Text('Loading...');
  Map timeTable = {};

  void buildTimeTableEditor() async {
    subjects = await Networking().getSubjects();
    List<Widget> children = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: MaterialButton(
          color: kRedAccentColor,
          textColor: kLightTextColor,
          onPressed: () {
            showSelectionDialog(context);
          },
          child: Text('Add New Class'),
        ),
      ),
    ];
    for (String k in timeTable.keys) {
      Widget card = Container(
        decoration: BoxDecoration(
            color: kElevatedBackgroundColor,
            borderRadius: BorderRadius.circular(10.0)),
        margin: EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text('Subject Code: ' + timeTable[k]['name']),
            SizedBox(height: 8.0),
            Text('Start Time: $k'),
            SizedBox(height: 8.0),
            Text('Duration: ' + timeTable[k]['duration'] + 'hr'),
            SizedBox(
              height: 8.0,
            ),
            Text('Groups: ' + timeTable[k]['groups']),
          ],
        ),
      );
      children.add(card);
    }
    children.add(SizedBox(
      height: 32.0,
    ));
    children.add(
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: MaterialButton(
          color: kRedAccentColor,
          textColor: kLightTextColor,
          onPressed: () async {
            Networking().updateTimeTable(
                weekday: day.toLowerCase(), timeTable: timeTable);
            timeTable = {};
            buildTimeTableEditor();
          },
          child: Text('Update Time Table'),
        ),
      ),
    );

    setState(() {
      timeTableEditor = ListView(
        children: children,
        shrinkWrap: true,
      );
    });
  }

  void showSelectionDialog(context) {
    String subject = '';
    String time = 'Select Time';
    String duration = '';
    String groups = '';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Select Class and Time'),
              content: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      subject = value;
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Class Name',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kElevatedBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  TextButton(
                      onPressed: () async {
                        var t = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );
                        String hours = t.hour.toString();
                        if (hours.length == 1) {
                          hours = '0' + hours;
                        }
                        String minutes = t.minute.toString();
                        if (minutes.length == 1) {
                          minutes = '0' + minutes;
                        }
                        setState(() {
                          time = hours + minutes;
                        });
                      },
                      child: Text(time)),
                  TextField(
                    onChanged: (value) {
                      duration = value;
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Class duration',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kElevatedBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      groups = value;
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Groups the class is for',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kElevatedBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                DialogButton(
                  onPressed: () {
                    if (duration == '' ||
                        time == 'Loading...' ||
                        duration == '' ||
                        groups == '' ||
                        subject == '') {
                      return;
                    }
                    setState(() {
                      timeTable[time] = {
                        'name': subject,
                        'duration': duration,
                        'groups': groups,
                        'link': 'null'
                      };
                    });

                    print(
                        'Code: $subject \n Starting Time : $time \n Duration : $duration\n Groups : $groups');
                    Navigator.pop(context);
                    buildTimeTableEditor();
                  },
                  child: Text(
                    'CONFIRM SLOT ADDITION',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    buildTimeTableEditor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text('Edit Time Table'),
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Select Weekday:'),
              SizedBox(
                width: 32.0,
              ),
              DropdownButton(
                value: day,
                items: weekdays.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    day = newValue;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            height: 64.0,
          ),
          Expanded(child: timeTableEditor),
        ],
      ),
    );
  }
}
