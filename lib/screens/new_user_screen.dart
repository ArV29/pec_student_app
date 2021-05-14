import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/homepage.dart';
import 'package:pec_student/services/networking.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({Key key}) : super(key: key);
  static String id = 'new_user_screen';
  @override
  _NewUserScreenState createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  String name = '', pwd = '', branch = 'CSE', email;
  int year = 1;
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
  String nameErrorText = '', pwdErrorText = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    email = args['email'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text('New User Signup'),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          children: [
            SizedBox(
              height: 104.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'assets/images/logo.png',
                    ),
                  ),
                ),
                SizedBox(
                  height: 64.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: TextField(
                    onChanged: (value) {
                      name = value;
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter your Name',
                      errorText: nameErrorText,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kElevatedBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: TextField(
                    onChanged: (value) {
                      pwd = value;
                    },
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Set a password',
                      errorText: pwdErrorText,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kElevatedBackgroundColor,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 32.0, right: 16.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: kElevatedBackgroundColor),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              height: 78.0,
                              child: CupertinoTheme(
                                data: CupertinoThemeData(),
                                child: CupertinoPicker(
                                  useMagnifier: true,
                                  magnification: 1.2,
                                  itemExtent: 32.0,
                                  onSelectedItemChanged: (index) {
                                    year = index + 1;
                                  },
                                  children: [
                                    Text('1'),
                                    Text('2'),
                                    Text('3'),
                                    Text('4')
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text('Year'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 32.0, left: 16.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: kElevatedBackgroundColor),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                              height: 78.0,
                              child: CupertinoTheme(
                                data: CupertinoThemeData(),
                                child: CupertinoPicker(
                                  useMagnifier: true,
                                  magnification: 1.2,
                                  itemExtent: 32.0,
                                  onSelectedItemChanged: (index) {
                                    branch = branches[index];
                                  },
                                  children: [
                                    Text('CSE'),
                                    Text('ECE'),
                                    Text('ELE'),
                                    Text('Civil'),
                                    Text('Mech'),
                                    Text('Prod'),
                                    Text('Aero')
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text('Branch'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 48.0,
                ),
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    bool error = false;
                    if (pwd.length < 8) {
                      setState(() {
                        pwdErrorText = 'Password should be 8 characters long';
                      });

                      error = true;
                    }
                    if (name == '') {
                      setState(() {
                        nameErrorText = 'Name can\'t be empty';
                      });
                      error = true;
                    }
                    if (error) {
                      setState(() {
                        showSpinner = false;
                      });
                      return;
                    }
                    print('Name : $name');
                    print('Email: $email');
                    print('Year: $year');
                    print('Branch: $branch');

                    await Networking().signUp(email: email, password: pwd);
                    await Networking().addUser(
                        name: name,
                        email: email,
                        year: year,
                        branch: branch.toLowerCase());
                    setState(() {
                      showSpinner = false;
                    });
                    Navigator.pushNamed(context, Homepage.id);
                  },
                  child: Icon(Icons.arrow_forward_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
