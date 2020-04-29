import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';
import 'package:hostel_app/data/models/guest.dart';

class GuestEditScreen extends StatefulWidget {
  Guest guest;
  GuestEditScreen({@required this.guest});

  @override
  _GuestEditScreenState createState() => _GuestEditScreenState();
}

class _GuestEditScreenState extends State<GuestEditScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
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
            Guest newone = Guest(
              id: widget.guest.id,
              fio: _fioController.text,
              info: _infoController.text,
              phone: _phoneController.text,
            );

            bool isEdited = await context
                .bloc<NumbersBloc>()
                .repository
                .edit<Guest>(newone);

            if (isEdited) {
              context
                  .bloc<NumbersBloc>()
                  .repository
                  .guests
                  .removeWhere((g) => g.id == newone.id);
              context.bloc<NumbersBloc>().repository.guests.add(newone);
              Navigator.of(context).pop();
            }
          } else {
            var snackbar = SnackBar(content: Text("Заполните все поля!"));
            _scaffoldKey.currentState.showSnackBar(snackbar);
          }
        },
      ),
    );
  }
}
