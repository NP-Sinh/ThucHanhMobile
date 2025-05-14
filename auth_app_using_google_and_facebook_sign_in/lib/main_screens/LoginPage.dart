import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../results_screen/ForgotPassword.dart';
import '../results_screen/GoogleDone.dart';
import '../results_screen/Done.dart';
import '../main_screens/RegisterPage.dart';

class LoginPage extends StatefulWidget {
  static String id = '/LoginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  String? email;
  String? password;
  bool _showSpinner = false;

  bool _wrongEmail = false;
  bool _wrongPassword = false;

  String emailText = 'Email doesn\'t match';
  String passwordText = 'Password doesn\'t match';

  Future<User?> _handleSignIn() async {
    try {
      final isSignedIn = await _googleSignIn.isSignedIn();
      if (isSignedIn) {
        return _auth.currentUser;
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) return null;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );
        return userCredential.user;
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }

  void onGoogleSignIn(BuildContext context) async {
    setState(() {
      _showSpinner = true;
    });

    User? user = await _handleSignIn();

    setState(() {
      _showSpinner = false;
    });

    if (user != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoogleDone(user, _googleSignIn),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showSpinner,
        color: Colors.blueAccent,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Image.asset('assets/images/background.png'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 60.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Login', style: TextStyle(fontSize: 50.0)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,', style: TextStyle(fontSize: 30.0)),
                      Text('please login', style: TextStyle(fontSize: 30.0)),
                      Text('to your account', style: TextStyle(fontSize: 30.0)),
                    ],
                  ),
                  Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => email = value,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          errorText: _wrongEmail ? emailText : null,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      TextField(
                        obscureText: true,
                        onChanged: (value) => password = value,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          errorText: _wrongPassword ? passwordText : null,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, ForgotPassword.id);
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff447def),
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                    ),
                    onPressed: () async {
                      setState(() {
                        _showSpinner = true;
                      });

                      try {
                        setState(() {
                          _wrongEmail = false;
                          _wrongPassword = false;
                        });

                        final UserCredential newUser = await _auth
                            .signInWithEmailAndPassword(
                              email: email!,
                              password: password!,
                            );

                        if (newUser.user != null) {
                          Navigator.pushNamed(context, Done.id);
                        }
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          _showSpinner = false;
                        });
                        if (e.code == 'wrong-password') {
                          setState(() => _wrongPassword = true);
                        } else if (e.code == 'user-not-found') {
                          setState(() {
                            emailText = 'User doesn\'t exist';
                            passwordText = 'Please check your email';
                            _wrongPassword = true;
                            _wrongEmail = true;
                          });
                        }
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        child: Divider(color: Colors.black, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Or', style: TextStyle(fontSize: 20.0)),
                      ),
                      SizedBox(
                        width: 60,
                        child: Divider(color: Colors.black, thickness: 1),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(10),
                          ),
                          onPressed: () => onGoogleSignIn(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/google.png',
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(width: 10),
                              Text('Google', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.all(10),
                          ),
                          onPressed: () {
                            // TODO: Implement Facebook sign-in
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/facebook.png',
                                width: 40,
                                height: 40,
                              ),
                              SizedBox(width: 10),
                              Text('Facebook', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                        child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 18.0, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
