import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/booking_bloc/booking_bloc.dart';
import 'package:hostel_app/data/models/booking.dart';

import 'package:hostel_app/data/models/category.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRagePicker;
import 'package:hostel_app/presentation/screens/numbers_screen/components/custom_flat_button.dart';

class AddBookingScreen extends StatefulWidget {
  final List<Category> categories;
  final List<Number> numbers;
  final List<Guest> guests;
  final List<Booking> booking;
  const AddBookingScreen({
    this.categories,
    this.numbers,
    this.guests,
    this.booking,
  });
  @override
  _AddBookingScreenState createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
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
        title: Text('Бронирование номера'),
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
                      .map((el) =>
                          DropdownMenuItem(child: Text(el.name), value: el.id))
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
                () async {
                  final List<DateTime> picked =
                      await DateRagePicker.showDatePicker(
                          context: context,
                          initialFirstDate:
                              (DateTime.now()).add(Duration(days: 1)),
                          initialLastDate:
                              (DateTime.now()).add(Duration(days: 7)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2021));
                  if (picked != null && picked.length == 2) {
                    _arriving = picked[0];
                    _leaving = picked[1];
                  }
                },
              ),
            )
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
              Booking booking = Booking(
                arriving: _arriving,
                leaving: _leaving,
                number: _numberId,
                guest: _guestId,
              );
              BlocProvider.of<BookingBloc>(context)
                  .add(BookingAddEvent(booking: booking));
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
}
