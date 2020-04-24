part of 'booking_bloc.dart';

@immutable
abstract class BookingState {}

class BookingInitial extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> booking;
  final List<Number> numbers;
  // final List<Category> categories;
  final List<Guest> guests;
  // final String category;

  BookingLoaded({
    @required this.booking,
    @required this.numbers,
    // @required this.categories,
    // @required this.category,
    @required this.guests,
  });
}
