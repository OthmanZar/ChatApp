import 'dart:io';
import 'package:chatapp/screens/ChatScreen.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:chatapp/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
// ignore: import_of_legacy_library_into_null_safe

import '../widgets/Drawer.dart';
import 'LoginScreen.dart';

final _formkey = GlobalKey<FormState>();
const List<String> list = <String>[
  'Friends',
  'Familly',
  'Work',
  'Fun',
  'Gaming',
  'Studying',
  'Business',
  'Other'
];

String? text;
int? numbreTO;
Color? choosed;
String? neddId;
int? colors;
String? img1;
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
final messageText = TextEditingController();
late User curentUser;
String? titleTo;
String? namefinal;
String? verif;
String? pic;

String? DocId;
int numbr = 1;

String? finalEmail = curentUser.email;

void getDat() async {
  final DocumentSnapshot userDoc = await FirebaseFirestore.instance
      .collection('UsersData')
      .doc(curentUser.uid)
      .get();
  img1 = userDoc.get('Image');
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? name;
  String? type;
  String? pass;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getDat();
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
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0))),
                  backgroundColor: Colors.white,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => Padding(
                        padding: EdgeInsets.only(
                            top: 20,
                            right: 20,
                            left: 20,
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Text(
                                  'New Group',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextField(
                                onChanged: (value) {
                                  name = value;
                                },
                                decoration:
                                    InputDecoration(hintText: 'Group Name'),
                                autofocus: true,
                              ),
                              SizedBox(height: 10),
                              DropdownButton<String>(
                                value: dropdownValue,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? value) {
                                  setState(() {
                                    type = value!;
                                  });
                                },
                                items: list.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 10),
                              TextField(
                                obscureText: true,
                                onChanged: (value) {
                                  pass = value;
                                },
                                decoration:
                                    InputDecoration(hintText: 'Password'),
                                autofocus: true,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SizedBox(height: 15),
                              Center(
                                child: FloatingActionButton(
                                    elevation: 11,
                                    backgroundColor: Colors.blueAccent,
                                    onPressed: () {
                                      var list = [curentUser.email];
                                      var listUID = [curentUser.uid];
                                      var waa = [img1];
                                      _firestore.collection('Groups').add({
                                        'Image':
                                            'https://images.unsplash.com/photo-1527525443983-6e60c75fff46?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=685&q=80',
                                        'type': type,
                                        'title': name,
                                        'name': name,
                                        'Numbre': numbr,
                                        'state': 'online',
                                        'key': pass,
                                        'owner': curentUser.email,
                                        'Members': FieldValue.arrayUnion(list),
                                        'MembersUID':
                                            FieldValue.arrayUnion(waa),
                                        'color': 4294638330,
                                      });

                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.add,
                                      size: 24.0,

                                      // <-- Text
                                    )),
                              ),
                              SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ));
            },
            icon: Icon(
              Icons.group_add,
              size: 40,
            ),
          )
        ],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/chat.png',
              height: 40,
            ),
          ],
        ),
      )),
      drawer: Drawers(),
      body: MessageStream(),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Groups').snapshots(),
      builder: (context, snapshot) {
        List<MessagesList> messageWidget = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blue,
            ),
          );
        }

        final messages = snapshot.data!.docs;
        int i = 0;
        for (var message in messages) {
          final messageText = message.get('title');
          final messageSender = message.get('type');
          final numbr = message.get('Numbre');
          final state = message.get('state');
          final pass = message.get('key');
          final mail = message.get('owner');
          final documentID = message.id;
          final imag = message.get('Image');
          final nameF = message.get('name');
          final cc = message.get('color');
          List membe = message.get('Members');

          final messagedata = MessagesList(
            text: messageText,
            sender: messageSender,
            num: numbr,
            sta: state,
            password: pass,
            email: mail,
            docId: documentID,
            image: imag,
            members: message.get('Members'),
            finaname: nameF,
            ColorC: cc,
          );

          //
          messageWidget.add(messagedata);
          //

          i++;
        }
        return ListView(
          children: messageWidget,
        );
      },
    );
  }
}

class MessagesList extends StatefulWidget {
  const MessagesList({
    this.text,
    this.sender,
    Key? key,
    this.num,
    this.sta,
    this.password,
    this.email,
    this.docId,
    this.image,
    this.members,
    this.finaname,
    this.ColorC,
  }) : super(key: key);

  final String? text;
  final String? sender;
  final int? num;
  final String? sta;
  final String? password;
  final String? email;
  final String? docId;
  final String? image;
  final List? members;
  final String? finaname;
  final int? ColorC;
  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          colors = widget.ColorC;
          choosed = Color(colors!);
        });
        setState(() {
          numbreTO = widget.num;
        });
        DocId = widget.docId;
        titleTo = widget.text;
        namefinal = widget.finaname;
        pic = widget.image;
        var list = [firebaseUser?.email];
        var listUID = [firebaseUser?.uid];
        var waa = [img1];
        if (widget.members!.contains(curentUser.email)) {
          Navigator.pushNamed(context, '/Chat');
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('access the group'),
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                if (verif == widget.password) {
                                  _firestore
                                      .collection("Groups")
                                      .doc(DocId)
                                      .update({
                                    'Members': FieldValue.arrayUnion(list),
                                    'MembersUID': FieldValue.arrayUnion(waa)
                                  });
                                  verif = '';

                                  _firestore
                                      .collection("Groups")
                                      .doc("${widget.docId}")
                                      .update({
                                    'Numbre': widget.members!.length + 1
                                  });

                                  print(curentUser.email);
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/Chat');
                                } else {
                                  return 'Password Incorrect';
                                }

                                return null;
                              } else {
                                return 'Please Enter The Password';
                              }
                            },
                            obscureText: true,
                            onChanged: (value) {
                              verif = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Password',
                              icon: Icon(Icons.password),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3,
                                    color: Color.fromARGB(255, 250, 20, 3)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          if (!_formkey.currentState!.validate()) {
                            return;
                          }
                        })
                  ],
                );
              });
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 7,
        margin: EdgeInsets.all(11),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.network(
                    widget.image!,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  transformAlignment: Alignment.center,
                  height: 250,
                  alignment: Alignment.bottomLeft,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: [
                      0.6,
                      1,
                    ],
                  )),
                  child: Text(
                    '${widget.text}',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                        letterSpacing: 1.2),
                    // textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.group, color: Colors.blue
                          // color: Theme.of(context).accentColor,
                          ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('${widget.num}')
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.circle,
                          color: (widget.sta == 'online' ||
                                  widget.members!.contains(curentUser.email))
                              ? Colors.green
                              : Colors.grey
                          // color: Theme.of(context).accentColor,
                          ),
                      SizedBox(
                        width: 5,
                      ),
                      widget.members!.contains(curentUser.email)
                          ? Text('online')
                          : Text('${widget.sta}')
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.family_restroom,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('${widget.sender}')
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
