import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/home_bloc/home_bloc.dart';
import 'package:hostel_app/presentation/screens/guests_screen/guests_screen.dart';
import 'package:hostel_app/presentation/screens/home_screen/components/info_block.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/all_numbers/all_numbers_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/booked_numbers/booked_numbers_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/busy_numbers/busy_numbers_screen.dart';
import 'components/fade_animation.dart';
import 'components/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  static String route = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeInitedState) return _buildInitedState(state, context);
        if (state is HomeInitial) context.bloc<HomeBloc>().add(HomeInitAll());
        return _buildLoadingState();
      },
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget _buildInitedState(HomeInitedState state, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        context.bloc<HomeBloc>().add(HomeInitAll());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Управление гостиницей'),
          centerTitle: true,
        ),
        drawer: MyDrawer(email: state.email, post: ''),
        body: Container(
          child: ListView(
            children: _buildInfoBlocks(state),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildInfoBlocks(HomeInitedState state) {
    return [
      FadeAnimation(
        1,
        InfoBloc(
          count: state.allNumbersCount,
          subtitle: 'количество номеров',
          goTo: AllNumbersScreen.route,
        ),
      ),
      FadeAnimation(
        1.3,
        InfoBloc(
          count: state.guestsCount,
          subtitle: 'количество гостей',
          goTo: GuestsScreen.route,
        ),
      ),
      FadeAnimation(
        1.6,
        InfoBloc(
          count: state.livingCount,
          subtitle: 'поселено',
          goTo: BusyNumbersScreen.route,
        ),
      ),
      FadeAnimation(
        1.9,
        InfoBloc(
          count: state.bookingCount,
          subtitle: 'забронировано',
          goTo: BookedNumbersScreen.route,
        ),
      ),
    ];
  }
}
