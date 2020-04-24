import 'package:flutter/material.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/repositories/repository.dart';

class GuestAddScreen extends StatefulWidget {
  @override
  _GuestAddScreenState createState() => _GuestAddScreenState();
}

class _GuestAddScreenState extends State<GuestAddScreen> {
  Repository _repository = Repository();
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
            await _repository.add<Guest>(
              Guest(
                fio: _fioController.text,
                info: _infoController.text,
                phone: _phoneController.text,
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
