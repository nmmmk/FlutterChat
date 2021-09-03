import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/controllers/account_controller.dart';
import 'package:flutter_chat/controllers/chat_message_controller.dart';
import 'package:flutter_chat/entities/chat_message_item.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _messageQueryProvider = StreamProvider<List<ChatMessageItem>>((ref) {
  ref.watch(accountController);
  return ref.read(chatMessageController.notifier).chatStream;
});

class ChatPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sample Chat")),
      body: SafeArea(
          child: Container(
              child: Column(
        children: <Widget>[
          Expanded(child: _ChatArea()),
          Divider(
            height: 4.0,
          ),
          Container(decoration: BoxDecoration(color: Theme.of(context).cardColor), child: _MessageTextField())
        ],
      ))),
    );
  }
}

class _ChatArea extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<ChatMessageItem>> asyncPostsQuery = ref.watch(_messageQueryProvider);

    return asyncPostsQuery.when(data: (item) {
      if (item.length == 0) {
        return Center(child: Text("データがありません"));
      }

      return ListView(
          padding: const EdgeInsets.all(8.0),
          children: item.map((e) {
            return _ChatMessage(item: e);
          }).toList());
    }, loading: () {
      return Center(child: CircularProgressIndicator());
    }, error: (e, stackTrace) {
      return Center(child: Text(stackTrace.toString()));
    });
  }
}

class _ChatMessage extends ConsumerWidget {
  _ChatMessage({required this.item}) : super(key: ValueKey(item));

  final ChatMessageItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.read(accountController);

    return Container(
        margin: EdgeInsets.only(top: 16.0),
        child: account.accountItem.email == item.account.email
            ? _currentUserCommentRow(item)
            : _otherUserCommentRow(item));
  }

  Widget _currentUserCommentRow(ChatMessageItem data) {
    return Row(children: <Widget>[
      Container(child: _avatarLayout(data)),
      SizedBox(
        width: 16.0,
      ),
      new Expanded(child: _messageLayout(data, CrossAxisAlignment.start)),
    ]);
  }

  Widget _otherUserCommentRow(ChatMessageItem data) {
    return Row(children: <Widget>[
      new Expanded(child: _messageLayout(data, CrossAxisAlignment.end)),
      SizedBox(
        width: 16.0,
      ),
      Container(child: _avatarLayout(data)),
    ]);
  }

  Widget _messageLayout(ChatMessageItem data, CrossAxisAlignment alignment) {
    return Column(
      crossAxisAlignment: alignment,
      children: <Widget>[
        Text(data.account.name, style: TextStyle(fontSize: 14.0, color: Colors.grey)),
        Text(data.message)
      ],
    );
  }

  Widget _avatarLayout(ChatMessageItem data) {
    return CircleAvatar(
      backgroundImage: NetworkImage(data.account.imageUrl),
    );
  }
}

class _MessageTextField extends ConsumerWidget {
  final _textEditController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.read(accountController);
    final controller = ref.read(chatMessageController.notifier);

    return Row(
      children: <Widget>[
        SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: TextField(
            controller: _textEditController,
            decoration: InputDecoration(border: InputBorder.none),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        ),
        CupertinoButton(
          child: Text("送信"),
          onPressed: () {
            var text = _textEditController.text.trimRight();
            if (text.isEmpty) {
              return;
            }

            controller.addMessage(text, account.accountItem.userId);
            _textEditController.clear();
            FocusScope.of(context).requestFocus(FocusNode());
          },
        )
      ],
    );
  }
}
