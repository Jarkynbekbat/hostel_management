import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';

import 'package:hostel_app/presentation/screens/numbers_screen/components/custom_flat_button.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/my_choice_chips.dart';

import 'components/add_number_screen.dart';
import 'components/numbers_grid.dart';

class AllNumbersScreen extends StatefulWidget {
  static String route = 'all_numbers_screen';
  @override
  _AllNumbersScreenState createState() => _AllNumbersScreenState();
}

class _AllNumbersScreenState extends State<AllNumbersScreen> {
  @override
  Widget build(BuildContext context) {
    context.bloc<NumbersBloc>().add(
        NumbersLoadEvent(status: 'all', categoryId: 'все', shouldUpdate: true));

    return BlocBuilder<NumbersBloc, NumbersState>(
      builder: (context, state) {
        if (state is NumbersLoadedState) return _buildLoadedState(state);
        if (state is NumbersInitial)
          context
              .bloc<NumbersBloc>()
              .add(NumbersLoadEvent(status: 'all', categoryId: 'все'));
        return _buildLoadingState(context);
      },
    );
  }

  Widget _buildLoadedState(NumbersLoadedState state) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Все номера'),
        centerTitle: true,
        bottom: MyChoiceChips(
          value: state.category,
          options: state.categories,
          onChanged: (value) {
            context
                .bloc<NumbersBloc>()
                .add(NumbersLoadEvent(categoryId: value, status: 'all'));
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          context
              .bloc<NumbersBloc>()
              .add(NumbersLoadEvent(status: 'all', categoryId: 'все'));
        },
        child: NumbersGrid(
          state: state,
          numbers: state.numbers,
        ),
      ),
      floatingActionButton:
          buildFlatButton('Добавление номера', () => _onAddNumber(state)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  _onAddNumber(NumbersLoadedState state) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddNumberScreen(categories: state.categories),
      ),
    );
  }

  Widget _buildLoadingState(context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
