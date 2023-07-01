import 'package:flutter/material.dart';

import '../widgets/Button.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  void toregister() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 240, 236),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 180,
                  child: Image.asset('images/chat.png'),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Chat With us',
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                        color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Button(
              color: Colors.greenAccent.shade200,
              title: 'Sign in',
              onTape: () {
                Navigator.pushNamed(context, '/Register');
              },
            ),
            SizedBox(
              height: 20,
            ),
            Button(
              color: Colors.blueAccent.shade400,
              title: 'log in',
              onTape: () {
                Navigator.pushNamed(context, '/Login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
