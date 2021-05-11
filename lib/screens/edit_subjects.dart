import 'package:flutter/material.dart';
import 'package:pec_student/constants.dart';

class EditSubjects extends StatefulWidget {
  static String id = 'edit_subjects';
  const EditSubjects({Key key}) : super(key: key);

  @override
  _EditSubjectsState createState() => _EditSubjectsState();
}

class _EditSubjectsState extends State<EditSubjects> {
  int action = 1;
  Widget actionWidget = Text('Subject Add Action');

  void createActionWidget() {
    if (action == 1) {
      setState(() {
        actionWidget = Column(
          children: [],
        );
      });
    } else {
      setState(() {
        actionWidget = Text('Subject Delete Action');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text('Edit Subject List'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Radio(
                        value: 1,
                        groupValue: action,
                        onChanged: (value) {
                          setState(() {
                            action = value;

                            createActionWidget();
                          });
                        }),
                    Text('Add Subject'),
                  ],
                ),
                Row(
                  children: [
                    Radio(
                        value: 2,
                        groupValue: action,
                        onChanged: (value) {
                          setState(() {
                            action = value;
                            createActionWidget();
                          });
                        }),
                    Text('Delete Subject'),
                  ],
                ),
              ],
            ),
          ),
          actionWidget,
        ],
      ),
    );
  }
}
