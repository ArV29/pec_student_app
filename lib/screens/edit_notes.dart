import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/services/miscellaneous.dart';
import 'package:pec_student/services/networking.dart';
import 'package:pec_student/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditNotes extends StatefulWidget {
  static String id = 'edit_notes';
  const EditNotes({Key key}) : super(key: key);

  @override
  _EditNotesState createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  Map notes;
  DateTime selectedDate;
  bool unsavedChanges = false;
  List<Widget> notesCards = [Text('Loading...')];
  void addInfoDialogBox({@required context}) {
    String title = '';
    String info = '';
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: kLightColor,
              title: Text(
                'Add note',
                style: kNormalTextStyle.copyWith(color: kPrimaryColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Class Heading: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: kNormalTextStyle.copyWith(color: kPrimaryColor),
                    initialValue: title,
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(
                      fillColor: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Text(
                    'Information: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: kNormalTextStyle.copyWith(color: kPrimaryColor),
                    initialValue: info,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: null,
                    onChanged: (value) {
                      info = value;
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
                        'Add Note',
                        style: kNormalTextStyle,
                      ),
                      onPressed: () {
                        if (title == '' || info == '') {
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
                        notes[selectedDate][title] = info;
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

  void editInfoDialogBox(
      {@required heading, @required content, @required context}) {
    String title = heading;
    String info = content;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: kLightColor,
              title: Text(
                'Edit note',
                style: kNormalTextStyle.copyWith(color: kPrimaryColor),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Heading: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: kNormalTextStyle.copyWith(color: kPrimaryColor),
                    initialValue: title,
                    onChanged: (value) {
                      title = value;
                    },
                    decoration: InputDecoration(
                      fillColor: kPrimaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Text(
                    'Information: ',
                    style: kHeadingTextStyle2.copyWith(color: kPrimaryColor),
                  ),
                  TextFormField(
                    textAlign: TextAlign.center,
                    style: kNormalTextStyle.copyWith(color: kPrimaryColor),
                    initialValue: info,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: null,
                    onChanged: (value) {
                      info = value;
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
                        'Update note',
                        style: kNormalTextStyle,
                      ),
                      onPressed: () {
                        if (title == '' || info == '') {
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
                        notes[selectedDate].remove(heading);
                        notes[selectedDate][title] = info;
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

  Widget editInfoCard({@required String heading, @required String content}) {
    return Stack(
      children: [
        InfoCard(
          heading: heading,
          content: content,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundIconButton(
              icon: Icons.edit,
              onPress: () {
                editInfoDialogBox(
                    heading: heading, content: content, context: context);
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
                                notes[selectedDate].remove(heading);
                                unsavedChanges = true;
                                setState(() {
                                  buildEditorCards();
                                });
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

  void buildEditorCards() {
    String date =
        MiscellaneousFunctions().networkingDateFormat(date: selectedDate);

    Map announcementsForTheDay = notes[date];
    if (announcementsForTheDay == null) {
      Widget card = Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: kYellowAccentColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'No announcements for the day',
            style: kHeadingTextStyle2.copyWith(
                fontSize: 25, color: kDarkHighlightColor),
          ),
        ),
      );
      setState(() {
        notesCards = [
          SizedBox(
            height: 128.0,
          ),
          card
        ];
      });
      return;
    }
    List<Widget> cards = [];
    for (String announcement in announcementsForTheDay.keys) {
      cards.add(SizedBox(height: 32.0));
      cards.add(editInfoCard(
          heading: announcement,
          content: announcementsForTheDay[announcement]));
      cards.add(SizedBox(height: 32.0));
    }

    setState(() {
      notesCards = cards;
    });
  }

  void getData() async {
    notes = await Networking().getNotes();

    buildEditorCards();
  }

  @override
  void initState() {
    selectedDate = DateTime.now();
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
            'Edit Notes',
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
                                  Networking().updateNotes(notes: notes);
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
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoundIconButton(
                        icon: Icons.arrow_back_ios_rounded,
                        onPress: () {
                          setState(() {
                            selectedDate =
                                selectedDate.subtract(Duration(days: 1));
                            buildEditorCards();
                          });
                        }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        MiscellaneousFunctions()
                            .formattedDate(date: selectedDate),
                        style: kHeadingTextStyle1.copyWith(
                            color: kLightHighlightColor, fontSize: 24.0),
                      ),
                    ),
                    RoundIconButton(
                        icon: Icons.arrow_forward_ios_rounded,
                        onPress: () {
                          setState(() {
                            selectedDate = selectedDate.add(Duration(days: 1));
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
                  addInfoDialogBox(context: context);
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
                    children: notesCards,
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
      },
    );
  }
}
