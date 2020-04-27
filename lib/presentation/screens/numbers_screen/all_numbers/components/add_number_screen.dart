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
            TextField(
              keyboardType: TextInputType.number,
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'название',
                helperText: 'введите название номера',
              ),
            ),
            SizedBox(height: 20.0),
            Text('Выберите категорию'),
            DropdownButton(
              isExpanded: true,
              value: _categoryId,
              items: widget.categories
                  .map((el) =>
                      DropdownMenuItem(child: Text(el.name), value: el.id))
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
            try {
              BlocProvider.of<NumbersBloc>(context).add(
                NumbersAddEvent(
                  number: Number(name: int.parse(name), category: _categoryId),
                ),
              );
              Navigator.of(context).pop();
            } catch (ex) {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text('введите только цифры!'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
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
