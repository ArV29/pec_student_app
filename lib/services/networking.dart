import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class Networking {
  Future<bool> userExists({@required String email}) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    var user = await users.doc(email).get();

    return user.exists;
  }

  Future<void> addUser(
      {@required name,
      @required email,
      @required year,
      @required branch}) async {
    await Firebase.initializeApp();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(email).set(
      {'name': name, 'year': year, 'branch': branch},
    );
    print('User added in database');
  }

  Future<void> signUp({@required email, @required password}) async {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Successful SignUp and LogIn ');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<String> logIn({@required email, @required password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return ('ok');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        return ('Incorrect Password');
      }
    } catch (e) {
      return e;
    }
    return 'try again';
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<Map> getUserInfo() async {
    String user = FirebaseAuth.instance.currentUser.email;
    print('User: $user');
    DocumentSnapshot receivedData =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    print('Received Data: $receivedData');
    Map<String, dynamic> convertedData = receivedData.data();
    return convertedData;
  }

  Future<Map> getTimeTable() async {
    Map info = await getUserInfo();
    print('Info : $info');

    print('Weekday');
    CollectionReference timetables =
        FirebaseFirestore.instance.collection('timetable');
    String key = (info['branch'] + info['year'].toString());

    var timetable = await timetables.doc(key).get();
    print('TimeTable: $timetable ');
    return timetable.data();
  }
}
