import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Networking {
  Future<bool> userExists({@required String email}) async {
    try // Password should be really long to avoid actually logging in :)
    {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: 'ashdfjquiwhibvkbwquibfuqjkljghggjggwvqubv');
    } catch (error) {
      print(error.code);
      if (error.code == 'wrong-password') {
        return true;
      }

      if (error.code == 'user-not-found') {
        return false;
      }
    }
    return false;
  }

  Future<void> addUser(
      {@required name,
      @required email,
      @required year,
      @required branch}) async {
    await Firebase.initializeApp();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(email).set(
      {'name': name, 'year': year, 'branch': branch, 'isAdmin': false},
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
      print(e);
      return e;
    }
    return 'Something went wrong. Please try again later';
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<Map> getUserInfo() async {
    String user = FirebaseAuth.instance.currentUser.email;
    DocumentSnapshot receivedData =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    Map<String, dynamic> convertedData = receivedData.data();
    return convertedData;
  }

  Future<Map> getTimeTable() async {
    Map info = await getUserInfo();

    CollectionReference timetables =
        FirebaseFirestore.instance.collection('timetable');
    String key = (info['branch'] + info['year'].toString());

    var timetable = await timetables.doc(key).get();
    return timetable.data();
  }

  Future getSubjects() async {
    Map info = await getUserInfo();
    String key = (info['branch'] + info['year'].toString());

    var subjects =
        await FirebaseFirestore.instance.collection('subjects').doc(key).get();

    return subjects.data();
  }

  Future addSubject({@required subject}) async {}

  Future<bool> isAdmin() async {
    Map info = await getUserInfo();
    return (info['isAdmin']);
  }

  void updateTimeTable({@required weekday, @required Map timeTable}) async {
    Map info = await getUserInfo();

    CollectionReference timetables =
        FirebaseFirestore.instance.collection('timetable');
    String key = (info['branch'] + info['year'].toString());
    var tt = await timetables.doc(key).get();
    Map<String, dynamic> timetable = {};

    if (tt.exists) {
      timetable = tt.data();
    } else {}
    timetable[weekday] = timeTable;
    print(key);
    await timetables.doc(key).set(timetable);
    print('Time Table Update Successful');
  }
}
