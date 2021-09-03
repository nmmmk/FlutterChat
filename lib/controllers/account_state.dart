import 'package:flutter/cupertino.dart';
import 'package:flutter_chat/entities/account_item.dart';

@immutable
class AccountState {
  final bool isLoading;
  final AccountItem accountItem;

  AccountState({required this.isLoading, required this.accountItem});

  AccountState copyWith({final bool? isLoading, final AccountItem? accountItem}) {
    return AccountState(isLoading: isLoading ?? this.isLoading, accountItem: accountItem ?? this.accountItem);
  }
}
