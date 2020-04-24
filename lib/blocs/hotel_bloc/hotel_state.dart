part of 'hotel_bloc.dart';

@immutable
abstract class HotelState {}

class HotelInitial extends HotelState {}

class HotelLoadingState extends HotelState {}

class HotelErrorState extends HotelState {
  final String message;
  HotelErrorState({this.message});
}

class HotelReadyState extends HotelState {
  final int numbersCount;
  final int bookedCount;
  final int busyCount;
  final int freeCount;
  final String email;

  HotelReadyState({
    this.numbersCount,
    this.bookedCount,
    this.busyCount,
    this.freeCount,
    this.email,
  });
}
