import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:auth_app_using_google_and_facebook_sign_in/results_screen/ForgotPassword.dart';
import 'package:auth_app_using_google_and_facebook_sign_in/main_screens/LoginPage.dart';
import 'package:auth_app_using_google_and_facebook_sign_in/main_screens/RegisterPage.dart';
import 'results_screen/Done.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Khởi tạo Firebase
  runApp(Home());
}
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Abel'),
      initialRoute: RegisterPage.id,
      routes: {
        RegisterPage.id: (context) => RegisterPage(),
        LoginPage.id: (context) => LoginPage(),
        ForgotPassword.id: (context) => ForgotPassword(),
        Done.id: (context) => Done(),
      },
    );
  }
}
