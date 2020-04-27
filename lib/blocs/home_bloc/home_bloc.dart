import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import 'package:hostel_app/data/repositories/repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final Repository repository;
  HomeBloc(this.repository);
  @override
  HomeState get initialState => HomeInitial();

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeInitAll) yield await _mapInitAllToState();
    if (event is HomeInitFromLocal) yield await _mapInitFromLocalToState();
  }

  Future _mapInitFromLocalToState() async {
    FirebaseUser user = await auth.currentUser();
    return HomeInitedState(
      email: user.email,
      allNumbersCount: this.repository.numbers.length,
      livingCount: this.repository.living.length,
      bookingCount: this.repository.booking.length,
      guestsCount: this.repository.guests.length,
    );
  }

  Future<HomeState> _mapInitAllToState() async {
    FirebaseUser user = await auth.currentUser();
    await this.repository.initAll();

    return HomeInitedState(
      email: user.email,
      allNumbersCount: this.repository.numbers.length,
      livingCount: this.repository.living.length,
      bookingCount: this.repository.booking.length,
      guestsCount: this.repository.guests.length,
    );
  }
}
