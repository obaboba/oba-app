import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:io' show Platform;

import 'models/user.dart';
import 'libs/auth.dart';
import 'libs/globals.dart' as G;

import 'screens/home_page.dart';
import 'screens/login_page.dart';
import 'screens/loading_page.dart';



Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized(); // after upgrading flutter this is now necessary

  // enable timestamps in firebase
  Firestore.instance.settings().then((_) {
    print('[Main] Firestore timestamps in snapshots set');},
      onError: (_) => print('[Main] Error setting timestamps in snapshots')
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.black,
            primaryIconTheme: IconThemeData(color: Colors.black),
            primaryTextTheme: TextTheme(
                title: TextStyle(color: Colors.black, fontFamily: "Aveny")),
            textTheme: TextTheme(title: TextStyle(color: Colors.black))),
        home: Wrapper(),
        routes: {
          "/home":(context) => null,
          "/search":(context) => null,
          "/add":(context) => null,
          "/fav":(context) => null,
          "/profile":(context) => null,
          "/intro":(context) => HomePage(),
        },
      ),

    );
  }
}

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null){
      return LoginPage(); //login page
    } else {
      //return SelectGame();
      return EnhancedFutureBuilder(
          future: postLoginSetup(user),
          rememberFutureResult: true,
          whenDone: (dynamic val) {return HomePage();},
          whenNotDone: ColorLoader3( radius: 15.0, dotRadius:3.0));//home page
    }

  }
}

Future<void> postLoginSetup(User user) async {
  print("entering postLoginSetup");
  await tryCreateUserRecord(user);
  await _setUpNotifications(user);
  print("exiting postLoginSetup");
}

final auth = FirebaseAuth.instance;
final ref = Firestore.instance.collection('insta_users');
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();


Future<void> tryCreateUserRecord(User user) async {
  if (user == null) {
    return null;
  }
  DocumentSnapshot userRecord = await ref.document(user.id).get();
  if (userRecord.data == null) {
    // no user record exists, time to create

    if (user.displayName != null ) {
      ref.document(user.id).setData({
        "id": user.id,
        "username": user.displayName,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": "",
        "followers": {},
        "following": {},
      });
    }
    userRecord = await ref.document(user.id).get();
  }

  G.currentUserModel = User.fromDocument(userRecord);
  print(G.currentUserModel.id);
  return null;
}

Future<Null> _setUpNotifications(User user) async {
  if (Platform.isAndroid) {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    _firebaseMessaging.getToken().then((token) {
      print("Firebase Messaging Token: " + token);

      Firestore.instance
          .collection("insta_users")
          .document(user.id)
          .updateData({"androidNotificationToken": token});
    });
  }
}

