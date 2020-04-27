import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/living_bloc/living_bloc.dart';
import 'package:hostel_app/data/models/living.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/custom_flat_button.dart';

class AddTimeScreen extends StatefulWidget {
  Living living;
  AddTimeScreen({@required this.living});

  @override
  _AddTimeScreenState createState() => _AddTimeScreenState();
}

class _AddTimeScreenState extends State<AddTimeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _leaving;
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    _leaving = _leaving ?? widget.living.leaving;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Переселение гостя'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Текущая дата выезда:'),
                Text(widget.living.leaving.toString()),
              ],
            ),
            SizedBox(height: 20.0),
            buildFlatButton(
              'выбрать новую дату',
              () async {
                _leaving = await showDatePicker(
                  context: context,
                  initialDate: _leaving,
                  firstDate: _leaving,
                  lastDate: _leaving.add(Duration(days: 365)),
                );
                setState(() => _selected = true);
              },
              context,
            ),
            SizedBox(height: 20.0),
            _selected
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('новая дата выезда:'),
                      Text(_leaving.toString()),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Living newone = Living(
            id: widget.living.id,
            guest: widget.living.guest,
            number: widget.living.number,
            arriving: widget.living.arriving,
            leaving: _leaving,
          );
          BlocProvider.of<LivingBloc>(context)
              .add(LivingEditEvent(living: newone));
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
