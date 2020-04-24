import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hostel_app/blocs/living_bloc/living_bloc.dart';
import 'package:hostel_app/data/models/living.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/busy_numbers/components/add_living_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/busy_numbers/components/add_time_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/busy_numbers/components/move_living_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/custom_flat_button.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/modal_dialogs/make_sure_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class BusyNumbersList extends StatefulWidget {
  final List<Living> living;
  final List<Number> numbers;
  final List<Guest> guests;

  BusyNumbersList({
    @required this.living,
    @required this.numbers,
    @required this.guests,
  });

  @override
  _BusyNumbersListState createState() => _BusyNumbersListState();
}

class _BusyNumbersListState extends State<BusyNumbersList> {
  CalendarController _calendarController;
  List<Living> _selectedEvents;

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
              ),
              onDaySelected: (day, events) {
                try {
                  setState(() {
                    _selectedEvents =
                        events.length == 0 ? null : events as List<Living>;
                  });
                } catch (ex) {
                  events.forEach((living) {
                    BlocProvider.of<LivingBloc>(context)
                        .add(LivingDeleteEvent(living: living));
                  });
                }
              },
            ),
          ),
          _selectedEvents != null
              ? _buildlivingInfos()
              : _buildAddliving(context),
        ],
      ),
    );
  }

  Center _buildAddliving(context) => Center(
        child: buildFlatButton(
          'Поселить гостя без брони',
          () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddLivingScreen(
                  categories: [],
                  living: widget.living,
                  guests: widget.guests,
                  numbers: widget.numbers,
                ),
              ),
            );
          },
        ),
      );

  Widget _buildlivingInfos() {
    return Container(
      height: 255,
      child: ListView.builder(
        itemCount: _selectedEvents.length,
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.333,
            actions: <Widget>[
              IconSlideAction(
                caption: 'продлить',
                color: Colors.blue,
                icon: Icons.timer,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AddTimeScreen(
                        living: _selectedEvents[index],
                      ),
                    ),
                  );
                },
              ),
              IconSlideAction(
                caption: 'переселить',
                color: Colors.indigo,
                icon: Icons.track_changes,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MoveLivingScreen(
                        living: _selectedEvents[index],
                        numbers: widget.numbers,
                      ),
                    ),
                  );
                },
              ),
              IconSlideAction(
                caption: 'выселить',
                color: Colors.blue,
                icon: Icons.cancel,
                onTap: () => _onDelete(context, index),
              ),
            ],
            child: Card(
              color: Colors.green.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
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

  void _onDelete(BuildContext context, int index) async {
    bool result = await showMakeSureDialog(
      context: context,
      title: 'Вы уверены что хотите выселить гостя?',
      content: 'это действие не подлежит возврату',
      ok: 'выселить',
      onOk: () {},
    );
    if (result) {
      BlocProvider.of<LivingBloc>(context)
          .add(LivingDeleteEvent(living: _selectedEvents[index]));
      setState(() => _selectedEvents.removeAt(index));
    }
  }

  String _getGuestNameById(String id) {
    return widget.guests.firstWhere((el) => el.id == id).fio;
  }

  String _getNumberNameById(String id) {
    return widget.numbers.firstWhere((el) => el.id == id).name;
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
    Map<DateTime, List<Living>> events = {};
    widget.living.forEach(
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
