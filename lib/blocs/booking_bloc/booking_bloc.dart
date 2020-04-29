import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hostel_app/data/models/living.dart';
import 'package:meta/meta.dart';
import 'package:hostel_app/data/models/booking.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:hostel_app/data/repositories/repository.dart';

part 'booking_event.dart';
part 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final Repository repository;
  BookingBloc(this.repository);

  @override
  BookingState get initialState => BookingInitial();

  @override
  Stream<BookingState> mapEventToState(
    BookingEvent event,
  ) async* {
    if (event is BookingLoadEvent) yield _mapLoadToState();
    if (event is BookingAddEvent) yield await _mapAddToState(event.booking);
    if (event is BookingDeleteEvent) yield await _mapDelToState(event.booking);
    // if (event is LivingEditEvent) yield await _mapEditToState(event.living);

    // if (event is BookingAddEvent) {
    //   // booking = await this.repository.add<Booking>(event.booking);
    //   yield _bookingLoadToState(booking, numbers, guests);
    // }

    // if (event is BookingDeleteEvent) {
    //   // booking = await this.repository.delete<Booking>(event.booking);
    //   yield _bookingLoadToState(booking, numbers, guests);
    // }
  }

  Future<BookingState> _mapDelToState(Booking model) async {
    bool isDeleted = await this.repository.delete<Booking>(model);
    if (isDeleted) {
      this.repository.booking.removeWhere((b) => b.id == model.id);
    } else
      return BookingErrorState(
          message: 'Не удалось удалить,проверьте интернет соединение!');
    return BookingLoaded(
      booking: this.repository.booking,
      numbers: this.repository.numbers,
      guests: this.repository.guests,
    );
  }

  Future<BookingState> _mapAddToState(Booking model) async {
    bool isFreeNumber = _isFreeNumber(model);
    if (isFreeNumber) {
      bool isAdded = await this.repository.add<Booking>(model);
      if (isAdded) {
        this.repository.booking.add(model);
      } else
        return BookingErrorState(
            message: 'Не удалось добавить,проверьте интернет соединение!');
    } else
      return BookingErrorState(message: 'Выбранный номер занят!');
    return BookingLoaded(
      booking: this.repository.booking,
      numbers: this.repository.numbers,
      guests: this.repository.guests,
    );
  }

  BookingState _mapLoadToState() {
    return BookingLoaded(
      booking: this.repository.booking,
      numbers: this.repository.numbers,
      guests: this.repository.guests,
    );
  }

  bool _isFreeNumber(Booking model) {
    for (Booking booking in this.repository.booking) {
      if (booking.number == model.number) {
        bool isBefore = model.leaving.isBefore(booking.arriving);
        bool isAfter = model.arriving.isAfter(booking.leaving);
        if (!isBefore && !isAfter) return false;
      }
    }
    for (Living living in this.repository.living) {
      if (living.number == model.number) {
        bool isBefore = model.leaving.isBefore(living.arriving);
        bool isAfter = model.arriving.isAfter(living.leaving);
        if (!isBefore && !isAfter) return false;
      }
    }
    return true;
  }
}
