import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

User? loggedInUser;

// ignore: must_be_immutable
class Done extends StatefulWidget {
  static String id = '/Done';

  @override
  _DoneState createState() => _DoneState();
}

class _DoneState extends State<Done> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
        });
      }
    } catch (e) {
      print('Error getting current user: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/done.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomRight,
              stops: [0.5, 1],
              colors: [
                Colors.black.withOpacity(.9),
                Colors.black.withOpacity(.2),
              ],
            ),
          ),
          child: Center(
            child: Text(
              'Welcome ${loggedInUser?.displayName ?? 'User'}!',
              style: TextStyle(fontSize: 50.0, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
