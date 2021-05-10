import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/services/networking.dart';

import 'homepage.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key key}) : super(key: key);
  static String id = 'password_screen';
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  String email, errorText = '', password = '';
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    email = args['email'];
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(
          children: [
            SizedBox(
              height: 144.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 128.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      errorText: errorText,
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
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    String result = await Networking()
                        .logIn(email: email, password: password);
                    if (result != 'ok') {
                      setState(() {
                        errorText = result;
                        showSpinner = false;
                      });
                    } else {
                      setState(() {
                        showSpinner = false;
                      });
                      Navigator.pushNamed(context, Homepage.id);
                    }
                  },
                  child: Icon(Icons.arrow_forward_rounded),
                ),
                SizedBox(
                  height: 64.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
