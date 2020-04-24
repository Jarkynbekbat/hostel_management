import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_app/blocs/booking_bloc/booking_bloc.dart';
import 'components/BookedNumbersList.dart';

class BookedNumbersScreen extends StatefulWidget {
  static String route = 'booked_numbers_screen';
  @override
  _BookedNumbersScreenState createState() => _BookedNumbersScreenState();
}

class _BookedNumbersScreenState extends State<BookedNumbersScreen> {
  @override
  Widget build(BuildContext context) {
    context.bloc<BookingBloc>().add(BookingLoadEvent(categoryId: 'все'));

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingLoaded) return _buildLoaded(context, state);
        if (state is BookingInitial)
          context.bloc<BookingBloc>().add(BookingLoadEvent(categoryId: 'все'));

        return _buildLoadingState(context);
      },
    );
  }

  Widget _buildLoaded(BuildContext context, BookingLoaded state) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Забронированные номера'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async => await _onRefresh(context),
        child: BookedNumbersList(
          booking: state.booking,
          numbers: state.numbers,
          guests: state.guests,
        ),
      ),
    );
  }

  Future _onRefresh(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1));
    context.bloc<BookingBloc>().add(BookingLoadEvent(categoryId: 'все'));
  }

  Widget _buildLoadingState(context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
