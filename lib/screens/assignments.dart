import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/edit_assignments.dart';
import 'package:pec_student/services/networking.dart';
import 'package:pec_student/widgets.dart';

class Assignments extends StatefulWidget {
  static String id = 'assignments';
  const Assignments({Key key}) : super(key: key);

  @override
  _AssignmentsState createState() => _AssignmentsState();
}

class _AssignmentsState extends State<Assignments> {
  Map assignments = {};
  bool isAdmin = false;
  List<Widget> assignmentCards = [Text('Loading...')];
  void buildAssignmentCards() {
    List<Widget> cards = [];
    int currentDateTime = DateTime.now().millisecondsSinceEpoch;
    List assignmentTimes = assignments.keys.toList();
    assignmentTimes.sort();
    if (assignments.length == 0 || assignmentTimes.last < currentDateTime) {
      setState(() {
        assignmentCards = [
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
              'No upcoming assignments',
              style: kHeadingTextStyle2.copyWith(
                  fontSize: 25, color: kDarkHighlightColor),
            ),
          ),
        ];
      });
      return;
    }
    for (int time in assignmentTimes) {
      cards.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: AssignmentCard(
          assignmentDetails: assignments[time],
          assignmentTime: time,
        ),
      ));
    }
    setState(() {
      assignmentCards = cards;
    });
  }

  void getData() async {
    assignments = await Networking().getAssignments();
    buildAssignmentCards();
    Map userData = await Networking().getUserInfo();

    setState(() {
      isAdmin = userData['isAdmin'];
    });
  }

  @override
  void initState() {
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
          'Assignments',
          style:
              kHeadingTextStyle1.copyWith(color: kSecondaryColor, fontSize: 30),
        ),
        actions: [
          (isAdmin)
              ? Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: RoundIconButton(
                    icon: Icons.edit,
                    onPress: () {
                      Navigator.pushNamed(
                        context,
                        EditAssignments.id,
                      );
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
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: assignmentCards,
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
            BottomBar(
              index: 2,
            ),
          ],
        ),
      ),
    );
  }
}
