import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/new_user_screen.dart';
import 'package:pec_student/screens/password_screen.dart';
import 'package:pec_student/services/networking.dart';

class EmailScreen extends StatefulWidget {
  static String id = 'emailScreen';
  const EmailScreen({Key key}) : super(key: key);

  @override
  _EmailScreenState createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  String email = '';
  Widget result = Text('Result');
  bool validEmail = false;
  String errorText = '';
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
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
                      email = value;
                    },
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'Enter your official PEC email ID',
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
                    if (EmailValidator.validate(email)) {
                      print('Valid Email');

                      setState(() {
                        errorText = '';
                      });
                      if (await Networking().userExists(email: email) ||
                          email == '') {
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pushNamed(
                          context,
                          PasswordScreen.id,
                          arguments: {'email': email},
                        );
                      } else {
                        setState(() {
                          showSpinner = false;
                        });
                        Navigator.pushNamed(
                          context,
                          NewUserScreen.id,
                          arguments: {'email': email},
                        );
                      }
                    } else {
                      setState(() {
                        errorText = 'Please enter a valid email address';
                      });
                      setState(() {
                        showSpinner = false;
                      });
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
