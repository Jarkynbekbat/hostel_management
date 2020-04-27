part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitAll extends HomeEvent {}

class HomeInitFromLocal extends HomeEvent {}
