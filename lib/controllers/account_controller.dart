import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/entities/account_item.dart';
import 'package:flutter_chat/utils/firebase_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'account_state.dart';

final userProvider = StateProvider((ref) => FirebaseAuth.instance.currentUser);
final accountController = StateNotifierProvider<AccountController, AccountState>((ref) {
  final uid = ref.read(userProvider).state?.uid;
  return AccountController(uid);
});

class AccountController extends StateNotifier<AccountState> {
  final _usersCollection = FirebaseFirestore.instance.collection("users");

  AccountController(String? uid)
      : super(AccountState(isLoading: true, accountItem: AccountItem(userId: "", name: "", email: "", imageUrl: ""))) {
    _initialize(uid);
  }

  Future _initialize(String? uid) async {
    if (uid == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    var snapshot = await _usersCollection.doc(uid).get();
    var item = AccountItem(
        userId: uid, name: snapshot["user_name"], email: snapshot["user_email"], imageUrl: snapshot["user_image_url"]);

    state = state.copyWith(isLoading: false, accountItem: item);
  }

  Future registerUser(User user) async {
    DocumentReference ref = _usersCollection.doc(user.uid);
    DocumentSnapshot snapshot = await ref.get();
    if (snapshot.exists) {
      return;
    }

    await ref.set({
      "user_name": user.displayName,
      "user_email": user.email,
      "user_image_url": user.photoURL,
    });

    var item = state.accountItem.copyWith(
        userId: user.uid, name: user.displayName ?? "", email: user.email ?? "", imageUrl: user.photoURL ?? "");
    state = state.copyWith(accountItem: item);
  }

  Future updateAccount({String? nickName, String? filePath}) async {
    final userId = state.accountItem.userId;
    DocumentReference ref = _usersCollection.doc(userId);

    Map<String, String> map = {};
    if (nickName != null) {
      map["user_name"] = nickName;
    }

    String? url;
    if (filePath != null) {
      url = await _uploadIcon(userId, File(filePath));
      map["user_image_url"] = url;
    }

    if (map.length == 0) {
      return;
    }

    await ref.update(map);

    var item = this.state.accountItem.copyWith(name: nickName, imageUrl: url);
    this.state = this.state.copyWith(accountItem: item);
  }

  Future<String> _uploadIcon(String uid, File file) async {
    String url;
    try {
      var storedFileName = '${uid}_icon';
      url = await FirebaseUtil.uploadFile('user_icon', storedFileName, file.path);
    } catch (e) {
      throw e;
    }

    return url;
  }
}
