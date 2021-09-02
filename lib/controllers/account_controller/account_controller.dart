import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/entities/account_item/account_item.dart';

class AccountController {
  late AccountItem myAccount;
  final _usersCollection = FirebaseFirestore.instance.collection("users");

  Future initialize(String uid) async {
    myAccount = await getAccountItem(uid);
  }

  Future updateAccount(String nickName, String imageUrl) async {}

  Future<AccountItem> getAccountItem(String uid) async {
    var snapshot = await _usersCollection.doc(uid).get();
    var state = AccountItem(uid, snapshot["user_name"], snapshot["user_email"], snapshot["user_image_url"]);
    return state;
  }
}
