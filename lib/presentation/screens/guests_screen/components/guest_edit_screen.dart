import 'package:flutter/material.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/repositories/repository.dart';

class GuestEditScreen extends StatefulWidget {
  Guest guest;
  GuestEditScreen({@required this.guest});

  @override
  _GuestEditScreenState createState() => _GuestEditScreenState();
}

class _GuestEditScreenState extends State<GuestEditScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  Repository _repository = Repository();
  TextEditingController _fioController = TextEditingController();
  TextEditingController _infoController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    _fioController.text = widget.guest.fio;
    _infoController.text = widget.guest.info;
    _phoneController.text = widget.guest.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Изменение гостя'),
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
            widget.guest.fio = _fioController.text;
            widget.guest.info = _infoController.text;
            widget.guest.phone = _phoneController.text;
            await _repository.edit<Guest>(widget.guest);
            Navigator.of(context).pop();
          } else {
            var snackbar = SnackBar(content: Text("Cars enabled"));
            _scaffoldKey.currentState.showSnackBar(snackbar);
          }
        },
      ),
    );
  }
}
