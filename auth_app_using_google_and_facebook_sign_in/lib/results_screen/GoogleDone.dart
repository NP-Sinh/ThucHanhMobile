import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleDone extends StatelessWidget {
  final GoogleSignIn _googleSignIn;
  final User _user;

  GoogleDone(this._user, this._googleSignIn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child:
                  _user.photoURL != null
                      ? Image.network(
                        _user.photoURL!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                      : Image.network(
                        'https://lh3.googleusercontent.com/6UgEjh8Xuts4nwdWzTnWH8QtLuHqRMUB7dp24JYVE2xcYzq4HA8hFfcAbU-R-PC_9uA1',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
            ),
            SizedBox(height: 20),
            Text(
              _user.displayName ?? 'No Name',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(height: 30),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                await _googleSignIn.signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              child: Text(
                'Google Sign Out',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
