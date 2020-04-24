part of 'numbers_bloc.dart';

@immutable
abstract class NumbersState {}

class NumbersInitial extends NumbersState {}

class NumbersLoadedState extends NumbersState {
  final List<Number> numbers;
  final List<Category> categories;
  final String category;

  NumbersLoadedState({
    @required this.numbers,
    @required this.categories,
    @required this.category,
  });
}

class NumbersBookedLoadedState extends NumbersState {}
