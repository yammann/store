// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:store/constens/colors.dart';
import 'package:store/constens/snackbar.dart';
import 'package:store/pages/login.dart';
import 'package:path/path.dart' show basename;

class GetDataFromFireStore extends StatefulWidget {
  final String userid;
  const GetDataFromFireStore({Key? key, required this.userid})
      : super(key: key);

  @override
  State<GetDataFromFireStore> createState() => _GetDataFromFireStoreState();
}

class _GetDataFromFireStoreState extends State<GetDataFromFireStore> {
  File? imgPaht;
  String? imgName;
  addImage(ImageSource Sorce) async {
    final picImag = await ImagePicker().pickImage(source: Sorce);
    try {
      if (picImag != null) {
        setState(() {
          imgPaht = File(picImag.path);
          imgName = basename(picImag.path);
          int rand = Random().nextInt(9999999);
          imgName = "$rand$imgName";
          Navigator.pop(context);
        });
      } else {
        ShowSnackBar(context, "no image");
      }
    } catch (e) {
      ShowSnackBar(context, e.toString());
    }
  }

  final userauth = FirebaseAuth.instance.currentUser!;
  CollectionReference user = FirebaseFirestore.instance.collection("userss");
  final dialogText = TextEditingController();

  myShoeSialog(Map data, dynamic mykey) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
          child: Container(
            padding: const EdgeInsets.all(11),
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: dialogText,
                  maxLength: 20,
                  decoration: InputDecoration(hintText: data[mykey]),
                ),
                const SizedBox(
                  height: 22,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            user
                                .doc(userauth.uid)
                                .update({mykey: dialogText.text});
                          });
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Edit",
                          style: TextStyle(fontSize: 20),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel", style: TextStyle(fontSize: 20))),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference user = FirebaseFirestore.instance.collection("userss");
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(widget.userid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Somthing went worng");
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document not existes");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromRGBO(100, 100, 100, 1)),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundColor: mainColor,
                        radius: 80,
                        backgroundImage:
                            NetworkImage(data['imgurl'].toString()),
                      ),
                      Positioned(
                          bottom: -12,
                          right: -12,
                          child: IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        height: 200,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton.icon(
                                                label: const Text(
                                                  "Camera",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                ),
                                                onPressed: () {
                                                  addImage(ImageSource.camera);
                                                },
                                                icon: const Icon(
                                                  Icons.camera_alt_rounded,
                                                  size: 40,
                                                  color: mainColor,
                                                )),
                                            TextButton.icon(
                                                label: const Text(
                                                  "Gallery",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18),
                                                ),
                                                onPressed: () {
                                                  addImage(ImageSource.gallery);
                                                },
                                                icon: const Icon(
                                                  Icons.photo,
                                                  size: 40,
                                                  color: mainColor,
                                                )),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text(
                                                  "Cancel",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ))
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                if (imgPaht != null) {
                                  final StorageRef =
                                      FirebaseStorage.instance.ref(imgName);
                                  await StorageRef.putFile(imgPaht!);
                                  String url =
                                      await StorageRef.getDownloadURL();
                                  setState(() {
                                    user
                                        .doc(userauth.uid)
                                        .update({'imgurl': url});
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: mainColor,
                              )))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "info from firebase auth",
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    backgroundColor: mainColor),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Email:${userauth.email}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Creat date:${DateFormat("MMMM d,y").format(userauth.metadata.creationTime!)} ",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Last signied id:${DateFormat("MMMM d,y").format(userauth.metadata.lastSignInTime!)}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        userauth.delete();
                        user.doc(userauth.uid).delete();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ));
                      });
                    },
                    child: const Text(
                      "Delete",
                      style: TextStyle(fontSize: 30),
                    )),
              ),
              const SizedBox(
                height: 45,
              ),
              const Text(
                "info from firebase firestore",
                style: TextStyle(
                    fontSize: 29.9,
                    fontWeight: FontWeight.bold,
                    backgroundColor: mainColor),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "User name: " + data['username'],
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        myShoeSialog(data, 'username');
                      },
                      icon: const Icon(Icons.edit))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Age: " + data['age'],
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        myShoeSialog(data, 'age');
                      },
                      icon: const Icon(Icons.edit))
                ],
              ),
            ],
          );
        }
        return const Center(
          child: Text("Loading!"),
        );
      },
    );
  }
}
