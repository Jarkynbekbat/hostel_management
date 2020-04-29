import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';
import 'package:hostel_app/data/models/category.dart';

class CategoryEditScreen extends StatefulWidget {
  Category category;
  CategoryEditScreen({@required this.category});

  @override
  _CategoryEditScreenState createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends State<CategoryEditScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _roomsController = TextEditingController();

  @override
  void initState() {
    _nameController.text = widget.category.name;
    _descriptionController.text = widget.category.description;
    _priceController.text = widget.category.price.toString();
    _roomsController.text = widget.category.rooms.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Изменение категории'),
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
            var isExistName = context
                .bloc<NumbersBloc>()
                .repository
                .categories
                .map((e) => e.name)
                .contains(_nameController.text);
            if (isExistName) {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content: Text('Категория с таким названием уже существует!'),
                ),
              );
            } else {
              Category newone = Category(
                id: widget.category.id,
                name: _nameController.text,
                description: _descriptionController.text,
                price: int.parse(_priceController.text),
                rooms: int.parse(_roomsController.text),
              );
              bool isEdited = await context
                  .bloc<NumbersBloc>()
                  .repository
                  .edit<Category>(newone);
              if (isEdited) {
                context
                    .bloc<NumbersBloc>()
                    .repository
                    .categories
                    .removeWhere((c) => c.id == newone.id);
                context.bloc<NumbersBloc>().repository.categories.add(newone);
                Navigator.of(context).pop();
              } else {
                _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(
                        'Не удалось изменить , проверьте интернет соединение!'),
                  ),
                );
              }
            }
          } else {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text('Заполните все поля')),
            );
          }
        },
      ),
    );
  }
}
