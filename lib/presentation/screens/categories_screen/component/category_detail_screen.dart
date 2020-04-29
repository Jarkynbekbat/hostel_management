import 'package:flutter/material.dart';

import 'package:hostel_app/data/models/category.dart';

class CategoryDetailScreen extends StatelessWidget {
  final Category category;
  const CategoryDetailScreen({this.category});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            Text('О категории', style: TextStyle(fontSize: 20.0)),
            Divider(),
            ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text(category.price.toString() + ' сом'),
              subtitle: Text('цена за 24 часа'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.border_all),
              title: Text(category.rooms == 1
                  ? category.rooms.toString() + ' комнатa'
                  : category.rooms.toString() + ' комнат'),
              subtitle: Text('количество комнат'),
            ),
            Divider(),
            Align(
              alignment: Alignment.center,
              child: Text(category.description),
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
