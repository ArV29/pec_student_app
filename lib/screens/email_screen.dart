import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/screens/new_user_screen.dart';
import 'package:pec_student/screens/password_screen.dart';
import 'package:pec_student/services/networking.dart';
import 'package:pec_student/widgets.dart';

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
                  child: Container(
                    height: 64.0,
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: TextFormField(
                        onChanged: (value) {
                          email = value;
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
                            hintText: 'Enter your official PEC email-id!',
                            hintStyle:
                                kNormalTextStyle.copyWith(color: kLightColor),
                            prefixIcon: Icon(
                              Icons.person,
                              color: kLightHighlightColor,
                            )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 32.0,
                ),
                RoundIconButton(
                  icon: Icons.arrow_forward_ios,
                  onPress: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    if (email != '' &&
                        EmailValidator.validate(email) &&
                        email.split('@')[1] == 'pec.edu.in') {
                      if (await Networking().userExists(email: email)) {
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
                      Fluttertoast.showToast(
                          msg: "Invalid Email Address!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: kLightColor,
                          textColor: kPrimaryColor,
                          fontSize: 16.0);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  },
                  backgroundColor: kYellowAccentColor,
                  foregroundColor: kRedAccentColor,
                  radius: 50.0,
                ),
                // MaterialButton(

                //   child: Icon(Icons.arrow_forward_rounded),
                // ),
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
