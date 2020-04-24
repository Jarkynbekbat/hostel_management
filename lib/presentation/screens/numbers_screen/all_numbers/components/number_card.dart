import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/all_numbers/components/edit_number_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/custom_flat_button.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/modal_dialogs/make_sure_dialog.dart';

class NumberCard extends StatelessWidget {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  final NumbersLoadedState state;
  final Number number;
  NumberCard({
    this.state,
    this.number,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: FlipCard(
        key: cardKey,
        front: _buildFront(),
        back: _buildBack(context, state),
      ),
    );
  }

  Widget _buildFront() {
    const textStyle = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    return Container(
      height: 300,
      color: Colors.green,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            number.name ?? 'нет данных',
            style: textStyle.copyWith(fontSize: 30.0),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(BuildContext context, state) {
    return Container(
      color: Colors.blue.withOpacity(0.5),
      child: Center(
        child: Wrap(
          direction: Axis.vertical,
          children: <Widget>[
            buildFlatButton('удалить', () => _onDelete(context), 5.0),
            buildFlatButton(
                'изменить', () => _onEdit(context, number, state), 5.0),
          ],
        ),
      ),
    );
  }

  void _onEdit(
      BuildContext context, Number number, NumbersLoadedState state) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditNumberScreen(
        categories: state.categories,
        number: number,
      ),
    ));
    cardKey.currentState.toggleCard();
  }

  void _onDelete(BuildContext context) async {
    bool response = await showMakeSureDialog(
      context: context,
      ok: 'удалить',
      title: 'Удаление номера',
      content: 'Вы уверены что хотите удалить номер ?',
    );
    if (response)
      BlocProvider.of<NumbersBloc>(context)
          .add(NumberDeleteEvent(number: number));
    cardKey.currentState.toggleCard();
  }

  String toRu(String status) {
    switch (status) {
      case 'busy':
        return 'поселен';
      case 'booked':
        return 'забронирован';
      case 'free':
        return 'свободен';
      default:
        return null;
    }
  }
}
