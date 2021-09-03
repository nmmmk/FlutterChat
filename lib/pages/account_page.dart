import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_chat/controllers/account_controller.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final _iconFileProvider = StateProvider<String?>((ref) => null);
final _updateButtonProvider = StateProvider((ref) => true);
final _nickNameProvider = StateProvider<String>((ref) => ref.read(accountController).name);

class AccountPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(userProvider).state!.uid;
    final controller = ref.watch(accountController.notifier);

    return Scaffold(
        appBar: AppBar(title: Text("アカウント設定")),
        body: SafeArea(
            child: FutureBuilder(
                future: controller.fetchAccountItem(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Container(
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
                        ));
                  }
                })));
  }
}

class _AccountIcon extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String defaultUrl = ref.read(accountController).imageUrl;
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
          controller: TextEditingController(text: ref.read(accountController).name),
          onChanged: (text) {
            debugPrint(text);
            ref.read(_nickNameProvider).state = text;
            ref.read(_updateButtonProvider).state = text.isNotEmpty;
          },
        )
      ],
    );
  }
}

class _AccountEmail extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController(text: ref.read(accountController).email);

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
          controller: emailController,
        )
      ],
    );
  }
}

class _AccountUpdateButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(accountController.notifier);
    final enableUpdateButton = ref.watch(_updateButtonProvider).state;

    return SizedBox(
        width: 100,
        child: ElevatedButton(
            onPressed: !enableUpdateButton
                ? null
                : () {
                    var text = ref.read(_nickNameProvider).state;
                    var filePath = ref.read(_iconFileProvider).state;

                    controller.updateAccount(text, "");
                  },
            child: Text("更新")));
  }
}
