import 'package:flutter/material.dart';

class ProgressDialog {
  final BuildContext context;
  late bool _isOpen;

  ProgressDialog(this.context);

  void show(String message) {
    _isOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            margin: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                Container(margin: EdgeInsets.all(10.0), child: Text(message)),
              ],
            ),
          ),
        );
      },
    );
  }

  void close() {
    if (_isOpen == false) {
      return;
    }
    _isOpen = false;
    Navigator.pop(context);
  }
}
