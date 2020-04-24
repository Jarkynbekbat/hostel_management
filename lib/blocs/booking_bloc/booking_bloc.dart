import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:hostel_app/data/models/booking.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:hostel_app/data/repositories/repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Repository _repository;
  BookingBloc(this._repository);

  @override
  BookingState get initialState => BookingInitial();

  @override
  Stream<BookingState> mapEventToState(
    BookingEvent event,
  ) async* {
    List<Booking> booking = await this._repository.getAll<Booking>();
    List<Guest> guests = await this._repository.getAll<Guest>();
    List<Number> numbers = await this._repository.getAll<Number>();
    // List<Category> categories = await this._repository.getAll<Category>();

    if (event is BookingLoadEvent)
      yield _bookingLoadToState(booking, numbers, guests);

    if (event is BookingAddEvent) {
      booking = await this._repository.add<Booking>(event.booking);
      yield _bookingLoadToState(booking, numbers, guests);
    }

    if (event is BookingDeleteEvent) {
      booking = await this._repository.delete<Booking>(event.booking);
      yield _bookingLoadToState(booking, numbers, guests);
    }
  }

  BookingLoaded _bookingLoadToState(
      // BookingLoadEvent event,
      List<Booking> booking,
      List<Number> numbers,
      // List<Category> categories,
      List<Guest> guests) {
    // if (event.categoryId != 'все') {
    //   List<Booking> filtredBooking = [];
    //   booking.forEach(
    //     (booked) {
    //       Number number =
    //           numbers.firstWhere((number) => number.id == booked.number);
    //       if (number.category == event.categoryId) filtredBooking.add(booked);
    //     },
    //   );
    //   return BookingLoaded(
    //     booking: filtredBooking,
    //     numbers: numbers,
    //     // categories: categories,
    //     category: event.categoryId,
    //     guests: guests,
    //   );
    // } else {
    return BookingLoaded(
      booking: booking,
      numbers: numbers,
      // categories: categories,
      // category: event.categoryId,
      guests: guests,
    );
    // }
  }
}
