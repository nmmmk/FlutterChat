import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/controllers/account_controller.dart';
import 'package:flutter_chat/dialogs/message_dialog.dart';
import 'package:flutter_chat/dialogs/progress_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final _iconFileProvider = StateProvider<String?>((ref) => null);
final _updateButtonProvider = StateProvider((ref) => true);
final _nickNameProvider = StateProvider<String>((ref) => ref.read(accountController).accountItem.name);

class AccountPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(title: Text("アカウント設定")),
        body: SafeArea(
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    _AccountIcon(),
                    const SizedBox(height: 30),
                    _AccountNickName(),
                    const SizedBox(height: 30),
                    _AccountEmail(),
                    const SizedBox(height: 30),
                    _AccountUpdateButton()
                  ],
                ))));
  }
}

class _AccountIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String defaultUrl = ref.read(accountController).accountItem.imageUrl;
    String? imageUrl = ref.watch(_iconFileProvider).state;

    ImageProvider image = NetworkImage(defaultUrl);
    if (imageUrl != null) {
      image = FileImage(File(imageUrl));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: image,
          radius: 32,
        ),
        RawMaterialButton(
          onPressed: () async {
            final picker = ImagePicker();
            final pickedFile = await picker.pickImage(source: ImageSource.gallery);
            if (pickedFile == null) {
              return;
            }

            ref.read(_iconFileProvider).state = pickedFile.path;
          },
          child: Container(width: 64, height: 64),
          shape: CircleBorder(),
          elevation: 0,
        )
      ],
    );
  }
}

class _AccountNickName extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Text(
            "ニックネーム",
            textAlign: TextAlign.left,
          ),
        ),
        TextField(
          controller: TextEditingController(text: ref.read(accountController).accountItem.name),
          onChanged: (text) {
            ref.read(_nickNameProvider).state = text;
            ref.read(_updateButtonProvider).state = text.isNotEmpty;
          },
        )
      ],
    );
  }
}

class _AccountEmail extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Text(
            "メールアドレス",
            textAlign: TextAlign.left,
          ),
        ),
        TextField(
          controller: TextEditingController(text: ref.read(accountController).accountItem.email),
          enabled: false,
        )
      ],
    );
  }
}

class _AccountUpdateButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enableUpdateButton = ref.watch(_updateButtonProvider).state;

    return SizedBox(
        width: 100,
        child: ElevatedButton(
            onPressed: !enableUpdateButton
                ? null
                : () {
                    _updateAccount(context, ref);
                  },
            child: Text("更新")));
  }

  _updateAccount(context, ref) async {
    final controller = ref.read(accountController.notifier);
    var text = ref.read(_nickNameProvider).state;
    var filePath = ref.read(_iconFileProvider).state;

    final pd = ProgressDialog(context);
    pd.show("更新しています");
    try {
      await controller.updateAccount(nickName: text, filePath: filePath);
    } catch (e) {
      showErrorDialog(context: context, message: '更新に失敗しました。');
      return;
    } finally {
      pd.close();
    }

    showSuccessDialog(context: context, message: '更新完了しました。');
  }
}
