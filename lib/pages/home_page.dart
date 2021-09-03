import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'account_page.dart';
import 'chat_page.dart';

final _indexProvider = StateProvider((ref) => 0);

class HomePage extends ConsumerWidget {
  final _pageList = [ChatPage(), AccountPage()];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(_indexProvider).state;

    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: _pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "メッセージ"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "アカウント")
        ],
        currentIndex: pageIndex,
        onTap: (index) {
          if (ref.read(_indexProvider).state != index) {
            ref.read(_indexProvider).state = index;
          }
        },
      ),
    );
  }
}
