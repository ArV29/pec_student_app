import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/time_table.dart';
import 'package:pec_student/services/miscellaneous.dart';
import 'package:pec_student/services/networking.dart';
import 'package:pec_student/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditTimeTable extends StatefulWidget {
  static String id = 'edit_time_table';

  @override
  _EditTimeTableState createState() => _EditTimeTableState();
}

class _EditTimeTableState extends State<EditTimeTable> {
  List<Widget> editorCards = [Text('Loading...')];
  Map timeTable;
  int selectedDay = 0;
  bool unsavedChanges = false;
  void newClassDialogBox({@required context}) {
    String name = '', groups = '', duration = '', time = '0000';
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: kLightColor,
              title: Text(
                'Edit the class details',
                style: kNormalTextStyle.copyWith(color: kPrimaryColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Class Name: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: kNormalTextStyle.copyWith(color: kPrimaryColor),
                    initialValue: name,
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: InputDecoration(
                      fillColor: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Text(
                    'Starting time: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var t = await showTimePicker(
                        initialTime: TimeOfDay(
                          hour: int.parse(time.substring(0, 2)),
                          minute: int.parse(time.substring(2, 4)),
                        ),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          MiscellaneousFunctions()
                              .readableTime(militaryTime: time),
                          style: kNormalTextStyle.copyWith(
                              color: kLightHighlightColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Text(
                    'Class Duration: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: kNormalTextStyle.copyWith(color: kPrimaryColor),
                    initialValue: duration,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      duration = value;
                    },
                    decoration: InputDecoration(
                      fillColor: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Text(
                    'For Groups: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: kNormalTextStyle.copyWith(color: kPrimaryColor),
                    initialValue: groups,
                    onChanged: (value) {
                      groups = value;
                    },
                    decoration: InputDecoration(
                      fillColor: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  DialogButton(
                      color: kYellowAccentColor,
                      child: Text(
                        'Add new class',
                        style: kNormalTextStyle,
                      ),
                      onPressed: () {
                        if (name == '' || duration == '' || groups == '') {
                          Fluttertoast.showToast(
                              msg:
                                  "Some details are not set. Please add all the details",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: kLightColor,
                              textColor: kPrimaryColor,
                              fontSize: 16.0);
                          return;
                        }

                        timeTable[weekdays[selectedDay].toLowerCase()][time] = {
                          'name': name,
                          'duration': duration,
                          'groups': groups
                        };
                        unsavedChanges = true;
                        Navigator.pop(context);
                        buildEditorCards();
                      })
                ],
              ),
            );
          });
        });
  }

  void editClassDialogBox(
      {@required context, @required classDetails, @required classTime}) {
    String name = classDetails['name'],
        groups = classDetails['groups'],
        duration = classDetails['duration'],
        time = classTime;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: kLightColor,
              title: Text(
                'Edit the class details',
                style: kNormalTextStyle.copyWith(color: kPrimaryColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Class Name: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: kNormalTextStyle.copyWith(color: kPrimaryColor),
                    initialValue: name,
                    onChanged: (value) {
                      name = value;
                    },
                    decoration: InputDecoration(
                      fillColor: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Text(
                    'Starting time: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  GestureDetector(
                    onTap: () async {
                      var t = await showTimePicker(
                        initialTime: TimeOfDay(
                          hour: int.parse(time.substring(0, 2)),
                          minute: int.parse(time.substring(2, 4)),
                        ),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          MiscellaneousFunctions()
                              .readableTime(militaryTime: time),
                          style: kNormalTextStyle.copyWith(
                              color: kLightHighlightColor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Text(
                    'Class Duration: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: kNormalTextStyle.copyWith(color: kPrimaryColor),
                    initialValue: duration,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      duration = value;
                    },
                    decoration: InputDecoration(
                      fillColor: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Text(
                    'For Groups: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: kNormalTextStyle.copyWith(color: kPrimaryColor),
                    initialValue: groups,
                    onChanged: (value) {
                      groups = value;
                    },
                    decoration: InputDecoration(
                      fillColor: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  DialogButton(
                      color: kYellowAccentColor,
                      child: Text(
                        'Update Class Details',
                        style: kNormalTextStyle,
                      ),
                      onPressed: () {
                        if (name == '' || duration == '' || groups == '') {
                          Fluttertoast.showToast(
                              msg:
                                  "Some details are not set. Please add all the details",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: kLightColor,
                              textColor: kPrimaryColor,
                              fontSize: 16.0);
                          return;
                        }

                        timeTable[weekdays[selectedDay].toLowerCase()]
                            .remove(classTime);
                        timeTable[weekdays[selectedDay].toLowerCase()][time] = {
                          'name': name,
                          'duration': duration,
                          'groups': groups
                        };
                        unsavedChanges = true;
                        Navigator.pop(context);
                        buildEditorCards();
                      })
                ],
              ),
            );
          });
        });
  }

  Widget editTimeTableCard(
      {@required Map classDetails, @required String classTime}) {
    return Stack(
      children: [
        TimeTableCard(classDetails: classDetails, classTime: classTime),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundIconButton(
              icon: Icons.edit,
              onPress: () {
                editClassDialogBox(
                    context: context,
                    classDetails: classDetails,
                    classTime: classTime);
              },
              foregroundColor: kBlueAccentColor,
              backgroundColor: kLightHighlightColor,
            ),
            RoundIconButton(
              onPress: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Confirm Delete?',
                          style: kHeadingTextStyle2.copyWith(
                              color: kPrimaryColor,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600),
                        ),
                        backgroundColor: kLightColor,
                        actions: [
                          DialogButton(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Keep',
                                  style: kNormalTextStyle.copyWith(
                                    color: kGreenAccentColor,
                                  ),
                                ),
                              ),
                              color: kLightHighlightColor,
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          DialogButton(
                              color: kLightHighlightColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Delete',
                                  style: kNormalTextStyle.copyWith(
                                    color: kRedAccentColor,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                timeTable[weekdays[selectedDay].toLowerCase()]
                                    .remove(classTime);
                                unsavedChanges = true;
                                setState(() {
                                  buildEditorCards();
                                });
                                Navigator.pop(context);
                                return true;
                              })
                        ],
                      );
                    });
              },
              icon: Icons.delete_forever_rounded,
              backgroundColor: kLightHighlightColor,
              foregroundColor: kRedAccentColor,
            )
          ],
        )
      ],
    );
  }

  void getData() async {
    timeTable = await Networking().getTimeTable();
    buildEditorCards();
  }

  void buildEditorCards() {
    List<Widget> cards = [];
    String day = weekdays[selectedDay];
    Map timeTableForTheDay = timeTable[day.toLowerCase()];
    if (timeTableForTheDay.length == 0) {
      setState(() {
        editorCards = [
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
        child: editTimeTableCard(
            classDetails: timeTableForTheDay[time], classTime: time),
      ));
    }
    setState(() {
      editorCards = cards;
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
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RoundIconButton(
                icon: Icons.arrow_back_rounded,
                onPress: () {
                  if (unsavedChanges) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'You have unsaved changes.\nGoing back will discard them!',
                              style: kHeadingTextStyle2.copyWith(
                                  color: kPrimaryColor,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w600),
                            ),
                            backgroundColor: kLightColor,
                            actions: [
                              DialogButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Stay',
                                      style: kNormalTextStyle.copyWith(
                                        color: kGreenAccentColor,
                                      ),
                                    ),
                                  ),
                                  color: kLightHighlightColor,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              DialogButton(
                                  color: kLightHighlightColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Discard',
                                      style: kNormalTextStyle.copyWith(
                                        color: kRedAccentColor,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pushReplacementNamed(
                                        context, TimeTable.id);
                                  })
                            ],
                          );
                        });
                  } else {
                    Navigator.pop(context);
                  }
                },
                foregroundColor: kPrimaryColor,
                backgroundColor: kLightHighlightColor,
              ),
            ),
            backgroundColor: kLightColor,
            title: Text(
              'Edit Schedule',
              style: kHeadingTextStyle1.copyWith(
                  color: kSecondaryColor, fontSize: 44),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: RoundIconButton(
                  icon: Icons.done,
                  onPress: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              'Update schedule?',
                              style: kHeadingTextStyle2.copyWith(
                                  color: kPrimaryColor, fontSize: 30.0),
                            ),
                            backgroundColor: kLightColor,
                            actions: [
                              DialogButton(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Update',
                                      style: kNormalTextStyle.copyWith(
                                        color: kGreenAccentColor,
                                      ),
                                    ),
                                  ),
                                  color: kLightHighlightColor,
                                  onPressed: () async {
                                    unsavedChanges = false;
                                    Fluttertoast.showToast(
                                        msg: "Updating! Please wait",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: kLightColor,
                                        textColor: kPrimaryColor,
                                        fontSize: 16.0);
                                    await Networking()
                                        .updateTimeTable(timetable: timeTable);
                                    Navigator.pop(context);

                                    Navigator.pushReplacementNamed(
                                        context, TimeTable.id);
                                  }),
                              DialogButton(
                                  color: kLightHighlightColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Cancel',
                                      style: kNormalTextStyle.copyWith(
                                        color: kRedAccentColor,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  })
                            ],
                          );
                        });
                  },
                  foregroundColor: kPrimaryColor,
                  backgroundColor: kLightHighlightColor,
                ),
              ),
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
                              buildEditorCards();
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
                              buildEditorCards();
                            });
                          }),
                    ],
                  ),
                ),
                SizedBox(
                  width: 32.0,
                ),
                RoundIconButton(
                  icon: Icons.add_circle,
                  onPress: () {
                    newClassDialogBox(context: context);
                  },
                  foregroundColor: kGreenAccentColor,
                  backgroundColor: kLightHighlightColor,
                ),
                SizedBox(
                  height: 16.0,
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
                      children: editorCards,
                      scrollDirection: Axis.vertical,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          if (unsavedChanges) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'You have unsaved changes.\nGoing back will discard them!',
                      style: kHeadingTextStyle2.copyWith(
                          color: kPrimaryColor,
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600),
                    ),
                    backgroundColor: kLightColor,
                    actions: [
                      DialogButton(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Stay',
                              style: kNormalTextStyle.copyWith(
                                color: kGreenAccentColor,
                              ),
                            ),
                          ),
                          color: kLightHighlightColor,
                          onPressed: () {
                            Navigator.pop(context);
                            return false;
                          }),
                      DialogButton(
                          color: kLightHighlightColor,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Discard',
                              style: kNormalTextStyle.copyWith(
                                color: kRedAccentColor,
                              ),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pushReplacementNamed(
                                context, TimeTable.id);
                            return true;
                          })
                    ],
                  );
                });
          } else {
            return true;
          }
          return false;
        });
  }
}
