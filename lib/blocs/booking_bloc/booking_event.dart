part of 'booking_bloc.dart';

@immutable
abstract class BookingEvent {}

class BookingLoadEvent extends BookingEvent {
  final String categoryId;

  BookingLoadEvent({@required this.categoryId});
}

class BookingAddEvent extends BookingEvent {
  final Booking booking;
  BookingAddEvent({@required this.booking});
}

class BookingDeleteEvent extends BookingEvent {
  final Booking booking;
  BookingDeleteEvent({@required this.booking});
}
