import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_chat/entities/account_item.dart';
import 'package:flutter_chat/entities/chat_message_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final chatMessageController = StateNotifierProvider<ChatMessageController, ChatMessageItem>(
  (ref) => ChatMessageController(),
);

class ChatMessageController extends StateNotifier<ChatMessageItem> {
  final _chatCollection = FirebaseFirestore.instance.collection("chat");
  final _usersCollection = FirebaseFirestore.instance.collection("users");

  late Stream<List<ChatMessageItem>> chatStream;

  ChatMessageController() : super(ChatMessageItem("", DateTime.now(), "", "")) {
    chatStream = _chatCollection
        .orderBy("date", descending: false)
        .snapshots()
        .asyncMap((snapshot) => Future.wait([for (var data in snapshot.docs) _createChatMessageItem(data)]));
  }

  Future<ChatMessageItem> _createChatMessageItem(DocumentSnapshot snapshot) async {
    var message = ChatMessageItem(
        snapshot.id, DateTime.fromMillisecondsSinceEpoch(snapshot["date"]), snapshot["message"], snapshot["uid"]);

    message.account = await _getAccountItem(message.userId);

    return message;
  }

  Future<AccountItem> _getAccountItem(String uid) async {
    var snapshot = await _usersCollection.doc(uid).get();
    var state = AccountItem(
        userId: uid, name: snapshot["user_name"], email: snapshot["user_email"], imageUrl: snapshot["user_image_url"]);
    return state;
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
