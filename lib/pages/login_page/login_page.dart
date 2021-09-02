import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/home_page.dart';
import 'package:flutter_chat/utils/firebase_util.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          child: Center(
              child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[FlutterLogo(size: 150), SizedBox(height: 50), _signInButton(context)],
          ))),
    );
  }

  Widget _signInButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () async {
        User? user = await FirebaseUtil.signInGoogle();
        if (user != null) {
          await _registerUser(user);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) {
                return HomePage();
              },
            ),
          );
        }
      },
      style: OutlinedButton.styleFrom(shape: const StadiumBorder()),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _registerUser(User user) async {
    DocumentReference ref = FirebaseFirestore.instance.collection("users").doc(user.uid);
    DocumentSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      return;
    }

    return ref.set({
      "user_name": user.displayName,
      "user_email": user.email,
      "user_image_url": user.photoURL,
    });
  }
}
