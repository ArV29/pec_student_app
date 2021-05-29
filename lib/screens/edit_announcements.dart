import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/announcements.dart';
import 'package:pec_student/services/miscellaneous.dart';
import 'package:pec_student/services/networking.dart';
import 'package:pec_student/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditAnnouncements extends StatefulWidget {
  static String id = 'edit_announcements';
  const EditAnnouncements({Key key}) : super(key: key);

  @override
  _EditAnnouncementsState createState() => _EditAnnouncementsState();
}

class _EditAnnouncementsState extends State<EditAnnouncements> {
  Map announcements;
  DateTime selectedDate;
  bool unsavedChanges = false;
  List<Widget> announcementCards = [Text('Loading...')];
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
                'Add Announcement',
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
                        'Add Announcement',
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
                        if (announcements[MiscellaneousFunctions()
                                .networkingDateFormat(date: selectedDate)] ==
                            null) {
                          announcements[MiscellaneousFunctions()
                              .networkingDateFormat(date: selectedDate)] = {};
                        }
                        announcements[MiscellaneousFunctions()
                                .networkingDateFormat(date: selectedDate)]
                            [title] = info;
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
                'Edit the Announcement details',
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
                        'Update Announcement',
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
                        announcements[MiscellaneousFunctions()
                                .networkingDateFormat(date: selectedDate)]
                            .remove(heading);
                        announcements[MiscellaneousFunctions()
                                .networkingDateFormat(date: selectedDate)]
                            [title] = info;
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
                                announcements[MiscellaneousFunctions()
                                        .networkingDateFormat(
                                            date: selectedDate)]
                                    .remove(heading);
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

  void buildEditorCards() {
    String date =
        MiscellaneousFunctions().networkingDateFormat(date: selectedDate);

    Map announcementsForTheDay = announcements[date];
    if (announcementsForTheDay == null || announcementsForTheDay.length == 0) {
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
        announcementCards = [
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
      announcementCards = cards;
    });
  }

  void getData() async {
    announcements = await Networking().getAnnouncements();

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
                                  Navigator.pushReplacementNamed(
                                      context, Announcements.id);
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
            'Edit Announcements',
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
                            'Update announcements?',
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
                                      msg: "Updating! Pease wait",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: kLightColor,
                                      textColor: kPrimaryColor,
                                      fontSize: 16.0);
                                  await Networking().updateAnnouncements(
                                      announcements: announcements);

                                  Navigator.pop(context);
                                  Navigator.pushReplacementNamed(
                                      context, Announcements.id);
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
                    children: announcementCards,
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
                              context, Announcements.id);
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
