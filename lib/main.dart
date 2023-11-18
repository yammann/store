// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:store/provider/cart.dart';
import 'package:store/provider/googleSignIn.dart';
import 'package:store/constens/snackbar.dart';
import 'package:store/firebase_options.dart';
import 'package:store/pages/login.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:store/pages/verified.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return Cart();
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return GoogleSignInProvider();
          },
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (snapshot.hasError)
              return ShowSnackBar(context, "Error");
            else if (snapshot.hasData)
              return const Verified();
            else
              return const Login();
          },
        ),
      ),
    );
  }
}
