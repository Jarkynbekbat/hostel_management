import 'package:flutter/material.dart';

import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';
import 'package:hostel_app/data/models/number.dart';

import 'number_card.dart';

class NumbersGrid extends StatelessWidget {
  final List<Number> numbers;
  final NumbersLoadedState state;
  const NumbersGrid({this.numbers, this.state});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        crossAxisCount: 2,
        children: List.generate(
          numbers.length,
          (index) {
            return NumberCard(
              number: numbers[index],
              state: state,
            );
          },
        ),
      ),
    );
  }
}
