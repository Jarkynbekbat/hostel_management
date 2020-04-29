import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';
import 'package:hostel_app/data/models/booking.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/models/living.dart';
import 'package:hostel_app/presentation/screens/guests_screen/components/guest_add_screen.dart';
import 'package:hostel_app/presentation/screens/guests_screen/components/guest_detail_screen.dart';
import 'package:hostel_app/presentation/screens/guests_screen/components/guest_edit_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/make_sure_dialog.dart';

class GuestsScreen extends StatefulWidget {
  static final String route = 'guests_screen';
  @override
  _GuestsScreenState createState() => _GuestsScreenState();
}

class _GuestsScreenState extends State<GuestsScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Guest> guests = [];

  @override
  void initState() {
    _loadGuests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Гости'),
        centerTitle: true,
      ),
      body: guests.length == 0 ? _buildLoading() : _buildLoaded(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GuestAddScreen(),
            ),
          );
          _loadGuests();
        },
      ),
    );
  }

  _loadGuests() {
    guests = context.bloc<NumbersBloc>().repository.guests;
    setState(() {});
  }

  ListView _buildLoaded() {
    return ListView.builder(
        itemBuilder: (context, index) {
          return Slidable(
            actionPane: SlidableDrawerActionPane(),
            actionExtentRatio: 0.25,
            actions: <Widget>[
              IconSlideAction(
                caption: 'изменить',
                color: Colors.blue,
                icon: Icons.edit,
                onTap: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          GuestEditScreen(guest: guests[index]),
                    ),
                  );
                  _loadGuests();
                },
              ),
              IconSlideAction(
                caption: 'удалить',
                color: Colors.indigo,
                icon: Icons.delete_outline,
                onTap: () async => await _onDelete(guests[index]),
              ),
            ],
            child: ListTile(
              leading: Icon(Icons.account_box),
              title: Text(guests[index].fio),
              subtitle: Text(guests[index].info),
              onTap: () => _goToDetailScreen(context, index),
            ),
          );
        },
        itemCount: guests.length);
  }

  void _goToDetailScreen(BuildContext context, int index) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => GuestDeatailScreen(guest: guests[index]),
    ));
  }

  Future _onDelete(Guest model) async {
    bool res = await showMakeSureDialog(
      context: context,
      title: 'Удаление',
      content: 'Вы уверены что хотите удалить выбранного гостя?',
      ok: 'удалить',
      onOk: () {},
    );
    if (res) {
      List<Booking> booking = context.bloc<NumbersBloc>().repository.booking;
      List<Living> living = context.bloc<NumbersBloc>().repository.living;
      bool hasBooking = booking.map((b) => b.guest).contains(model.id);
      bool hasLiving = living.map((l) => l.guest).contains(model.id);

      if (!hasBooking && !hasLiving) {
        bool isDeleted =
            await context.bloc<NumbersBloc>().repository.delete<Guest>(model);
        if (isDeleted) {
          context
              .bloc<NumbersBloc>()
              .repository
              .guests
              .removeWhere((g) => g.id == model.id);
        }
        _loadGuests();
      } else {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
                'Нельзя удалить,этот гость забронировал номер или поселен!'),
          ),
        );
      }
    }
  }

  Center _buildLoading() => Center(child: CircularProgressIndicator());
}
