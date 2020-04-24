import 'package:flutter/material.dart';

FlatButton buildFlatButton(title, onTab, [padding]) {
  return FlatButton(
    padding: EdgeInsets.all(padding ?? 12.0),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(18.0),
    ),
    onPressed: onTab,
    color: Colors.blue,
  );
}
