part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeInitedState extends HomeState {
  final String email;
  final int allNumbersCount;
  final int livingCount;
  final int bookingCount;
  final int guestsCount;
  // final int freeCount;
  HomeInitedState({
    @required this.email,
    @required this.allNumbersCount,
    @required this.livingCount,
    @required this.bookingCount,
    @required this.guestsCount,
    // @required this.freeCount,
  });
}
