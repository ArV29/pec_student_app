import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pec_student/constants.dart';
import 'package:pec_student/services/networking.dart';
import 'package:pec_student/widgets.dart';

import 'homepage.dart';
import 'initialize.dart';

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({Key key}) : super(key: key);
  static String id = 'password_screen';
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  String email, password = '';
  bool hiddenPassword = true;
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
                  child: Container(
                    height: 64.0,
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: TextFormField(
                        obscureText: hiddenPassword,
                        onChanged: (value) {
                          password = value;
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
                          hintText: 'Enter your password',
                          hintStyle:
                              kNormalTextStyle.copyWith(color: kLightColor),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: kLightHighlightColor,
                          ),
                          suffix: GestureDetector(
                            onTap: () {
                              setState(() {
                                hiddenPassword = !hiddenPassword;
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
                    String result = await Networking()
                        .logIn(email: email, password: password);
                    if (result != 'ok') {
                      setState(() {
                        Fluttertoast.showToast(
                            msg: "Incorrect password",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: kLightColor,
                            textColor: kPrimaryColor,
                            fontSize: 16.0);
                        showSpinner = false;
                      });
                    } else {
                      setState(() {
                        showSpinner = false;
                      });
                      Navigator.pushNamedAndRemoveUntil(context, Homepage.id,
                          ModalRoute.withName(InitializeScreen.id));
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
