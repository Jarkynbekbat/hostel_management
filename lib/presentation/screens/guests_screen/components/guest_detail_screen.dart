import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';
import 'package:hostel_app/data/models/booking.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/models/living.dart';
import 'package:intl/intl.dart';

class GuestDeatailScreen extends StatefulWidget {
  final Guest guest;
  const GuestDeatailScreen({this.guest});

  @override
  _GuestDeatailScreenState createState() => _GuestDeatailScreenState();
}

class _GuestDeatailScreenState extends State<GuestDeatailScreen> {
  List<Booking> _booking = [];
  List<Living> _living = [];

  @override
  void initState() {
    _booking = context
        .bloc<NumbersBloc>()
        .repository
        .booking
        .where((b) => b.guest == widget.guest.id)
        .toList();

    _living = context
        .bloc<NumbersBloc>()
        .repository
        .living
        .where((b) => b.guest == widget.guest.id)
        .toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const tabs = [
      Tab(
        child: Text('Бронирование'),
      ),
      Tab(
        child: Text('Посещение'),
      ),
    ];

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.guest.fio),
          centerTitle: true,
          bottom: TabBar(tabs: tabs),
        ),
        body: TabBarView(
          children: [
            Container(
              child: _booking.length != 0
                  ? _buildListViewForBooking()
                  : _buildNoData(),
            ),
            Container(
              child: _living.length != 0
                  ? _buildListViewForLiving()
                  : _buildNoData(),
            ),
          ],
        ),
      ),
    );
  }

  Center _buildNoData() {
    return Center(
      child: Text(
        'нет данных',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  ListView _buildListViewForLiving() {
    return ListView.builder(
      itemCount: _living.length,
      itemBuilder: (context, index) {
        int number = context
            .bloc<NumbersBloc>()
            .repository
            .numbers
            .firstWhere((n) => n.id == _living[index].number)
            .name;
        return ListTile(
          leading: CircleAvatar(child: Text('$number')),
          title: Text('номер '),
          subtitle: Text(
              'c ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, 'RU_ru').format(_booking[index].arriving)} по ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, 'RU_ru').format(_booking[index].leaving)}'),
        );
      },
    );
  }

  ListView _buildListViewForBooking() {
    return ListView.builder(
      itemCount: _booking.length,
      itemBuilder: (context, index) {
        int number = context
            .bloc<NumbersBloc>()
            .repository
            .numbers
            .firstWhere((n) => n.id == _booking[index].number)
            .name;
        return ListTile(
          leading: CircleAvatar(child: Text('$number')),
          title: Text('номер '),
          subtitle: Text(
              'c ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, 'RU_ru').format(_booking[index].arriving)} по ${DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, 'RU_ru').format(_booking[index].leaving)}'),
        );
      },
    );
  }
}
