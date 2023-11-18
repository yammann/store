// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

ShowSnackBar(BuildContext context,String text){
   ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text (text),
            margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
            backgroundColor: const Color.fromRGBO(253, 85, 85, 1),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 10),
            action: SnackBarAction(label: "Cancel", onPressed: (){}),));
}