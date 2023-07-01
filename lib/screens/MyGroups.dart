import 'package:chatapp/screens/HomeScreen.dart';
import 'package:chatapp/widgets/Button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../widgets/Drawer.dart';

String? _Id;
String? _titleT;
late User curentUser;
final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;

class MyGroups extends StatefulWidget {
  const MyGroups({super.key});

  @override
  State<MyGroups> createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyGroups> {
  void initState() {
    // TODO: implement initState
    super.initState();
    _getUser();
  }

  void _getUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        curentUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.chat_rounded,
              size: 23,
            ),
            SizedBox(
              width: 12,
            ),
            Text('My Groups'),
          ],
        ),
        elevation: 11,
      ),
      body: SafeArea(child: _MessageStream()),
    );
  }
}

class _MessageStream extends StatelessWidget {
  const _MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('Groups').snapshots(),
      builder: (context, snapshot) {
        List<_MessagesList> messageWidget = [];
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
          var test = message.get('owner');
          if (test == curentUser.email) {
            final messageText = message.get('title');
            final messageSender = message.get('type');
            final numbr = message.get('Numbre');
            final state = message.get('state');
            final pass = message.get('key');
            final mail = message.get('owner');
            final documentID = message.id;
            final imag = message.get('Image');
            final nameF = message.get('name');

            final messagedata = _MessagesList(
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
            );
            //
            messageWidget.add(messagedata);
            //

          }
          if (messageWidget.isEmpty) {
            return Center(
                child: Text(
              "You Don't Have any Group, Go and Create one .",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
              textAlign: TextAlign.center,
            ));
          }

          i++;
        }
        return ListView(
          //reverse: true,

          children: messageWidget,
        );
      },
    );
  }
}

class _MessagesList extends StatefulWidget {
  const _MessagesList(
      {this.text,
      this.sender,
      Key? key,
      this.num,
      this.sta,
      this.password,
      this.email,
      this.docId,
      this.image,
      this.members,
      this.finaname})
      : super(key: key);

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

  @override
  State<_MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<_MessagesList> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _titleT = widget.finaname;
        _Id = widget.docId;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                scrollable: true,
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Center(
                          child: Button(
                              color: Color.fromARGB(255, 211, 153, 86),
                              title: 'Clear All Chat',
                              onTape: () async {
                                print(_Id);
                                var collection = FirebaseFirestore.instance
                                    .collection('${widget.finaname} Messages');
                                var snapshots = await collection.get();
                                for (var doc in snapshots.docs) {
                                  await doc.reference.delete();
                                }
                                Navigator.pop(context);
                              }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Button(
                              color: Color.fromARGB(255, 233, 154, 148),
                              title: 'Remove Group',
                              onTape: () async {
                                var collection2 = FirebaseFirestore.instance
                                    .collection('Groups');
                                var snapshots2 =
                                    await collection2.doc(_Id).delete();
                                Navigator.pop(context);
                              }),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
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
                  height: 250,
                  alignment: Alignment.bottomRight,
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
                      Text(
                        '${widget.sender}',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                            letterSpacing: 1.2),
                      )
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
