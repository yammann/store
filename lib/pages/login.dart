import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/constens/colors.dart';
import 'package:store/constens/snackbar.dart';
 import 'package:store/pages/regester.dart';
import 'package:store/pages/resetpassword.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store/provider/googleSignIn.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailcontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  bool obscure = true;

  checkaccount() async {
    try {
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ShowSnackBar(context, 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        ShowSnackBar(context, 'Wrong password provided for that user.');
      } else
        // ignore: curly_braces_in_flow_control_structures
        ShowSnackBar(context, 'Wrong...');
    }
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final googleSignIn=Provider.of<GoogleSignInProvider>(context);
    return SafeArea(
        child: Scaffold(
      backgroundColor: const Color.fromRGBO(253, 251, 251, 1),
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text(
          "Login",
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  validator: (value) {
                    var result = EmailValidator.validate(value!);
                    return result ? null : "Enter a valed Email";
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
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
                  height: 20,
                ),
                TextFormField(
                  validator: (value) {
                    var result = value!.length >= 8;
                    return result ? null : "Enter a valed password";
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordcontroller,
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
                  onPressed: () {
                    setState(() {
                      checkaccount();
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(mainColor),
                      padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  child: const Text(
                    "Sign in",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResetPassword()));
                    },
                    child: const Text("Forget password ?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold))),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Do not have an account",
                      style: TextStyle(fontSize: 18),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Regester()));
                        },
                        child: const Text("Sing up",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)))
                  ],
                ),
               GestureDetector(
                 child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset("assets/icons8-google.svg"),
                 ),
                  onTap: (){
                    googleSignIn.googlelogin();
                  },
               ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
