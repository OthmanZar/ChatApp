import 'dart:io';

import 'package:chatapp/widgets/Button.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

bool stat = false;

final _formkey = GlobalKey<FormState>();

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController dateinput = TextEditingController();
  final _auth = FirebaseAuth.instance;
  DateTime? pickedDate;
  bool syn = false;
  late String email;
  late String password;
  late String LastNm;
  late String FirstNm;
  late int PhoneNbr;
  late String Date;
  late String formattedDate;
  String? ima;
  File? imaage;
  File? compressedFile;
  String path = "";
  void _submitForm() async {
    setState(() {
      syn = true;
    });

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      var firebaseUser = await _auth.currentUser;

      if (imaage != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('usersimages')
            .child('$email.jpg');
        UploadTask uploadTask = ref.putFile(imaage!);
        await ref.putFile(imaage!);
        ima = await ref.getDownloadURL();
      } else {
        ima = 'https://cdn-icons-png.flaticon.com/512/3177/3177440.png';
      }

      await FirebaseFirestore.instance
          .collection('UsersData')
          .doc(firebaseUser?.uid)
          .set({
        'First_Name': FirstNm,
        'Last_Name': LastNm,
        'Birthday': pickedDate,
        'Phone': PhoneNbr,
        'Image': ima,
        'uid': firebaseUser?.uid,
        'createdAt': Timestamp.now(),
        'password': password,
      });
      Navigator.pop(context);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        syn = false;
      });
    }
  }

  void compress() async {
    var result = await FlutterImageCompress.compressAndGetFile(
      imaage!.absolute.path,
      imaage!.path + 'compressed.jpg',
      quality: 20,
    );
    setState(() {
      compressedFile = result;
    });
  }

  void getImagefromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;
    final imageTemporary = File(image.path);

    setState(() async {
      imaage = imageTemporary;
    });

    Navigator.pop(context);
  }

  void getImagefromGall() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final imageTemporary = File(image.path);
    setState(() {
      imaage = imageTemporary;
    });

    if (imaage == null) return null;

    final compresed = await FlutterImageCompress.compressAndGetFile(
        imaage!.path, "/storage/emulated/0/Download/file1.jpg",
        quality: 20);
    if (compresed != null) {
      setState(() {
        imaage = compresed;
      });
    }

    Navigator.pop(context);
  }

  void remove() {
    setState(() {
      imaage = null;
    });
    Navigator.pop(context);
  }

  void Ret() {
    print(email);
    print(password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: syn,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 45,
                ),
                Center(
                  child: Stack(children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      child: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 101, 182, 223),
                        radius: 71,
                        child: CircleAvatar(
                          radius: 67,
                          backgroundColor: Color.fromARGB(255, 101, 182, 223),
                          backgroundImage: imaage != null
                              ? FileImage(imaage!)
                              : AssetImage('images/profile.png')
                                  as ImageProvider,
                        ),
                      ),
                    ),
                    Positioned(
                        top: 120,
                        left: 110,
                        right: 30,
                        bottom: 30,
                        child: RawMaterialButton(
                            elevation: 10,
                            fillColor: Colors.blue,
                            child: Icon(Icons.add_a_photo),
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                                      fontWeight:
                                                          FontWeight.w500,
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
                TextFormField(
                  validator: ((value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return 'Please Enter Your First Name';
                    }
                  }),
                  //keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    FirstNm = value;
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person_outlined),
                    labelText: 'Enter Your First Name',
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
                  validator: ((value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return 'Please Enter Your Last Name';
                    }
                  }),
                  //keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    LastNm = value;
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: 'Enter Your Last Name',
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
                  validator: ((value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return 'Please Enter Your Email';
                    }
                  }),
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
                    email = value;
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    icon: Icon(Icons.email),
                    labelText: 'Enter Your Email',
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
                  validator: ((value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return 'Please Enter Your Phone Number';
                    }
                  }),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    PhoneNbr = int.parse(value);
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    icon: Icon(Icons.phone),
                    labelText: 'Enter Your Phone Number',
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
                  validator: ((value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return 'Please Enter Your Birthday';
                    }
                  }),
                  controller: dateinput,
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: "Enter Your Birthday",
                    //hintText: 'Enter Your Password',
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
                  readOnly: true,
                  onTap: () async {
                    pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(
                            1940), //DateTime.now() - not to allow to choose before today.
                        lastDate: DateTime.now());

                    if (pickedDate != null) {
                      formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate!);
                      setState(() {
                        dateinput.text = formattedDate;
                      });
                    } else {
                      print("Date is not selected");
                    }
                  },
                  onChanged: (value) {
                    Date = value;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  validator: ((value) {
                    if (value!.isNotEmpty) {
                      return null;
                    } else {
                      return 'Please Enter Your Password';
                    }
                  }),
                  obscureText: true,
                  onChanged: (value) {
                    password = value;
                  },
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    icon: Icon(Icons.password_rounded),
                    labelText: "Enter Your Password",
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
                Row(
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Button(
                    color: Colors.greenAccent.shade200,
                    title: 'Sign in',
                    onTape: () {
                      setState(() {
                        if (!_formkey.currentState!.validate()) {
                          return;
                        }
                        if (imaage == null) {
                          setState(() {
                            stat = true;
                          });
                        } else {
                          setState(() {
                            stat = false;
                          });
                        }
                        if (imaage == null) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor:
                                      Color.fromARGB(255, 226, 193, 190),
                                  title: Center(
                                    child: Text("Add a Picture Please !!"),
                                  ),
                                  scrollable: true,
                                  content: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Form(
                                      child: Column(
                                        children: <Widget>[
                                          Center(
                                            child: Button(
                                                color: Color.fromARGB(
                                                    255, 204, 70, 60),
                                                title: 'OK',
                                                onTape: () async {
                                                  Navigator.pop(context);
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        } else {
                          _submitForm();
                        }
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
