import 'package:flutter/material.dart';

import '../custom_flat_button.dart';

Future<bool> showMakeSureDialog({
  BuildContext context,
  String title,
  String content,
  String ok,
  Function onOk,
}) async {
  bool result = false;
  await showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              buildFlatButton(
                ok,
                () async {
                  result = true;
                  Navigator.of(context).pop();
                },
              ),
              buildFlatButton('отмена', () => Navigator.of(context).pop()),
            ],
          ),
        ),
      );
    },
  );
  return result;
}
