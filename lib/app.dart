import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/home_page.dart';
import 'package:flutter_chat/pages/login_page/login_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const buttonTheme = ButtonThemeData(textTheme: ButtonTextTheme.primary, shape: StadiumBorder());

    final FirebaseAuth auth = FirebaseAuth.instance;
    final isLogin = auth.currentUser != null;

    return MaterialApp(
        theme: ThemeData(primaryColor: const Color(0xFF214B70), buttonTheme: buttonTheme),
        home: isLogin ? HomePage() : LoginPage());
  }
}
