import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants.dart';
import '../services/miscellaneous.dart';
import '../services/networking.dart';
import '../widgets.dart';

class EditAssignments extends StatefulWidget {
  static String id = 'edit_assignments';
  const EditAssignments({Key key}) : super(key: key);

  @override
  _EditAssignmentsState createState() => _EditAssignmentsState();
}

class _EditAssignmentsState extends State<EditAssignments> {
  List<Widget> editorCards = [Text('Loading...')];
  Map assignments;
  bool unsavedChanges = false;
  void newAssignmentDialogBox({@required context}) {
    String name = '', groups = '';
    Map dateTime = MiscellaneousFunctions()
        .epochToReadableTime(epoch: DateTime.now().millisecondsSinceEpoch);
    String displayDate = dateTime['date'], displayTime = dateTime['time'];
    TimeOfDay time = TimeOfDay.now();
    DateTime date = DateTime.now();
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: kLightColor,
              title: Text(
                'Edit the assignment details',
                style: kNormalTextStyle.copyWith(color: kPrimaryColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Assignment Name: ',
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
                    'Submission deadline: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
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
                            time = t;
                            displayTime = MiscellaneousFunctions()
                                .readableTime(militaryTime: (hours + minutes));
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
                              displayTime,
                              style: kNormalTextStyle.copyWith(
                                  color: kLightHighlightColor),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year, 12, 31),
                          );
                          int day = date.day;
                          int month = date.month;

                          setState(() {
                            displayDate = day.toString() + months[month - 1];
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
                              displayDate,
                              style: kNormalTextStyle.copyWith(
                                  color: kLightHighlightColor),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                        'Add assignment Details',
                        style: kNormalTextStyle,
                      ),
                      onPressed: () {
                        if (name == '' ||
                            groups == '' ||
                            time == null ||
                            date == null) {
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

                        int assignmentTime = DateTime(date.year, date.month,
                                date.day, time.hour, time.minute)
                            .millisecondsSinceEpoch;
                        assignments[assignmentTime] = {
                          'name': name,
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

  void editAssignmentDialogBox(
      {@required context,
      @required assignmentDetails,
      @required int assignmentTime}) {
    String name = assignmentDetails['name'],
        groups = assignmentDetails['groups'];
    Map dateTime =
        MiscellaneousFunctions().epochToReadableTime(epoch: assignmentTime);
    String displayDate = dateTime['date'], displayTime = dateTime['time'];
    TimeOfDay time = TimeOfDay.fromDateTime(
        DateTime.fromMillisecondsSinceEpoch(assignmentTime));
    DateTime date = DateTime.fromMillisecondsSinceEpoch(assignmentTime);
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: kLightColor,
              title: Text(
                'Edit the assignment details',
                style: kNormalTextStyle.copyWith(color: kPrimaryColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Assignment Name: ',
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
                    'Submission deadline: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          var t = await showTimePicker(
                            initialTime: TimeOfDay.fromDateTime(
                                DateTime.fromMillisecondsSinceEpoch(
                                    assignmentTime)),
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
                            time = t;
                            displayTime = MiscellaneousFunctions()
                                .readableTime(militaryTime: (hours + minutes));
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
                              displayTime,
                              style: kNormalTextStyle.copyWith(
                                  color: kLightHighlightColor),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.fromMillisecondsSinceEpoch(
                                assignmentTime),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year, 12, 31),
                          );
                          int day = date.day;
                          int month = date.month;

                          setState(() {
                            displayDate = day.toString() + months[month - 1];
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
                              displayDate,
                              style: kNormalTextStyle.copyWith(
                                  color: kLightHighlightColor),
                            ),
                          ),
                        ),
                      ),
                    ],
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
                        'Update Assignment Details',
                        style: kNormalTextStyle,
                      ),
                      onPressed: () {
                        if (name == '' ||
                            groups == '' ||
                            time == null ||
                            date == null) {
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

                        assignments.remove(assignmentTime);
                        assignmentTime = DateTime(date.year, date.month,
                                date.day, time.hour, time.minute)
                            .millisecondsSinceEpoch;
                        assignments[assignmentTime] = {
                          'name': name,
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

  Widget editAssignmentCard(
      {@required Map assignmentDetails, @required int assignmentTime}) {
    return Stack(
      children: [
        AssignmentCard(
          assignmentTime: assignmentTime,
          assignmentDetails: assignmentDetails,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundIconButton(
              icon: Icons.edit,
              onPress: () {
                editAssignmentDialogBox(
                    context: context,
                    assignmentDetails: assignmentDetails,
                    assignmentTime: assignmentTime);
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
                                assignments.remove(assignmentTime);
                                unsavedChanges = true;
                                setState(() {
                                  buildEditorCards();
                                });
                                Navigator.pop(context);
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
    assignments = await Networking().getAssignments();
    buildEditorCards();
  }

  void buildEditorCards() {
    List<Widget> cards = [];
    int currentDateTime = DateTime.now().millisecondsSinceEpoch;
    List assignmentTimes = assignments.keys.toList();
    assignmentTimes.sort();
    if (assignments.length == 0 || assignmentTimes.last < currentDateTime) {
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
            child: Center(
              child: Text(
                'No Upcoming Assignments!',
                style: kHeadingTextStyle2.copyWith(
                    fontSize: 25, color: kDarkHighlightColor),
              ),
            ),
          ),
        ];
      });
      return;
    }

    for (int time in assignmentTimes) {
      if (time >= currentDateTime) {
        cards.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: editAssignmentCard(
              assignmentDetails: assignments[time], assignmentTime: time),
        ));
      }
    }

    setState(() {
      editorCards = cards;
    });
  }

  @override
  void initState() {
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
                                    Navigator.pop(context);
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
              'Edit Assignments',
              style: kHeadingTextStyle1.copyWith(
                  color: kSecondaryColor, fontSize: 30),
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
                              'Update the schedule?',
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
                                  onPressed: () {
                                    unsavedChanges = false;
                                    Networking().updateAssignments(
                                        assignments: assignments);

                                    Navigator.pop(context);
                                    Navigator.pop(context);
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
                SizedBox(
                  height: 32.0,
                ),
                RoundIconButton(
                  icon: Icons.add_circle,
                  onPress: () {
                    newAssignmentDialogBox(context: context);
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
                            Navigator.pop(context);
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
