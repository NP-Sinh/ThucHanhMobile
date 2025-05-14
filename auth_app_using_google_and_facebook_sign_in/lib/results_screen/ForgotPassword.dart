import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class ForgotPassword extends StatefulWidget {
  static String id = '/ForgotPassword';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        title: 'Email Sent ✈️',
        desc: 'Check your email to reset password!',
        btnOkOnPress: () {},
      ).show();
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.scale,
        title: 'Error',
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset('assets/images/background.png'),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: 60.0,
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Reset Password', style: TextStyle(fontSize: 40.0)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Enter your email', style: TextStyle(fontSize: 30.0)),
                    SizedBox(height: 20.0),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: 'Email'),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    backgroundColor: Color(0xff447def),
                  ),
                  onPressed: () {
                    final email = _emailController.text.trim();
                    if (email.isNotEmpty) {
                      resetPassword(email);
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        title: 'Empty Email',
                        desc: 'Please enter your email address',
                        btnOkOnPress: () {},
                      ).show();
                    }
                  },
                  child: Text(
                    'Reset Password',
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
