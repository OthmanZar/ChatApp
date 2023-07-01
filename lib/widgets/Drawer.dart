import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'Button.dart';

var firstn;
final _auth = FirebaseAuth.instance;
late User curentUser;
final _firestore = FirebaseFirestore.instance;
var firebaseUser = _auth.currentUser;

class TextName extends StatefulWidget {
  const TextName({
    Key? key,
  }) : super(key: key);

  @override
  State<TextName> createState() => _TextNameState();
}

class _TextNameState extends State<TextName> {
  File? imaage;
  String? ima;
  bool syn = false;
  void getImagefromCamera() async {
    setState(() {
      syn = true;
    });
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() async {
        imaage = imageTemporary;
        final ref = FirebaseStorage.instance
            .ref()
            .child('usersimages')
            .child('$firstn.jpg');
        UploadTask uploadTask = ref.putFile(imaage!);
        await ref.putFile(imaage!);
        ima = await ref.getDownloadURL();
        _firestore
            .collection("UsersData")
            .doc("${firebaseUser?.uid}")
            .update({'Image': ima});
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        syn = false;
      });
    }

    Navigator.pop(context);
  }

  void getImagefromGall() async {
    setState(() {
      syn = true;
    });
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() async {
        imaage = imageTemporary;
        final ref = FirebaseStorage.instance
            .ref()
            .child('usersimages')
            .child('$firstn.jpg');
        UploadTask uploadTask = ref.putFile(imaage!);
        await ref.putFile(imaage!);
        ima = await ref.getDownloadURL();
        _firestore
            .collection("UsersData")
            .doc("${firebaseUser?.uid}")
            .update({'Image': ima});
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        syn = false;
      });
    }

    Navigator.pop(context);
  }

  void remove() {
    setState(() {
      syn = true;
    });
    setState(() {
      imaage = null;
    });
    setState(() {
      syn = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var UserUid;
    var Name;
    var imag;
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('UsersData').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blue,
              ),
            );
          }
          final messages = snapshot.data!.docs;
          for (var message in messages) {
            // var firebaseUser = _auth.currentUser;
            UserUid = message.get('uid');

            // final img = message.get('Image');
            if (UserUid == firebaseUser?.uid) {
              Name = '${message.get('First_Name')} ${message.get('Last_Name')}';
              imag = message.get('Image');
              firstn = '${message.get('First_Name')}';
              // print(Name);
            }
          }
          return ListTile(
            leading: ModalProgressHUD(
              inAsyncCall: syn,
              child: CircleAvatar(
                backgroundImage: imag != null
                    ? NetworkImage(imag)
                    : AssetImage('images/profile.png') as ImageProvider,
                radius: 25,
              ),
            ),
            title: Text(
              Name,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black87),
            ),
          );
        });
  }
}

class Drawers extends StatefulWidget {
  const Drawers({Key? key}) : super(key: key);

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  File? image;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this.image = imageTemporary;
      });
    } on Exception catch (e) {
      print('Faield to pick image: $e');
    }
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

  String getId() {
    final String id;
    id = curentUser.uid;

    return id;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blueGrey.shade100,
      elevation: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 30),
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade200,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50)),
                ),
                child: SafeArea(
                  child: TextName(),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/Profile');
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  elevation: 10,
                  child: ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Profile'),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/MyGroups');
                },
                child: Card(
                  margin: EdgeInsets.all(8),
                  elevation: 10,
                  child: ListTile(
                    leading: Icon(Icons.chat),
                    title: Text('Your Groups'),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Are You Sure ?'),
                          scrollable: true,
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              child: Column(
                                children: <Widget>[
                                  Center(
                                    child: Button(
                                        color:
                                            Color.fromARGB(255, 104, 172, 124),
                                        title: 'Yes',
                                        onTape: () async {
                                          await FirebaseAuth.instance.signOut();
                                          Navigator.pushNamedAndRemoveUntil(
                                              context, '/', (route) => false);
                                        }),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Button(
                                        color:
                                            Color.fromARGB(255, 233, 154, 148),
                                        title: 'No',
                                        onTape: () async {
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
                  margin: EdgeInsets.all(8),
                  elevation: 10,
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log out'),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/AboutUs');
            },
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info),
                  Text(
                    'About Us',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
                  )
                ]),
          )
        ],
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
