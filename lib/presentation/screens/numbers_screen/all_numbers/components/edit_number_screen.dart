import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';

import 'package:hostel_app/data/models/category.dart';
import 'package:hostel_app/data/models/number.dart';

class EditNumberScreen extends StatefulWidget {
  Number number;
  final List<Category> categories;
  EditNumberScreen({this.number, this.categories});

  @override
  _EditNumberScreenState createState() => _EditNumberScreenState();
}

class _EditNumberScreenState extends State<EditNumberScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _nameController = TextEditingController();
  String _categoryId;
  @override
  Widget build(BuildContext context) {
    widget.categories.removeWhere((el) => el.id == 'все');
    _categoryId = widget.number.category;
    _nameController.text = widget.number.name;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('изменение номера'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'введите название',
              style: const TextStyle(fontSize: 16.0),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'название'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Выберите категорию',
              style: const TextStyle(fontSize: 16.0),
            ),
            DropdownButton(
              isExpanded: true,
              value: _categoryId,
              items: widget.categories
                  .map(
                    (el) =>
                        DropdownMenuItem(child: Text(el.name), value: el.id),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _categoryId = value),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          String name = _nameController.text;

          if (name != '') {
            widget.number.name = name;
            widget.number.category = _categoryId;
            BlocProvider.of<NumbersBloc>(context)
                .add(NumbersEditEvent(number: widget.number));

            Navigator.of(context).pop();
          } else
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('Заполните все поля!'),
                duration: Duration(seconds: 2),
              ),
            );
        },
      ),
    );
  }
}
