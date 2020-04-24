part of 'living_bloc.dart';

@immutable
abstract class LivingEvent {}

class LivingLoadEvent extends LivingEvent {}

class LivingAddEvent extends LivingEvent {
  final Living living;
  LivingAddEvent({@required this.living});
}

class LivingDeleteEvent extends LivingEvent {
  final Living living;
  LivingDeleteEvent({@required this.living});
}

class LivingEditEvent extends LivingEvent {
  final Living living;
  LivingEditEvent({@required this.living});
}
