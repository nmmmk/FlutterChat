import 'package:flutter/cupertino.dart';

@immutable
class AccountItem {
  final String userId;
  final String name;
  final String email;
  final String imageUrl;

  AccountItem({required this.userId, required this.name, required this.email, required this.imageUrl});

  AccountItem copyWith({final String? userId, final String? name, final String? email, final String? imageUrl}) {
    return AccountItem(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        email: email ?? this.email,
        imageUrl: imageUrl ?? this.imageUrl);
  }
}
