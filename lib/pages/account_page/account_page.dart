import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/controllers/account_controller/account_controller.dart';

import 'account_icon.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final AccountController _controller = AccountController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _nameTextEditController = TextEditingController();
  final _emailTextEditController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("アカウント設定")),
        body: SafeArea(
            child: FutureBuilder(
                future: initialize(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            AccountIcon(defaultUrl: _controller.myAccount.imageUrl),
                            const SizedBox(height: 30),
                            _userNickNameLayout(),
                            const SizedBox(height: 30),
                            _userEmailLayout(),
                            const SizedBox(height: 30),
                            _updateButton()
                          ],
                        ));
                  }
                })));
  }

  Future initialize() async {
    await _controller.initialize(_auth.currentUser!.uid);

    _nameTextEditController.text = _controller.myAccount.name;
    _emailTextEditController.text = _controller.myAccount.email;
  }

  Widget _updateButton() {
    return SizedBox(width: 100, child: ElevatedButton(onPressed: () {}, child: Text("更新")));
  }

  Widget _userNickNameLayout() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Text(
            "ニックネーム",
            textAlign: TextAlign.left,
          ),
        ),
        TextField(
          controller: _nameTextEditController,
        )
      ],
    );
  }

  Widget _userEmailLayout() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Text(
              "メールアドレス",
              textAlign: TextAlign.left,
            )),
        TextField(
          enabled: false,
          controller: _emailTextEditController,
        )
      ],
    );
  }
}
