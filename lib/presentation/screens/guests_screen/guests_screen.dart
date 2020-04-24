import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/repositories/repository.dart';
import 'package:hostel_app/presentation/screens/guests_screen/components/guest_add_screen.dart';
import 'package:hostel_app/presentation/screens/guests_screen/components/guest_edit_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/modal_dialogs/make_sure_dialog.dart';

class GuestsScreen extends StatefulWidget {
  static final String route = 'guests_screen';
  @override
  _GuestsScreenState createState() => _GuestsScreenState();
}

class _GuestsScreenState extends State<GuestsScreen> {
  Repository repository = Repository();
  List<Guest> guests = [];

  @override
  void initState() {
    _loadGuests();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  Future _loadGuests() async {
    guests = await repository.getAll<Guest>();
    print('object');
    setState(() {});
  }

  ListView _buildLoaded() {
    return ListView.separated(
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
            ),
          );
        },
        separatorBuilder: (context, index) => Divider(),
        itemCount: guests.length);
  }

  Future _onDelete(model) async {
    bool res = await showMakeSureDialog(
      context: context,
      title: 'Удаление',
      content: 'Вы уверены что хотите удалить выбранного гостя?',
      ok: 'удалить',
      onOk: () {},
    );
    if (res) {
      guests = await repository.delete<Guest>(model);
      setState(() {});
    }
  }

  Center _buildLoading() => Center(child: CircularProgressIndicator());
}
