import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/homepage.dart';
import 'package:pec_student/services/networking.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../widgets.dart';
import 'initialize.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key key}) : super(key: key);
  static String id = 'new_user_screen';
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  String name = '', pwd = '', confirmPwd = '', branch = 'CSE', email;
  int year = 1;
  bool hidePwd = true, hideConfirmPwd = true;
  List<String> branches = [
    'CSE',
    'ECE',
    'ELE',
    'Civil',
    'Mech',
    'Prod',
    'Aero',
    'Meta'
  ];
  List<DropdownMenuItem> branchItems = [];
  List<DropdownMenuItem> yearItems = [];
  void populateLists() {
    for (String branch in branches) {
      branchItems.add(
        DropdownMenuItem(
          child: Text(
            branch,
            style: kNormalTextStyle,
          ),
          value: branch,
        ),
      );
    }
    for (int i = 1; i <= 4; i++) {
      yearItems.add(
        DropdownMenuItem(
          child: Text(
            i.toString(),
            style: kNormalTextStyle,
          ),
          value: i,
        ),
      );
    }
  }

  String nameErrorText = '', pwdErrorText = '';
  bool showSpinner = false;

  @override
  void initState() {
    populateLists();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    email = args['email'];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: ListView(
          children: [
            SizedBox(
              height: 120.0,
            ),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  FluttermojiCircleAvatar(
                    backgroundColor: kLightColor,
                  ),
                  RoundIconButton(
                    icon: Icons.edit,
                    onPress: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => AvatarEditor()));
                    },
                    backgroundColor: kYellowAccentColor,
                    foregroundColor: kRedAccentColor,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 32.0,
            ),
            Container(
              height: 64.0,
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: TextFormField(
                  onChanged: (value) {
                    name = value;
                  },
                  style: kNormalTextStyle.copyWith(
                      color: kLightHighlightColor, fontSize: 15),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Enter your name',
                      hintStyle: kNormalTextStyle.copyWith(color: kLightColor),
                      prefixIcon: Icon(
                        Icons.person,
                        color: kLightHighlightColor,
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              height: 64.0,
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                  child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                    child: Icon(Icons.email),
                  ),
                  Container(
                    child: Text(
                      email,
                      style: kNormalTextStyle.copyWith(
                          color: kLightHighlightColor, fontSize: 15),
                    ),
                  ),
                ],
              )),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              height: 64.0,
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: TextFormField(
                  obscureText: hidePwd,
                  onChanged: (value) {
                    pwd = value;
                  },
                  style: kNormalTextStyle.copyWith(color: kLightHighlightColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Enter your password',
                    hintStyle: kNormalTextStyle.copyWith(color: kLightColor),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: kLightHighlightColor,
                    ),
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          hidePwd = !hidePwd;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Container(
              height: 64.0,
              decoration: BoxDecoration(
                color: kSecondaryColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Center(
                child: TextFormField(
                  obscureText: hideConfirmPwd,
                  onChanged: (value) {
                    confirmPwd = value;
                  },
                  style: kNormalTextStyle.copyWith(color: kLightHighlightColor),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Confirm password',
                    hintStyle: kNormalTextStyle.copyWith(color: kLightColor),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: kLightHighlightColor,
                    ),
                    suffix: GestureDetector(
                      onTap: () {
                        setState(() {
                          hideConfirmPwd = !hideConfirmPwd;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Icon(Icons.remove_red_eye),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 16.0,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 64.0,
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: DropdownButton(
                          items: branchItems,
                          value: branch,
                          onChanged: (value) {
                            setState(() {
                              branch = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Container(
                    height: 64.0,
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: DropdownButton(
                          items: yearItems,
                          value: year,
                          onChanged: (value) {
                            setState(() {
                              year = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 32.0,
            ),
            RoundIconButton(
              icon: Icons.arrow_forward_ios,
              onPress: () {
                if (name == '') {
                  Fluttertoast.showToast(
                      msg: "Name can't be empty",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: kLightColor,
                      textColor: kPrimaryColor,
                      fontSize: 16.0);
                  return;
                } else if (pwd.length < 8) {
                  Fluttertoast.showToast(
                      msg: "Password should contain minimum 8 character",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: kLightColor,
                      textColor: kPrimaryColor,
                      fontSize: 16.0);
                  return;
                } else if (pwd != confirmPwd) {
                  Fluttertoast.showToast(
                      msg: "Passwords don't match",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: kLightColor,
                      textColor: kPrimaryColor,
                      fontSize: 16.0);
                }
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Confirm Account Creation?',
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
                                  'Confirm',
                                  style: kNormalTextStyle.copyWith(
                                    color: kGreenAccentColor,
                                  ),
                                ),
                              ),
                              color: kLightHighlightColor,
                              onPressed: () {
                                Networking()
                                    .signUp(email: email, password: pwd);
                                Networking().addUser(
                                    name: name,
                                    email: email,
                                    year: year,
                                    branch: branch);
                                Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Homepage.id,
                                    ModalRoute.withName(InitializeScreen.id));
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
              backgroundColor: kYellowAccentColor,
              foregroundColor: kRedAccentColor,
              radius: 50.0,
            )
          ],
        ),
      ),
    );
  }
}

class AvatarEditor extends StatelessWidget {
  const AvatarEditor({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightColor,
        title: Text('Customize your Avatar'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: FluttermojiCircleAvatar(
              radius: 100,
              backgroundColor: kLightColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
            child: FluttermojiCustomizer(),
          ),
        ],
      ),
    );
  }
}
