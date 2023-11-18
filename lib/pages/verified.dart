// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/constens/colors.dart';
import 'package:store/constens/snackbar.dart';
import 'package:store/pages/home.dart';
import 'package:store/pages/login.dart';

class Verified extends StatefulWidget {
  const Verified({super.key});

  @override
  State<Verified> createState() => _VerifiedState();
}

class _VerifiedState extends State<Verified> {
  bool isVerified = false;
  bool canResedEmail = false;
  late Timer timer;

  SendVerificationEmail() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();
      setState(() {
        canResedEmail = false;
      });
      await Future.delayed(const Duration(seconds: 5));
      setState(() {
        canResedEmail = true;
      });
    } catch (e) {
      ShowSnackBar(context, "$e.toString()");
    }
  }

  @override
  void initState() {
    super.initState();
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isVerified) {
      SendVerificationEmail();
      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        await FirebaseAuth.instance.currentUser!.reload();
        isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

        if (isVerified) {         
          setState(() {
             
          });
          timer.cancel();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isVerified
        ? const Home()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mainColor,
              title: const Text(
                "Verified Email",
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            body: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("A verification email has sent to your email"),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        canResedEmail ? SendVerificationEmail() : null;
                      },
                      child: const Text("Resent Email")),
                  const SizedBox(
                    height: 30,
                  ),
                  TextButton(onPressed: () {
                    Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (context)=>const Login()));
                  }, child: const Text("Cancel"))
                ],
              ),
            ),
          );
  }
}
