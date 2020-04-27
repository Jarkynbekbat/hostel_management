import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/numbers_bloc/numbers_bloc.dart';

import 'package:hostel_app/presentation/screens/numbers_screen/components/custom_flat_button.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/my_choice_chips.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/components/numbers_grid.dart';

import 'components/add_number_screen.dart';

GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

class AllNumbersScreen extends StatefulWidget {
  static String route = 'all_numbers_screen';
  @override
  _AllNumbersScreenState createState() => _AllNumbersScreenState();
}

class _AllNumbersScreenState extends State<AllNumbersScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<NumbersBloc, NumbersState>(
      listener: (context, state) {
        if (state is NumbersErrorState) _listenErrorState(state);
      },
      child: BlocBuilder<NumbersBloc, NumbersState>(
        builder: (context, state) {
          if (state is NumbersLoadedState) return _buildLoadedState(state);
          if (state is NumbersInitial) _listenInialState(context);

          return _buildLoadingState(context);
        },
      ),
    );
  }

  void _listenInialState(BuildContext context) {
    context.bloc<NumbersBloc>().add(NumbersLoadEvent(categoryId: 'все'));
  }

  void _listenErrorState(NumbersErrorState state) {
    _scaffoldkey.currentState.showSnackBar(
      SnackBar(content: Text(state.message)),
    );
    context.bloc<NumbersBloc>().add(NumbersLoadEvent(categoryId: 'все'));
  }

  Widget _buildLoadedState(NumbersLoadedState state) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        title: Text('Все номера'),
        centerTitle: true,
        bottom: MyChoiceChips(
          value: state.category,
          options: state.categories,
          onChanged: (value) {
            context.bloc<NumbersBloc>().add(NumbersLoadEvent(
                  status: 'все',
                  categoryId: value,
                ));
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          context.bloc<NumbersBloc>().add(
                NumbersLoadEvent(categoryId: 'все'),
              );
        },
        child: NumbersGrid(
          state: state,
          numbers: state.numbers,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddNumber(state),
        child: Icon(Icons.add),
      ),
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
