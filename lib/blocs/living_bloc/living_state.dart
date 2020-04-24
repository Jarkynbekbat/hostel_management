part of 'living_bloc.dart';

@immutable
abstract class LivingState {}

class LivingInitial extends LivingState {}

class LivingLoaded extends LivingState {
  final List<Living> living;
  final List<Number> numbers;
  final List<Guest> guests;

  LivingLoaded({
    @required this.living,
    @required this.numbers,
    @required this.guests,
  });
}
