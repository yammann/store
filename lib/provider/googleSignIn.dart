// ignore_for_file: file_names, unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class GoogleSignInProvider with ChangeNotifier{
  final googleSignIn=GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user=> _user!;
  googlelogin()async{
    final googleuser=await googleSignIn.signIn();
    if (googleSignIn==null)return;
    _user=googleuser;
    final googleauth=await googleuser?.authentication;
    final credential=GoogleAuthProvider.credential(
      accessToken: googleauth?.accessToken,
      idToken: googleauth?.idToken
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
  }
}