import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/living_bloc/living_bloc.dart';
import 'components/BusyNumbersList.dart';

class BusyNumbersScreen extends StatefulWidget {
  static String route = 'busy_numbers_screen';
  @override
  _BusyNumbersScreenState createState() => _BusyNumbersScreenState();
}

class _BusyNumbersScreenState extends State<BusyNumbersScreen> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // context.bloc<LivingBloc>().add(LivingLoadEvent());

    return BlocListener<LivingBloc, LivingState>(
      listener: (context, state) {
        if (state is LivingErrorState) {
          _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.bloc<LivingBloc>().add(LivingLoadEvent());
        }
      },
      child: BlocBuilder<LivingBloc, LivingState>(
        builder: (context, state) {
          if (state is LivingLoaded) return _buildLoaded(context, state);
          if (state is LivingInitial)
            context.bloc<LivingBloc>().add(LivingLoadEvent());

          return _buildLoadingState(context);
        },
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, LivingLoaded state) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Поселенные номера'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _onRefresh(context),
        child: BusyNumbersList(
          living: state.living,
          numbers: state.numbers,
          guests: state.guests,
        ),
      ),
    );
  }

  Future _onRefresh(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    context.bloc<LivingBloc>().add(LivingLoadEvent());
  }

  Widget _buildLoadingState(context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
