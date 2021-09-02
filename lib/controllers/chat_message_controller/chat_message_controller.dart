import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/controllers/account_controller/account_controller.dart';
import 'package:flutter_chat/entities/account_item/account_item.dart';
import 'package:flutter_chat/entities/chat_message_item/chat_message_item.dart';

class ChatMessageController {
  late Stream<List<ChatMessageItem>> stream;
  late AccountItem myAccount;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _chatCollection = FirebaseFirestore.instance.collection("chat");
  final AccountController _accountController = AccountController();

  Future initialize() async {
    stream = _chatCollection
        .orderBy("date", descending: false)
        .snapshots()
        .asyncMap((snapshot) => Future.wait([for (var data in snapshot.docs) _createChatMessageItem(data)]));

    await _accountController.initialize(_auth.currentUser!.uid);
    myAccount = _accountController.myAccount;
  }

  Future<ChatMessageItem> _createChatMessageItem(DocumentSnapshot snapshot) async {
    var message = ChatMessageItem(
        snapshot.id, DateTime.fromMillisecondsSinceEpoch(snapshot["date"]), snapshot["message"], snapshot["uid"]);

    message.account = await _accountController.getAccountItem(message.userId);

    return message;
  }

  Future<void> addMessage(String message, String userId) {
    var data = {
      "date": DateTime.now().millisecondsSinceEpoch,
      "message": message,
      "uid": userId,
    };

    return _chatCollection.add(data);
  }
}
