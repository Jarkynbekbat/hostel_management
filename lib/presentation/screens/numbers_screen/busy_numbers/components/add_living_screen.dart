import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/living_bloc/living_bloc.dart';
import 'package:hostel_app/data/models/living.dart';

import 'package:hostel_app/data/models/category.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:hostel_app/presentation/screens/numbers_screen/components/custom_flat_button.dart';

class AddLivingScreen extends StatefulWidget {
  final List<Category> categories;
  final List<Number> numbers;
  final List<Guest> guests;
  final List<Living> living;
  const AddLivingScreen({
    this.categories,
    this.numbers,
    this.guests,
    this.living,
  });
  @override
  _AddLivingScreenState createState() => _AddLivingScreenState();
}

class _AddLivingScreenState extends State<AddLivingScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _guestId;
  String _numberId;
  DateTime _arriving;
  DateTime _leaving;
  @override
  Widget build(BuildContext context) {
    _guestId = _guestId ?? widget.guests[0].id;
    _numberId = _numberId ?? widget.numbers[0].id;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Поселение гостя без брони'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Гость:'),
                DropdownButton(
                  value: _guestId,
                  items: widget.guests
                      .map(
                        (el) =>
                            DropdownMenuItem(child: Text(el.fio), value: el.id),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _guestId = value;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Номер:'),
                DropdownButton(
                  value: _numberId,
                  items: widget.numbers
                      .map((el) => DropdownMenuItem(
                          child: Text(el.name.toString()), value: el.id))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _numberId = value;
                    });
                  },
                ),
              ],
            ),
            Center(
              child: buildFlatButton(
                'выбрать даты',
                () async => await _onSelectRange(context),
                context,
              ),
            ),
            SizedBox(height: 50.0),
            Text(
                _arriving != null ? 'Дата въезда:             $_arriving' : ''),
            SizedBox(height: 20.0),
            Text(_leaving != null ? 'Дата выезда:             $_leaving' : ''),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () {
            bool isReady = _arriving != null &&
                _leaving != null &&
                _numberId != null &&
                _guestId != null &&
                _guestId != null;

            if (isReady) {
              Living living = Living(
                arriving: _arriving,
                leaving: _leaving,
                number: _numberId,
                guest: _guestId,
              );
              BlocProvider.of<LivingBloc>(context).add(
                LivingAddEvent(living: living),
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
          }),
    );
  }

  Future _onSelectRange(BuildContext context) async {
    final List<DateTime> picked = await DateRagePicker.showDatePicker(
        context: context,
        initialFirstDate: (DateTime.now()).add(Duration(days: 1)),
        initialLastDate: (DateTime.now()).add(Duration(days: 7)),
        firstDate: DateTime.now(),
        lastDate: DateTime(2021));
    if (picked != null && picked.length == 2) {
      setState(() {
        _arriving = picked[0];
        _leaving = picked[1];
      });
    }
  }
}
