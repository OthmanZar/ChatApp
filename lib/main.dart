import 'package:chatapp/screens/ChatScreen.dart';
import 'package:chatapp/screens/ChatSettings.dart';
import 'package:chatapp/screens/HomeScreen.dart';
import 'package:chatapp/screens/LoginScreen.dart';
import 'package:chatapp/screens/Profile.dart';
import 'package:chatapp/screens/Register.dart';
import 'package:chatapp/screens/Welcome.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'screens/AboutUs.dart';
import 'screens/MyGroups.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: _auth.currentUser != null ? '/Home' : '/',
      routes: {
        '/': (context) => Welcome(),
        '/Register': (context) => Register(),
        '/Login': (context) => LogIn(),
        '/Chat': (context) => ChatScreen(),
        '/Home': (context) => HomeScreen(),
        '/Profile': (context) => Profile(),
        '/ChatSettings': (context) => ChatSettings(),
        '/MyGroups': (context) => MyGroups(),
        '/AboutUs': (context) => AboutUs(),
      },
    );
  }
}
