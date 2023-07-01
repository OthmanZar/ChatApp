import 'package:chatapp/screens/ChatSettings.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'HomeScreen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

String? profil;
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User curentUser;
String? img;
String? fullName;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String? text;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getData();
  }

  void getUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        curentUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  /* void messageStream() async {
    await for (var snapshots in _firestore.collection('messages').snapshots()) {
      for (var message in snapshots.docs) {
        print(message.data());
      }
    }
  }
*/

  void getData() async {
    final DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('UsersData')
        .doc(curentUser.uid)
        .get();
    img = userDoc.get('Image');
    fullName = userDoc.get('First_Name') + ' ' + userDoc.get('Last_Name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: choosed,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                pic!,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Text(
                titleTo!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueAccent.shade400,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/ChatSettings');
                // _auth.signOut();
                // Navigator.pop(context);
                // messageStream();
              },
              icon: Icon(
                Icons.settings,
                size: 30,
                //color: Colors.greenAccent.shade400,
              )),
        ],
      ),
      body: SafeArea(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              MessageStream(),
              Container(
                  decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: Colors.blue, width: 2)),
                  ),
                  // height: double.infinity,

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: messageText,
                          onChanged: (value) {
                            text = value;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Your Message here ...',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 20),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            messageText.clear();
                            _firestore.collection('$namefinal Messages').add({
                              'sender': fullName,
                              'text': text,
                              'time': FieldValue.serverTimestamp(),
                              'Image': img,
                            });
                          },
                          child: Icon(Icons.send))
                    ],
                  )),
            ]),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('$namefinal Messages')
          .orderBy('time')
          .snapshots(),
      builder: (context, snapshot) {
        List<MessagesList> messageWidget = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final usernow = fullName;
          final image = message.get('Image');
          final messagedata = MessagesList(
            text: messageText,
            sender: messageSender,
            isme: usernow == messageSender,
            imag: image,
          );
          messageWidget.add(messagedata);
          profil = image;
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            children: messageWidget,
          ),
        );
      },
    );
  }
}

class MessagesList extends StatelessWidget {
  const MessagesList(
      {this.text, this.sender, required this.isme, Key? key, this.imag})
      : super(key: key);
  final String? imag;
  final String? text;
  final String? sender;
  final bool isme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          Material(
              elevation: 10,
              borderRadius: isme
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30))
                  : BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30)),
              color: isme ? Colors.white60 : Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      backgroundImage: imag != null
                          ? NetworkImage(imag!)
                          : AssetImage('images/profile.png') as ImageProvider,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        '$text',
                        style: TextStyle(
                            color: isme ? Colors.black87 : Colors.black54,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
