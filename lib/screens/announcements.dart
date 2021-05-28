import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pec_student/screens/edit_announcements.dart';
import 'package:pec_student/services/miscellaneous.dart';

import '../constants.dart';
import '../services/networking.dart';
import '../widgets.dart';

class Announcements extends StatefulWidget {
  static String id = 'announcements';

  const Announcements({Key key}) : super(key: key);

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  bool isAdmin = false;
  Map announcements;
  DateTime selectedDate;
  List<Widget> announcementCards = [Text('Loading...')];

  void buildAnnouncementCards() {
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
      cards.add(InfoCard(
          heading: announcement,
          content: announcementsForTheDay[announcement]));
      cards.add(SizedBox(height: 32.0));
    }

    setState(() {
      announcementCards = cards;
    });
  }

  void getData() async {
    Map userData = await Networking().getUserInfo();
    announcements = await Networking().getAnnouncements();
    setState(() {
      isAdmin = userData['isAdmin'];
    });
    buildAnnouncementCards();
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
          'Announcements',
          style:
              kHeadingTextStyle1.copyWith(color: kSecondaryColor, fontSize: 36),
        ),
        actions: [
          (isAdmin)
              ? Padding(
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
                          selectedDate =
                              selectedDate.subtract(Duration(days: 1));
                          buildAnnouncementCards();
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
                          buildAnnouncementCards();
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
                  children: announcementCards,
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
            BottomBar(
              index: 3,
            ),
          ],
        ),
      ),
    );
  }
}
