import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';
import 'package:hostel_app/data/models/guest.dart';

class GuestAddScreen extends StatefulWidget {
  @override
  _GuestAddScreenState createState() => _GuestAddScreenState();
}

class _GuestAddScreenState extends State<GuestAddScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _fioController = TextEditingController();
  TextEditingController _infoController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Добавление гостя'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(22.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _fioController,
              decoration: InputDecoration(
                hintText: 'ФИО',
                helperText: 'введите ФИО',
              ),
            ),
            SizedBox(height: 30.0),
            TextField(
              controller: _infoController,
              decoration: InputDecoration(
                hintText: 'Информация',
                helperText: 'введите дополнительную информацию',
              ),
            ),
            SizedBox(height: 30.0),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: 'Номер телефона',
                helperText: 'введите номер телефона',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          if (_fioController.text != '' &&
              _infoController.text != '' &&
              _phoneController.text != '') {
            Guest newone = Guest(
              fio: _fioController.text,
              info: _infoController.text,
              phone: _phoneController.text,
            );
            bool isAdded =
                await context.bloc<NumbersBloc>().repository.add<Guest>(newone);

            if (isAdded) {
              context.bloc<NumbersBloc>().repository.guests.add(newone);
              Navigator.of(context).pop();
            } else {
              _scaffoldKey.currentState.showSnackBar(
                SnackBar(
                  content:
                      Text('Не удалось добавить,поверьте интернет соединение!'),
                ),
              );
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
