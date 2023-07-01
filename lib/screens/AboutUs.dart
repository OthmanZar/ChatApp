import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri url = Uri.parse('https://www.instagram.com/othman_zarouk/');

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("images/chat.png"),
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Chat With Us",
                  style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                      color: Colors.blue[400]),
                )
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Card(
              shadowColor: Colors.blueGrey,
              elevation: 10,
              color: Colors.blueGrey[100],
              margin: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                    "This Application is developped by Othman Zarrouk . Using the Framework Flutter with the language Dart . The Purpose of this application is only to apply my competences that i learn in 3 or 4 weeks From Youtube . I Hope you Like the application if you have any issue or an idea please contact me on my instagram Bellow "),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              shadowColor: Colors.blueGrey,
              elevation: 10,
              color: Colors.blueGrey[100],
              margin: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                    "You can use this application to communicate with your friends or familly or laybe you can use it to talk about a project or something like that . you can create a group and share the password only with the friends you want to join the group. "),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              // ignore: deprecated_member_use
              onTap: () async {
                if (!await launchUrl(url)) {
                  throw 'Could not launch $url';
                }
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                    leading: FaIcon(
                      FontAwesomeIcons.instagram,
                      color: Color.fromARGB(255, 218, 104, 75),
                      size: 35,
                    ),
                    title: Text(
                      '@othman_zarouk',
                      style: TextStyle(
                        color: Color.fromARGB(255, 187, 37, 0),
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
              ),
            )
          ]),
        ));
  }
}
