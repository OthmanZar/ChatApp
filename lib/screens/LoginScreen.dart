import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:animated_login/animated_login.dart';

import '../widgets/Button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

bool syc = false;
final _formkey = GlobalKey<FormState>();
// final _formkey2 = GlobalKey<FormState>();
String? err;

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  static late bool _set;
  late String email;
  late String password;

  final _auth = FirebaseAuth.instance;
  static Future<String?> mailSignIn(
      String mail, String pwd, context, sc) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail, password: pwd);
      _set = true;
      return null;
    } on FirebaseAuthException catch (ex) {
      sc = false;
      _set = false;
      return err = "${ex.code}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                child: Image.asset('images/chat.png'),
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                validator: (value) {
                  if (value!.isNotEmpty) {
                    mailSignIn(email, password, context, syc);

                    if (err != "wrong-password" && err != "too-many-requests") {
                      return err;
                    }

                    return null;
                  } else {
                    return 'Please Enter Your Email';
                  }
                },
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter Your Email',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2)),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2)),
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                validator: (value) {
                  if (value!.isNotEmpty) {
                    if (_set == true) {
                      setState(() {
                        syc = true;
                        Navigator.popAndPushNamed(
                          context,
                          ('/Home'),
                        );
                      });
                    }
                    if (err == "wrong-password") {
                      return err;
                    }
                    return null;
                  } else {
                    return 'Please Enter Your Password';
                  }
                },
                obscureText: true,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Enter Your Password',
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green, width: 1)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2)),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2)),
                ),
              ),
              SizedBox(height: 20),
              Button(
                  color: Colors.blueAccent.shade400,
                  title: 'Log in',
                  onTape: () async {
                    // if (!_formkey2.currentState!.validate()) {
                    //   return;
                    // }
                    setState(() {
                      if (!_formkey.currentState!.validate()) {
                        return;
                      }
                    });

                    // mailSignIn(email, password, context, syc);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
