import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'account_page/account_page.dart';
import 'chat_page/chat_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _pageList = [ChatPage(), AccountPage()];
  var _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _pageIndex,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "メッセージ"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "アカウント")
        ],
        currentIndex: _pageIndex,
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }
}
