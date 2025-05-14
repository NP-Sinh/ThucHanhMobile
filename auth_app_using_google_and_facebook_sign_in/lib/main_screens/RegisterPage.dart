import 'package:flutter/material.dart';
import 'package:auth_app_using_google_and_facebook_sign_in/results_screen/Done.dart';
import 'package:auth_app_using_google_and_facebook_sign_in/results_screen/GoogleDone.dart';
import 'package:auth_app_using_google_and_facebook_sign_in/main_screens/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:validators/validators.dart' as validator;

class RegisterPage extends StatefulWidget {
  static String id = '/RegisterPage';

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? name;
  String? email;
  String? password;

  bool _showSpinner = false;
  bool _wrongEmail = false;
  bool _wrongPassword = false;
  bool _wrongName = false;

  String _emailText = 'Please use a valid email';
  String _passwordText = 'Please use a strong password';
  String _nameText = 'Name cannot be empty';

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> _handleSignIn() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  void onGoogleSignIn(BuildContext context) async {
    User? user = await _handleSignIn();
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
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 60),
                  Text('Register', style: TextStyle(fontSize: 50.0)),
                  SizedBox(height: 10),
                  Text('Lets get', style: TextStyle(fontSize: 30.0)),
                  Text('you on board', style: TextStyle(fontSize: 30.0)),
                  SizedBox(height: 30),
                  TextField(
                    keyboardType: TextInputType.name,
                    onChanged: (value) => name = value,
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      labelText: 'Full Name',
                      errorText: _wrongName ? _nameText : null,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => email = value,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: _wrongEmail ? _emailText : null,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextField(
                    obscureText: true,
                    onChanged: (value) => password = value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: _wrongPassword ? _passwordText : null,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      backgroundColor: Color(0xff447def),
                    ),
                    onPressed: () async {
                      setState(() {
                        _wrongEmail = false;
                        _wrongPassword = false;
                        _wrongName = false;
                      });

                      // Validate name
                      if ((name ?? '').isEmpty) {
                        setState(() {
                          _wrongName = true;
                        });
                        return;
                      }

                      // Validate email
                      if (!validator.isEmail(email ?? '')) {
                        setState(() => _wrongEmail = true);
                        return;
                      }

                      // Validate password
                      if (!validator.isLength(password ?? '', 6)) {
                        setState(() => _wrongPassword = true);
                        return;
                      }

                      setState(() => _showSpinner = true);

                      try {
                        final newUser = await _auth
                            .createUserWithEmailAndPassword(
                              email: email!,
                              password: password!,
                            );
                        if (newUser.user != null) {
                          Navigator.pushNamed(context, Done.id);
                        }
                      } on FirebaseAuthException catch (e) {
                        setState(() {
                          _wrongEmail = true;
                          if (e.code == 'email-already-in-use') {
                            _emailText = 'The email address is already in use';
                          }
                        });
                      } finally {
                        setState(() => _showSpinner = false);
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 60,
                        child: Divider(color: Colors.black87, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Or', style: TextStyle(fontSize: 25.0)),
                      ),
                      SizedBox(
                        width: 60,
                        child: Divider(color: Colors.black87, thickness: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            backgroundColor: Colors.white,
                            side: BorderSide(width: 0.5, color: Colors.grey),
                          ),
                          onPressed: () {
                            onGoogleSignIn(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/google.png',
                                width: 40.0,
                                height: 40.0,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Google',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            backgroundColor: Colors.white,
                            side: BorderSide(width: 0.5, color: Colors.grey),
                          ),
                          onPressed: () {
                            // TODO: Implement Facebook sign-in
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/facebook.png',
                                width: 40.0,
                                height: 40.0,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Facebook',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LoginPage.id);
                        },
                        child: Text(
                          ' Sign In',
                          style: TextStyle(fontSize: 20.0, color: Colors.blue),
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
