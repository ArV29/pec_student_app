import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttermoji/fluttermoji.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/homepage.dart';
import 'package:pec_student/screens/initialize.dart';
import 'package:pec_student/services/networking.dart';

import '../widgets.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);
  static String id = 'settings';
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  Widget mainBody = Text('Loading...');
  bool isAdmin;
  void getInfo() async {
    Map info = await Networking().getUserInfo();
    email = FirebaseAuth.instance.currentUser.email;
    name = info['name'];
    branch = info['branch'];
    year = info['year'];
    isAdmin = info['isAdmin'];
    print('here');
    setState(() {});
  }

  String name, branch, email;
  int year;
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
          value: branch.toLowerCase(),
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

  bool showSpinner = false;

  @override
  void initState() {
    populateLists();
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    // Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    // email = args['email'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kLightColor,
        title: Text(
          'Edit Profile',
          style:
              kHeadingTextStyle1.copyWith(color: kSecondaryColor, fontSize: 36),
        ),
        centerTitle: true,
      ),
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
                  initialValue: name,
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
              onPress: () async {
                await Networking().updateUser(
                    name: name,
                    email: email,
                    year: year,
                    branch: branch,
                    isAdmin: isAdmin);
                Navigator.pushNamedAndRemoveUntil(context, Homepage.id,
                    ModalRoute.withName(InitializeScreen.id));
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
