import 'package:flutter/material.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/services/networking.dart';

class EditTimeTable extends StatefulWidget {
  static String id = 'edit_time_table';
  const EditTimeTable({Key key}) : super(key: key);

  @override
  _EditTimeTableState createState() => _EditTimeTableState();
}

class _EditTimeTableState extends State<EditTimeTable> {
  var subjects = Networking().getSubjects();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text('Edit Time Table'),
        centerTitle: true,
      ),
      backgroundColor: kBackgroundColor,
      body: ListView(),
    );
  }
}
