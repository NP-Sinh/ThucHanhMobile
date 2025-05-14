import 'package:flutter/material.dart';
import 'package:phone_number_otp/phone.dart';
import 'package:phone_number_otp/verify.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: 'phone',
    debugShowCheckedModeBanner: false,
    routes: {
      'phone': (context) => MyPhone(),
      'verify': (context) => MyVerify()
    },
  ));
}
