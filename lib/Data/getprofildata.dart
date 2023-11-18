import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GetProfileData extends StatefulWidget {
  const GetProfileData({super.key});

  @override
  State<GetProfileData> createState() => _GetProfileDataState();
}

class _GetProfileDataState extends State<GetProfileData> {
  final userauth = FirebaseAuth.instance.currentUser!;
  CollectionReference user = FirebaseFirestore.instance.collection("userss");
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: user.doc(userauth.uid).get(),
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
            return UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/download.png"),
                  fit: BoxFit.cover,
                ),
              ),
              accountName: Text(data['username']),
              accountEmail: Text(userauth.email!),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(data["imgurl"]),
              ),
            );
          }
          return const Text("Dont have account");
        });
  }
}
