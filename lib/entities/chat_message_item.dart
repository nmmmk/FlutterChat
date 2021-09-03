import 'package:flutter_chat/entities/account_item.dart';

class ChatMessageItem {
  String key;
  DateTime dateTime;
  String message;
  String userId;
  late AccountItem account;

  ChatMessageItem(this.key, this.dateTime, this.message, this.userId);
}
