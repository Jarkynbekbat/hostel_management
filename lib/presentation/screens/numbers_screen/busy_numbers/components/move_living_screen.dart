import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/living_bloc/living_bloc.dart';

import 'package:hostel_app/data/models/living.dart';
import 'package:hostel_app/data/models/number.dart';

class MoveLivingScreen extends StatefulWidget {
  Living living;
  final List<Number> numbers;
  MoveLivingScreen({@required this.living, @required this.numbers});

  @override
  _MoveLivingScreenState createState() => _MoveLivingScreenState();
}

class _MoveLivingScreenState extends State<MoveLivingScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _numberId;
  String currentNumberName;

  @override
  Widget build(BuildContext context) {
    _numberId = _numberId ?? widget.living.number;
    currentNumberName = widget.numbers
        .firstWhere((el) => el.id == widget.living.number)
        .name
        .toString();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Переселение гостя'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(60.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Текущий номер:'),
                Text(currentNumberName),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('пепеселить в:'),
                DropdownButton(
                  value: _numberId,
                  items: widget.numbers
                      .map((el) => DropdownMenuItem(
                          child: Text(
                            el.name.toString(),
                          ),
                          value: el.id))
                      .toList(),
                  onChanged: (value) {
                    setState(() => _numberId = value);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Living newone = Living(
            id: widget.living.id,
            guest: widget.living.guest,
            arriving: widget.living.arriving,
            leaving: widget.living.leaving,
            number: _numberId,
          );

          BlocProvider.of<LivingBloc>(context)
              .add(LivingEditEvent(living: newone));
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
