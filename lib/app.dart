import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/controllers/account_controller.dart';
import 'package:flutter_chat/pages/home_page.dart';
import 'package:flutter_chat/pages/login_page.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const buttonTheme = ButtonThemeData(textTheme: ButtonTextTheme.primary, shape: StadiumBorder());

    final FirebaseAuth auth = FirebaseAuth.instance;
    final isLogin = auth.currentUser != null;

    final isLoading = ref.watch(accountController.select((s) => s.isLoading));
    Widget page = Container(color: Colors.white);
    if (!isLoading) {
      page = isLogin ? HomePage() : LoginPage();
    }

    return MaterialApp(theme: ThemeData(primaryColor: const Color(0xFF214B70), buttonTheme: buttonTheme), home: page);
  }
}
