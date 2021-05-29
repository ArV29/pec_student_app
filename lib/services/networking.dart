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

  Future<void> sendPasswordResetEmail({@required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
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
  }

  Future<void> updateUser(
      {@required name,
      @required email,
      @required year,
      @required branch,
      @required isAdmin}) async {
    await Firebase.initializeApp();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(email).set(
      {'name': name, 'year': year, 'branch': branch, 'isAdmin': isAdmin},
    );
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

  Future<Map> getTimeTable({Map info}) async {
    info = await getUserInfo();
    String key =
        (info['branch'].toString().toLowerCase() + info['year'].toString());
    CollectionReference data = FirebaseFirestore.instance.collection(key);

    var timetable = await data.doc('timetable').get();
    if (timetable.exists) {
      if (timetable.data() == null || timetable.data().length == 0) {
        return {
          'monday': {},
          'tuesday': {},
          'wednesday': {},
          'thursday': {},
          'friday': {},
          'saturday': {},
          'sunday': {},
        };
      }
      return timetable.data();
    } else {
      return {
        'monday': {},
        'tuesday': {},
        'wednesday': {},
        'thursday': {},
        'friday': {},
        'saturday': {},
        'sunday': {},
      };
    }
  }

  void updateTimeTable({timetable}) async {
    Map<String, dynamic> convertedTT = new Map<String, dynamic>.from(timetable);
    Map info = await getUserInfo();
    String key =
        (info['branch'].toString().toLowerCase() + info['year'].toString());
    CollectionReference data = FirebaseFirestore.instance.collection(key);

    await data.doc('timetable').set(convertedTT);
  }

  Future<Map> getAssignments() async {
    Map info = await getUserInfo();
    String key =
        (info['branch'].toString().toLowerCase() + info['year'].toString());
    CollectionReference data = FirebaseFirestore.instance.collection(key);

    var assignments = await data.doc('assignments').get();
    if (assignments.exists) {
      Map convertedAssignments = {};
      for (String time in assignments.data().keys) {
        convertedAssignments[int.parse(time)] = assignments.data()[time];
      }
      return convertedAssignments;
    } else {
      return {};
    }
    // Map assignments = {
    //   1622226300000: {
    //     'name': 'Physics Practical',
    //     'groups': 'All',
    //   }
    // };
    // return assignments;
  }

  Future<void> updateAssignments({@required Map assignments}) async {
    Map info = await getUserInfo();
    String key =
        (info['branch'].toString().toLowerCase() + info['year'].toString());
    CollectionReference data = FirebaseFirestore.instance.collection(key);

    Map<String, Map> convertedAssignments = {};
    for (int time in assignments.keys) {
      convertedAssignments[time.toString()] = assignments[time];
    }

    await data.doc('assignments').set(convertedAssignments);
  }

  Future<Map> getAnnouncements() async {
    Map info = await getUserInfo();
    String key =
        (info['branch'].toString().toLowerCase() + info['year'].toString());
    CollectionReference data = FirebaseFirestore.instance.collection(key);

    var announcements = await data.doc('announcements').get();
    if (announcements.exists) {
      return announcements.data();
    } else {
      return {};
    }
  }

  void updateAnnouncements({@required Map announcements}) async {
    Map<String, dynamic> convertedAnnouncements =
        new Map<String, dynamic>.from(announcements);

    Map info = await getUserInfo();
    String key =
        (info['branch'].toString().toLowerCase() + info['year'].toString());
    CollectionReference data = FirebaseFirestore.instance.collection(key);

    await data.doc('announcements').set(convertedAnnouncements);
  }

  Future<Map> getNotes() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    var data = await users.doc(FirebaseAuth.instance.currentUser.email).get();
    Map convertedData = data.data();
    if (convertedData['notes'] != null) {
      return convertedData['notes'];
    } else {
      return {};
    }
  }

  void updateNotes({@required Map notes}) async {
    Map<String, dynamic> convertedNotes = new Map<String, dynamic>.from(notes);

    CollectionReference users = FirebaseFirestore.instance.collection('users');

    var data = await users.doc(FirebaseAuth.instance.currentUser.email).get();
    Map convertedData = data.data();
    convertedData['notes'] = convertedNotes;
    await users.doc(FirebaseAuth.instance.currentUser.email).set(convertedData);
  }
}
