import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/controllers/chat_message_controller/chat_message_controller.dart';
import 'package:flutter_chat/entities/chat_message_item/chat_message_item.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _textEditController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ChatMessageController _controller = ChatMessageController();

  @override
  initState() {
    super.initState();
    _controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: new Text("Sample Chat")),
      body: SafeArea(child: Container(child: _buildChatArea())),
    );
  }

  // 投稿メッセージの入力部分のWidgetを生成
  Widget _buildInputArea() {
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

            _controller.addMessage(text, _auth.currentUser!.uid);
            _textEditController.clear();
            // キーボードを閉じる
            FocusScope.of(context).requestFocus(new FocusNode());
          },
        )
      ],
    );
  }

  Widget _buildChatArea() {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder<List<ChatMessageItem>>(
            stream: _controller.stream,
            builder: (BuildContext context, AsyncSnapshot<List<ChatMessageItem>> snapshot) {
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  return ListView(
                    padding: const EdgeInsets.all(8.0),
                    children: snapshot.data!.map((ChatMessageItem document) {
                      return _buildRow(document);
                    }).toList(),
                  );
              }
            },
          ),
        ),
        Divider(
          height: 4.0,
        ),
        Container(decoration: BoxDecoration(color: Theme.of(context).cardColor), child: _buildInputArea())
      ],
    );
  }

  Widget _buildRow(ChatMessageItem data) {
    return Container(
        margin: EdgeInsets.only(top: 16.0),
        child: _controller.myAccount.email == data.account.email
            ? _currentUserCommentRow(data)
            : _otherUserCommentRow(data));
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
