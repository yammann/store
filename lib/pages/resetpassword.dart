// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:store/constens/colors.dart';
import 'package:store/constens/snackbar.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emailcontroller = TextEditingController();

  ResetPasswordAccount() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailcontroller.text);
      ShowSnackBar(context, "Check your email");
    } on FirebaseAuthException catch (e) {
      ShowSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "Reset Password",
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "enter your email to reset your password",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: emailcontroller,
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
              height: 40,
            ),
            ElevatedButton(
              onPressed: () {
                ResetPasswordAccount();
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(mainColor),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)))),
              child: const Text(
                "Reset Password",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
