import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/hotel_bloc/hotel_bloc.dart';
import 'package:hostel_app/presentation/screens/home_screen/components/info_block.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/all_numbers/all_numbers_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/booked_numbers/booked_numbers_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/busy_numbers/busy_numbers_screen.dart';
import 'package:hostel_app/presentation/screens/numbers_screen/free_numbers/free_numbers_screen.dart';
import 'components/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  static String route = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HotelBloc, HotelState>(
      builder: (context, state) {
        if (state is HotelReadyState) return _buildReadyState(state, context);
        if (state is HotelInitial)
          context.bloc<HotelBloc>().add(HotelLoadEvent());
        return _buildLoadingState();
      },
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  Widget _buildReadyState(HotelReadyState state, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(Duration(seconds: 1));
        context.bloc<HotelBloc>().add(HotelLoadEvent());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Гостиница "HAYAT"'),
          centerTitle: true,
          actions: <Widget>[
            DropdownButton(
              icon: Icon(Icons.more_vert),
              items: [],
              onChanged: (index) {},
            )
          ],
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

  List<Widget> _buildInfoBlocks(HotelReadyState state) {
    return [
      InfoBloc(
        count: state.numbersCount,
        subtitle: 'количество номеров',
        goTo: AllNumbersScreen.route,
      ),
      InfoBloc(
        count: state.busyCount,
        subtitle: 'поселено',
        goTo: BusyNumbersScreen.route,
      ),
      InfoBloc(
        count: state.bookedCount,
        subtitle: 'забронировано',
        goTo: BookedNumbersScreen.route,
      ),
      InfoBloc(
        count: state.freeCount,
        subtitle: 'свободно',
        goTo: FreeNumbersScreen.route,
      ),
    ];
  }
}
