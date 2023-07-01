import 'dart:io';
import 'dart:math';

import 'package:chatapp/screens/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'ChatScreen.dart';

const List<String> _list = <String>[
  'Friends',
  'Familly',
  'Work',
  'Fun',
  'Gaming',
  'Studying',
  'Business',
  'Other'
];
Color? sc;
int? ci;
Color pickerColor = Color(0xff443a49);
Color currentColor = Color(0xff443a49);
int colo = currentColor.value;
String? ownerImage;
String? ownerMail;
Color? forthis;
late List imgs;
late int members;
// ignore: non_constant_identifier_names
List Listmembers = [];
late String type;
late String name;
late int phoneNbr;
final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
var firebaseUser = _auth.currentUser;

class ChatSettings extends StatefulWidget {
  const ChatSettings({super.key});
  @override
  State<ChatSettings> createState() => _ChatSettingsState();
}

class _ChatSettingsState extends State<ChatSettings> {
  bool _sync = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getColor();
  }

  @override
  String? ima;
  File? imaage;
  void getImagefromGall() async {
    setState(() {
      _sync = true;
    });
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() async {
        imaage = imageTemporary;
        final ref = FirebaseStorage.instance
            .ref()
            .child('GroupsImages')
            .child('${namefinal}.jpg');
        UploadTask uploadTask = ref.putFile(imaage!);

        await ref.putFile(imaage!);

        ima = await ref.getDownloadURL();
        _firestore.collection("Groups").doc(DocId).update({'Image': ima});
      });
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _sync = false;
      });
    }
  }

  void changeColor(Color color) {
    setState(() {
      pickerColor = color;
      choosed = Color(colors!);
    });
  }

  void getColor() {
    setState(() {
      FirebaseFirestore.instance
          .collection('Groups')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          ci = doc['color'];
          var titel = doc["name"];
          if (titleTo == titel) {
            ci = doc["color"];
          }
        });
      });
    });
  }

  String _dropdownValue = _list.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: choosed,
        appBar: AppBar(),
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          SizedBox(
            height: 30,
          ),
          ModalProgressHUD(
            inAsyncCall: _sync,
            child: Data(),
          ),
          SizedBox(
            height: 8,
          ),
          InkWell(
            onTap: () {},
            child: Text(
              titleTo!,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.black),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Column(
            children: [
              SettingsType('Change Image', Colors.blueGrey.shade900,
                  Icons.add_a_photo_outlined, () => getImagefromGall()),
              SettingsType('Change Name', Colors.blueGrey.shade800, Icons.edit,
                  () {
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Text(
                                  'Change Group Name',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              TextField(
                                onChanged: (value) {
                                  name = value;
                                },
                                decoration:
                                    InputDecoration(hintText: 'Group Name'),
                                autofocus: true,
                              ),
                              SizedBox(height: 15),
                              Center(
                                child: FloatingActionButton(
                                    elevation: 11,
                                    backgroundColor: Colors.blueAccent,
                                    onPressed: () {
                                      setState(() {
                                        titleTo = name;
                                        _firestore
                                            .collection("Groups")
                                            .doc(DocId)
                                            .update({
                                          'title': name,
                                        });
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
              }),
              SettingsType('Change Type', Colors.blueGrey.shade700,
                  Icons.type_specimen_outlined, () {
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Text(
                                  'Change Group Type',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              DropdownButton<String>(
                                value: _dropdownValue,
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
                                    _dropdownValue = value;
                                  });
                                },
                                items: _list.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: 15),
                              Center(
                                child: FloatingActionButton(
                                    elevation: 11,
                                    backgroundColor: Colors.blueAccent,
                                    onPressed: () {
                                      setState(() {
                                        _firestore
                                            .collection("Groups")
                                            .doc(DocId)
                                            .update({
                                          'type': type,
                                        });
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
              }),
              Divider(
                color: Colors.black,
                height: 30,
              ),
              SettingsType(
                  'Theme', Colors.blueGrey.shade800, Icons.color_lens_outlined,
                  () {
                setState(() {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Pick a color!'),
                        content: SingleChildScrollView(
                          // child:
                          //
                          // ColorPicker(
                          //   pickerColor: pickerColor,
                          //   onColorChanged: changeColor,
                          // ),
                          //
                          //
                          child: MaterialPicker(
                            pickerColor: pickerColor,
                            onColorChanged: changeColor,
                            //showLabel: true, // only on portrait mode
                          ),
                          //
                          // Use Block color picker:
                          //
                          // child: BlockPicker(
                          //   pickerColor: currentColor,
                          //   onColorChanged: changeColor,
                          // ),
                          //
                          // child: MultipleChoiceBlockPicker(
                          //   pickerColors: currentColors,
                          //   onColorsChanged: changeColors,
                          // ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('Got it'),
                            onPressed: () {
                              setState(() => currentColor = pickerColor);
                              setState(() {
                                _firestore
                                    .collection("Groups")
                                    .doc(DocId)
                                    .update({
                                  'color': currentColor.value,
                                }).then((value) {
                                  setState(() {
                                    forthis = choosed;
                                  });
                                });
                              });

                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                });
              }),
              Divider(
                color: Colors.black,
                height: 30,
              ),
              SettingsType(
                  'Members', Colors.blueGrey.shade800, Icons.group_sharp, () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: 200,
                      color: Colors.blue[100],
                      child: Center(
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Members'),
                                      Text('${numbreTO}'),
                                    ],
                                  ),
                                )),
                            Expanded(
                              child: StreamBuilder<QuerySnapshot<Object>>(
                                stream:
                                    _firestore.collection('Groups').snapshots(),
                                builder: (
                                  BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot,
                                ) {
                                  final messages = snapshot.data!.docs;
                                  for (var message in messages) {
                                    Listmembers = message.get('Members');
                                    members = message.get('Numbre');
                                    imgs = message.get('MembersUID');

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Text('Loading ...');
                                    }
                                  }

                                  return ListView.builder(
                                      padding: const EdgeInsets.all(8),
                                      itemCount: Listmembers.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Container(
                                          // margin: EdgeInsets.all(10),
                                          height: 50,
                                          color: Colors.blue[100],
                                          child: Center(
                                              child: Row(
                                            children: [
                                              Row(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            imgs[index]),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text('${Listmembers[index]}'),
                                                ],
                                              ),
                                            ],
                                          )),
                                        );
                                      });
                                },
                              ),
                            ),
                          ],
                        ),
                        //   ],
                        // ),
                      ),
                    );
                  },
                );
              }),
              SettingsType('Admin', Colors.blueGrey.shade700,
                  Icons.admin_panel_settings_outlined, () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StreamBuilder<QuerySnapshot<Object>>(
                      stream: _firestore.collection('Groups').snapshots(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot,
                      ) {
                        List<Widget> messageWidget = [];

                        final messages = snapshot.data!.docs;
                        for (var message in messages) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text('Loading ...');
                          }
                          imgs = message.get('MembersUID');

                          var ti = message.get('title');

                          if (ti == titleTo) {
                            ownerMail = message.get('owner');
                            ownerImage = imgs.first;
                          }
                        }

                        return AlertDialog(
                          title: Center(
                            child: Text(
                              'Admin',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.cyan),
                            ),
                          ),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                        backgroundImage: ownerImage != null
                                            ? NetworkImage(ownerImage!)
                                            : AssetImage("images/profile.png")
                                                as ImageProvider),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Expanded(
                                        child: ownerMail != null
                                            ? Text(ownerMail!)
                                            : Text("Loading...")),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              }),
            ],
          )
        ]));
  }

  Padding SettingsType(
      String title, Color color, IconData icon, Function() ontap) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onTap: ontap,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      color: color, fontSize: 25, fontWeight: FontWeight.w700),
                ),
                Icon(
                  icon,
                  size: 25,
                  color: color,
                ),
              ],
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
        stream: _firestore.collection('Groups').snapshots(),
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
            UserUid = message.get('title');

            // final img = message.get('Image');
            if (UserUid == titleTo) {
              //Name = '${message.get('First_Name')} ${message.get('Last_Name')}';
              imag = message.get('Image');

              // print(Name);
            }
            var titel = message.get('name');
            if (namefinal == titel) {
              colors = message.get('color');
              choosed = Color(colors!);
            }
          }

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: CircleAvatar(
              radius: 85,
              backgroundColor: Color.fromARGB(255, 101, 182, 223),
              backgroundImage: imag != null
                  ? NetworkImage(imag!)
                  : NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/3177/3177440.png')
                      as ImageProvider,
            ),
          );
        });
  }
}
