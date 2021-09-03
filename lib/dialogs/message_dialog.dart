import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showSuccessDialog({required BuildContext context, required String message, Function? btnOkOnPress}) {
  AwesomeDialog(
      context: context,
      padding: EdgeInsets.only(bottom: 8),
      headerAnimationLoop: false,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: '\n$message',
      desc: '',
      dismissOnTouchOutside: false,
      btnOkOnPress: () {
        btnOkOnPress?.call();
      })
    ..show();
}

void showErrorDialog({required BuildContext context, required String message, Function? btnOkOnPress}) {
  AwesomeDialog(
      context: context,
      padding: EdgeInsets.only(bottom: 8),
      headerAnimationLoop: false,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: '\n$message',
      desc: '',
      dismissOnTouchOutside: false,
      btnOkIcon: Icons.cancel,
      btnOkColor: Colors.red,
      btnOkOnPress: () {
        btnOkOnPress?.call();
      })
    ..show();
}
