// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/constens/colors.dart';
import 'package:store/constens/snackbar.dart';
import 'package:store/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class Regester extends StatefulWidget {
  const Regester({super.key});

  @override
  State<Regester> createState() => _RegesterState();
}

class _RegesterState extends State<Regester> {
  bool obscure = true;
  final _formkey = GlobalKey<FormState>();
  bool isLoading = false;
  final emailcontroler = TextEditingController();
  final passwordcontroler = TextEditingController();
  final namecontroler = TextEditingController();
  final agecontroler = TextEditingController();

  String? imgName;
  File? imgPaht;
  addImage(ImageSource imgSorc) async {
    final picImag = await ImagePicker()
        .pickImage(source: imgSorc);
    try {
      if (picImag != null) {
        setState(() {
          imgPaht = File(picImag.path);
          imgName=basename(picImag.path);
          int randum=Random().nextInt(9999999);
          imgName="$randum$imgName";
        });
      } else {
        ShowSnackBar(context, "no image");
      }
    } catch (e) {
      ShowSnackBar(context, e.toString());
    }
    Navigator.pop(context);
  }

  creatUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroler.text,
        password: passwordcontroler.text,
      );
      final storgref=FirebaseStorage.instance.ref(imgName);
      await storgref.putFile(imgPaht!);
      String url=await storgref.getDownloadURL();

      CollectionReference users =
          FirebaseFirestore.instance.collection("userss");

      users
          .doc(credential.user!.uid)
          .set({
            'username': namecontroler.text,
            'age': agecontroler.text,
            'imgurl':url, 
          })
          .then((value) => print("user added"))
          .catchError((error) => print(error));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ShowSnackBar(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        ShowSnackBar(context, 'The account already exists for that email.');
      }
    } catch (e) {
      ShowSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    emailcontroler.dispose();
    passwordcontroler.dispose();
    agecontroler.dispose();
    namecontroler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromRGBO(253, 251, 251, 1),
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "Regester",
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(100, 100, 100, 1)),
                    child: Stack(
                      children: [
                        imgPaht == null
                            ? const CircleAvatar(
                                backgroundColor: mainColor,
                                radius: 80,
                                backgroundImage:
                                    AssetImage("assets/download1.jpeg"),
                              )
                            : ClipOval(
                                child: Image.file(
                                  imgPaht!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        Positioned(
                            bottom: -10,
                            right: -10,
                            child: IconButton(
                                onPressed: () {
                                  showDialog(
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
                                                  label: const Text("Camera",style: TextStyle(color: Colors.black,fontSize: 18),),
                                                  onPressed: () {
                                                    addImage(ImageSource.camera);
                                                  },
                                                  icon: const Icon(
                                                    Icons.camera_alt_rounded,
                                                    size: 40,
                                                    color: mainColor,
                                                  )),
                                               TextButton.icon(
                                                label: const Text("Gallery",style: TextStyle(color: Colors.black,fontSize: 18),),
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
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: mainColor,
                                )))
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: namecontroler,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.person),
                        fillColor: Color.fromARGB(255, 209, 207, 207),
                        filled: true,
                        hintText: "Enter your name",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: agecontroler,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.date_range_outlined),
                        fillColor: Color.fromARGB(255, 209, 207, 207),
                        filled: true,
                        hintText: "Enter your age",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      var result = EmailValidator.validate(value!);
                      return result ? null : "Enter a valed Email";
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: emailcontroler,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.email),
                        fillColor: Color.fromARGB(255, 209, 207, 207),
                        filled: true,
                        hintText: "Enter your email adres",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    validator: (value) {
                      var result = value!.length >= 8;
                      return result ? null : "Enter a valed password";
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: passwordcontroler,
                    obscureText: obscure,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          icon: obscure
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off),
                        ),
                        fillColor: const Color.fromARGB(255, 209, 207, 207),
                        filled: true,
                        hintText: "Enter your password",
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: mainColor,
                            width: 2,
                          ),
                        ),
                        enabledBorder:
                            const OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        if(imgName!=null && imgPaht!=null){
                          await creatUser();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ));
                        }
                        else {
                          ShowSnackBar(context, "you dont choese any picture");
                        }
                      } else {
                        ShowSnackBar(context, "Complete the information");
                      }
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(mainColor),
                        padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)))),
                    child: isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            "Regester",
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "You have an account",
                        style: TextStyle(fontSize: 18),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ));
                          },
                          child: const Text("Sing in",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
