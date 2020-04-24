import 'package:flutter/material.dart';
import 'package:hostel_app/data/models/category.dart';
import 'package:hostel_app/data/repositories/repository.dart';

class CategoryAddScreen extends StatefulWidget {
  @override
  _GuestAddScreenState createState() => _GuestAddScreenState();
}

class _GuestAddScreenState extends State<CategoryAddScreen> {
  Repository _repository = Repository();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _roomsController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление категории'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(22.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Название',
                  helperText: 'введите название категории',
                ),
              ),
              SizedBox(height: 30.0),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Описание',
                  helperText: 'введите дополнительную информацию',
                ),
              ),
              SizedBox(height: 30.0),
              TextField(
                controller: _roomsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Количество комнат',
                  helperText: 'введите количество комнат для категории',
                ),
              ),
              SizedBox(height: 30.0),
              TextField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Цена',
                  helperText: 'введите цену для категории',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          if (_nameController.text != '' &&
              _descriptionController.text != '' &&
              _priceController.text != '' &&
              _roomsController.text != '') {
            await _repository.add<Category>(
              Category(
                name: _nameController.text,
                description: _descriptionController.text,
                price: int.parse(_priceController.text),
                rooms: int.parse(_roomsController.text),
              ),
            );
            Navigator.of(context).pop();
          } else {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Заполните все поля'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
      ),
    );
  }
}
