import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/controllers/account_controller.dart';
import 'package:flutter_chat/pages/home_page.dart';
import 'package:flutter_chat/utils/firebase_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
            children: <Widget>[FlutterLogo(size: 150), const SizedBox(height: 50), _SignInButton()],
          ))),
    );
  }
}

class _SignInButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(accountController.notifier);

    return OutlinedButton(
      onPressed: () async {
        User? user = await FirebaseUtil.signInGoogle();
        if (user != null) {
          await controller.registerUser(user);
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
}
