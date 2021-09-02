import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AccountIcon extends StatefulWidget {
  final String defaultUrl;

  AccountIcon({required this.defaultUrl});

  @override
  _AccountIconState createState() => _AccountIconState();
}

class _AccountIconState extends State<AccountIcon> {
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    ImageProvider image = NetworkImage(widget.defaultUrl);
    if (imageUrl != null) {
      image = FileImage(File(imageUrl!));
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

            setState(() {
              imageUrl = pickedFile.path;
            });
          },
          child: Container(width: 64, height: 64),
          shape: CircleBorder(),
          elevation: 0,
        )
      ],
    );
  }
}
