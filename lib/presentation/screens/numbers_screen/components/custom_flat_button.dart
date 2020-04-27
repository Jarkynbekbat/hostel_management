import 'package:flutter/material.dart';

FlatButton buildFlatButton(title, onTab, context, [padding]) {
  return FlatButton(
    padding: EdgeInsets.all(padding ?? 12.0),
    child: Text(
      title,
      style: TextStyle(
        fontSize: 17.0,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(18.0),
    ),
    onPressed: onTab,
    color: Theme.of(context).accentColor,
  );
}
