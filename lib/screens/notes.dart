import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pec_student/screens/edit_announcements.dart';
import 'package:pec_student/services/miscellaneous.dart';

import '../constants.dart';
import '../services/networking.dart';
import '../widgets.dart';

class Notes extends StatefulWidget {
  static String id = 'notes';
  const Notes({Key key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  Map notes;
  DateTime selectedDate;
  List<Widget> notesCards = [Text('Loading...')];

  void buildNotesCards() {
    String date =
        MiscellaneousFunctions().networkingDateFormat(date: selectedDate);

    Map notesForTheDay = notes[date];
    if (notesForTheDay == null) {
      Widget card = Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: kYellowAccentColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            'No notes added for the day',
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
    for (String note in notesForTheDay.keys) {
      cards.add(SizedBox(height: 32.0));
      cards.add(InfoCard(heading: note, content: notesForTheDay[note]));
      cards.add(SizedBox(height: 32.0));
    }

    setState(() {
      notesCards = cards;
    });
  }

  void getData() async {
    notes = await Networking().getNotes();

    buildNotesCards();
  }

  @override
  void initState() {
    selectedDate = DateTime.now();
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
          'Notes',
          style:
              kHeadingTextStyle1.copyWith(color: kSecondaryColor, fontSize: 36),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: RoundIconButton(
              icon: Icons.edit,
              onPress: () {
                Navigator.pushNamed(context, EditAnnouncements.id);
              },
              foregroundColor: kPrimaryColor,
              backgroundColor: kLightHighlightColor,
            ),
          )
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
                          buildNotesCards();
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
                          buildNotesCards();
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
                  children: notesCards,
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
            BottomBar(
              index: 4,
            ),
          ],
        ),
      ),
    );
  }
}
