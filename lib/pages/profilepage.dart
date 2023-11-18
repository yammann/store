// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:store/Data/getdatafromfirestore.dart';
import 'package:store/constens/colors.dart';
import 'package:store/constens/snackbar.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});
  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

File? imgPaht;
  addImage() async {
    final picImag = await ImagePicker().pickImage(source: ImageSource.camera);
    try {
      if (picImag != null) {
        setState(() {
          imgPaht = File(picImag.path);
        });
      } else {
        ShowSnackBar(context, "no image");
      }
    } catch (e) {
      ShowSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "Profile Page",
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               GetDataFromFireStore(userid: user.uid),
            ],
          ),
        ),
      ),
    );
  }
}
