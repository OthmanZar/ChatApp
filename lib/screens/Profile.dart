import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

var Name;
var phone;
late int Numbrphone;
late String Fullname;
late int phoneNbr;
late String Frstname;
late String Lsttname;
File? imaage;
String? ima;
bool syn = false;
final _auth = FirebaseAuth.instance;
late User curentUser;
final _firestore = FirebaseFirestore.instance;
var firebaseUser = _auth.currentUser;
bool key = false;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
            .child('${firebaseUser?.email}.jpg');
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
    try {
      setState(() {
        syn = true;
      });
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() async {
        imaage = imageTemporary;
        final ref = FirebaseStorage.instance
            .ref()
            .child('usersimages')
            .child('${firebaseUser?.email}.jpg');
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
      _firestore
          .collection("UsersData")
          .doc("${firebaseUser?.uid}")
          .update({'Image': null});
      syn = false;
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[80],
      appBar: AppBar(
          title: Text('              Profile',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Stack(children: [
                const Data(),
                Positioned(
                    top: 150,
                    left: 130,
                    right: 30,
                    bottom: 30,
                    child: RawMaterialButton(
                        elevation: 10,
                        fillColor: Colors.blue,
                        child: Icon(
                          Icons.mode_edit_outline_outlined,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Center(
                                  child: Text(
                                    'Choose option',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.cyan),
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: [
                                      InkWell(
                                        onTap: () => getImagefromCamera(),
                                        splashColor: Colors.blueAccent,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.camera,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            Text(
                                              'Camera',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => getImagefromGall(),
                                        splashColor: Colors.blueAccent,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.image,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                            Text(
                                              'Gallery',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black),
                                            )
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () => remove(),
                                        splashColor: Colors.redAccent,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.remove_circle,
                                                color: Colors.red,
                                              ),
                                            ),
                                            Text(
                                              'Remove',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }))
              ]),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    splashColor: Colors.blueGrey[150],
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25.0))),
                            backgroundColor: Colors.white,
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                                  padding: EdgeInsets.only(
                                      top: 20,
                                      right: 20,
                                      left: 20,
                                      bottom: MediaQuery.of(context)
                                          .viewInsets
                                          .bottom),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Text(
                                          'Change your name',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      TextField(
                                        onChanged: (value) {
                                          Frstname = value;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'First Name'),
                                        autofocus: true,
                                      ),
                                      SizedBox(height: 10),
                                      TextField(
                                        onChanged: (value) {
                                          Lsttname = value;
                                        },
                                        decoration: InputDecoration(
                                            hintText: 'Last Name'),
                                        autofocus: true,
                                      ),
                                      SizedBox(height: 15),
                                      Center(
                                        child: FloatingActionButton(
                                            elevation: 11,
                                            backgroundColor: Colors.blueAccent,
                                            onPressed: () {
                                              _firestore
                                                  .collection("UsersData")
                                                  .doc("${firebaseUser?.uid}")
                                                  .update({
                                                'First_Name': Frstname,
                                                'Last_Name': Lsttname
                                              });

                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              // <-- Icon
                                              Icons.done,
                                              size: 24.0,

                                              // <-- Text
                                            )),
                                      ),
                                      SizedBox(height: 15),
                                    ],
                                  ),
                                ));
                      },
                      child: Card(
                        color: Colors.blueGrey[100],
                        child: ListTile(
                          leading: Icon(
                            Icons.person_outline_outlined,
                            size: 35,
                            color: Colors.blueGrey[600],
                          ),
                          title: Text('Full Name'),
                          trailing: Icon(
                            Icons.edit,
                            color: Colors.lightGreen[800],
                          ),
                          subtitle: StreamBuilder<QuerySnapshot<Object?>>(
                            stream:
                                _firestore.collection('UsersData').snapshots(),
                            builder: (
                              BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot,
                            ) {
                              var UserUid;
                              final messages = snapshot.data!.docs;
                              for (var message in messages) {
                                // var firebaseUser = _auth.currentUser;
                                UserUid = message.get('uid');
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Text('Loading ...');
                                }
                                // final img = message.get('Image');
                                if (UserUid == firebaseUser?.uid) {
                                  Name =
                                      '   ${message.get('First_Name')} ${message.get('Last_Name')}';
                                  // print(Name);
                                }
                              }

                              return Text(
                                Name,
                                style: TextStyle(color: Colors.black),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(25.0))),
                          backgroundColor: Colors.white,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => Padding(
                                padding: EdgeInsets.only(
                                    top: 20,
                                    right: 20,
                                    left: 20,
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Center(
                                        child: Text(
                                          'Change your phone number',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 20),
                                        ),
                                      ),
                                      SizedBox(height: 8.0),
                                      TextField(
                                        onChanged: (value) {
                                          phoneNbr = int.parse(value);
                                        },
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            hintText: 'Phone Number'),
                                        autofocus: true,
                                      ),
                                      SizedBox(height: 15),
                                      Center(
                                        child: FloatingActionButton(
                                            elevation: 11,
                                            backgroundColor: Colors.blueAccent,
                                            onPressed: () {
                                              _firestore
                                                  .collection("UsersData")
                                                  .doc("${firebaseUser?.uid}")
                                                  .update({
                                                'Phone': phoneNbr,
                                              });

                                              Navigator.pop(context);
                                            },
                                            child: Icon(
                                              // <-- Icon
                                              Icons.done,
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
                    child: Card(
                      color: Colors.blueGrey[100],
                      child: ListTile(
                        leading: Icon(
                          Icons.phone_outlined,
                          size: 35,
                          color: Colors.blueGrey[600],
                        ),
                        title: Text('Phone Number'),
                        trailing: Icon(
                          Icons.edit,
                          color: Colors.lightGreen[800],
                        ),
                        subtitle: StreamBuilder<QuerySnapshot<Object?>>(
                          stream:
                              _firestore.collection('UsersData').snapshots(),
                          builder: (
                            BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot,
                          ) {
                            var UserUid;
                            final messages = snapshot.data!.docs;
                            for (var message in messages) {
                              // var firebaseUser = _auth.currentUser;
                              UserUid = message.get('uid');
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text('Loading ...');
                              }
                              // final img = message.get('Image');
                              if (UserUid == firebaseUser?.uid) {
                                phone = '${message.get('Phone')}';
                                // print(Name);
                              }
                            }

                            return Text(
                              '  0' + phone,
                              style: TextStyle(color: Colors.black),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    color: Colors.blueGrey[100],
                    child: ListTile(
                      leading: Icon(
                        Icons.email_outlined,
                        size: 35,
                        color: Colors.blueGrey[700],
                      ),
                      title: Text('E-mail'),
                      subtitle: Text('${firebaseUser?.email}',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Data extends StatefulWidget {
  const Data({super.key});

  @override
  State<Data> createState() => _DataState();
}

class _DataState extends State<Data> {
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
              //Name = '${message.get('First_Name')} ${message.get('Last_Name')}';
              imag = message.get('Image');

              // print(Name);
            }
          }

          return Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
            child: CircleAvatar(
              radius: 85,
              backgroundColor: Color.fromARGB(255, 101, 182, 223),
              backgroundImage: imag != null
                  ? NetworkImage(imag)
                  : AssetImage('images/profile.png') as ImageProvider,
            ),
          );
        });
  }
}
