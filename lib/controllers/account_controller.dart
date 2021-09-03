import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/entities/account_item.dart';
import 'package:flutter_chat/utils/firebase_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userProvider = StateProvider((ref) => FirebaseAuth.instance.currentUser);
final accountController = StateNotifierProvider<AccountController, AccountItem>(
  (ref) => AccountController(),
);

class AccountController extends StateNotifier<AccountItem> {
  final _usersCollection = FirebaseFirestore.instance.collection("users");

  AccountController() : super(AccountItem(userId: "", name: "", email: "", imageUrl: ""));

  Future fetchAccountItem(String uid) async {
    var snapshot = await _usersCollection.doc(uid).get();
    state = AccountItem(
        userId: uid, name: snapshot["user_name"], email: snapshot["user_email"], imageUrl: snapshot["user_image_url"]);
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
  }

  Future updateAccount(String nickName, String filePath) async {
    DocumentReference ref = _usersCollection.doc(state.userId);

    await ref.update({
      "user_name": nickName,
    });

    this.state = this.state.copyWith(name: nickName);
  }

  Future<String?> _uploadIcon(String uid, File file) async {
    String? url;
    try {
      var storageFileName = '${uid}_icon';
      url = await FirebaseUtil.uploadFile(storageFileName, file.path);
    } catch (e) {
      print(e);
    }

    return url;
  }
}
