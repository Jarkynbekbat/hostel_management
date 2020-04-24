part of 'numbers_bloc.dart';

@immutable
abstract class NumbersEvent {}

class NumbersLoadEvent extends NumbersEvent {
  final String status;
  final String categoryId;
  NumbersLoadEvent({
    @required this.status,
    @required this.categoryId,
  });
}

class NumbersAddEvent extends NumbersEvent {
  final Number number;
  NumbersAddEvent({this.number});
}

class NumbersEditEvent extends NumbersEvent {
  final Number number;
  NumbersEditEvent({this.number});
}

class NumberDeleteEvent extends NumbersEvent {
  final Number number;
  NumberDeleteEvent({this.number});
}
