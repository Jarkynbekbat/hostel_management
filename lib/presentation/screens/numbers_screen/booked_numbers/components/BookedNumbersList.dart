import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hostel_app/blocs/booking_bloc/booking_bloc.dart';
import 'package:hostel_app/blocs/living_bloc/living_bloc.dart';
// import 'package:hostel_app/blocs/living_bloc/living_bloc.dart';
import 'package:hostel_app/data/models/booking.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/models/living.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/booked_numbers/components/add_booking_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/custom_flat_button.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/make_sure_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class BookedNumbersList extends StatefulWidget {
  final List<Booking> booking;
  final List<Number> numbers;
  final List<Guest> guests;

  BookedNumbersList({
    @required this.booking,
    @required this.numbers,
    @required this.guests,
  });

  @override
  _BookedNumbersListState createState() => _BookedNumbersListState();
}

class _BookedNumbersListState extends State<BookedNumbersList> {
  CalendarController _calendarController;
  List<Booking> _selectedEvents;

  @override
  void initState() {
    _calendarController = CalendarController();
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: TableCalendar(
              startDay: DateTime.now(),
              calendarController: _calendarController,
              locale: 'ru_RU',
              events: _generateEvents(),
              calendarStyle: CalendarStyle(
                canEventMarkersOverflow: true,
                markersColor: Theme.of(context).accentColor,
              ),
              onDaySelected: (day, events) {
                setState(() {
                  _selectedEvents =
                      events.length == 0 ? null : events as List<Booking>;
                });
              },
            ),
          ),
          _selectedEvents != null
              ? _buildBookingInfos()
              : _buildAddBooking(context),
        ],
      ),
    );
  }

  Center _buildAddBooking(context) => Center(
        child: buildFlatButton(
          'забронировать номер',
          () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddBookingScreen(
                  categories: [],
                  booking: widget.booking,
                  guests: widget.guests,
                  numbers: widget.numbers,
                ),
              ),
            );
          },
          context,
        ),
      );

  Widget _buildBookingInfos() {
    return Container(
      // padding: EdgeInsets.all(16),
      height: 255,
      child: ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.50,
            actions: <Widget>[
              IconSlideAction(
                caption: 'Поселить по брони',
                color: Colors.blue,
                icon: Icons.assignment_ind,
                onTap: () async => await _addLivingByBooking(context, index),
              ),
              IconSlideAction(
                caption: 'Отменить бронь',
                color: Colors.indigo,
                icon: Icons.cancel,
                onTap: () => _onCancel(context, index),
              ),
            ],
            child: Card(
              color: Colors.green.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    _infoRow('Гость:',
                        _getGuestNameById(_selectedEvents[index].guest)),
                    _infoRow('Номер:',
                        _getNumberNameById(_selectedEvents[index].number)),
                    _infoRow(
                        'въезд:', _selectedEvents[index].arriving.toString()),
                    _infoRow(
                        'выезд:', _selectedEvents[index].leaving.toString()),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future _addLivingByBooking(BuildContext context, int index) async {
    bool result = await showMakeSureDialog(
      context: context,
      title: 'Поселить гостя по брони ?',
      content: 'это действие удалит бронь',
      ok: 'поселить',
      onOk: () {},
    );
    if (result) {
      // удалить бронь
      BlocProvider.of<BookingBloc>(context)
          .add(BookingDeleteEvent(booking: _selectedEvents[index]));
      // добавить living
      context.bloc<LivingBloc>().add(
            LivingAddFromBookingEvent(booking: _selectedEvents[index]),
          );
      setState(() => _selectedEvents.removeAt(index));
    }
  }

  void _onCancel(BuildContext context, int index) async {
    bool result = await showMakeSureDialog(
      context: context,
      title: 'Вы уверены что хотите отменить?',
      content: 'это действие не подлежит возврату',
      ok: 'отменить',
      onOk: () {},
    );
    if (result) {
      BlocProvider.of<BookingBloc>(context)
          .add(BookingDeleteEvent(booking: _selectedEvents[index]));
      setState(() => _selectedEvents.removeAt(index));
    }
  }

  String _getGuestNameById(String id) {
    return widget.guests.firstWhere((el) => el.id == id).fio;
  }

  String _getNumberNameById(String id) {
    return widget.numbers.firstWhere((el) => el.id == id).name.toString();
  }

  Row _infoRow(title, info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(title),
        Text(info),
      ],
    );
  }

  Map<DateTime, List<dynamic>> _generateEvents() {
    Map<DateTime, List<Booking>> events = {};
    widget.booking.forEach(
      (el) {
        DateTime from = el.arriving;
        DateTime to = el.leaving;

        while (from.isBefore(to) || from.isAtSameMomentAs(to)) {
          if (events[from] != null) {
            events[from].add(el);
          } else {
            events[from] = [el];
          }
          from = from.add(Duration(days: 1));
        }
      },
    );
    return events;
  }
}
