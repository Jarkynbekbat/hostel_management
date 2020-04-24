import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';

import 'package:hostel_app/data/models/category.dart';
import 'package:hostel_app/data/models/number.dart';

class AddNumberScreen extends StatefulWidget {
  final List<Category> categories;
  const AddNumberScreen({@required this.categories});

  @override
  _AddNumberScreenState createState() => _AddNumberScreenState();
}

class _AddNumberScreenState extends State<AddNumberScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _nameController = TextEditingController();
  String _categoryId;

  @override
  Widget build(BuildContext context) {
    widget.categories.removeWhere((el) => el.id == 'все');
    _categoryId = _categoryId ?? widget.categories[0].id;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('добавление номера'),
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
          if (name != '' && name != null) {
            widget.categories.insert(0, Category(id: 'все', name: 'все'));
            BlocProvider.of<NumbersBloc>(context).add(
              NumbersAddEvent(
                number: Number(name: name, category: _categoryId),
              ),
            );
            Navigator.of(context).pop();
          } else {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text('Заполните все поля!'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}
