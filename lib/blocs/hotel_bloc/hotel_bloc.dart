import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostel_app/data/models/booking.dart';
import 'package:hostel_app/data/models/living.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:meta/meta.dart';
import 'package:hostel_app/data/repositories/repository.dart';
part 'hotel_event.dart';
part 'hotel_state.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final Repository _repository;
  HotelBloc(this._repository);

  @override
  HotelState get initialState => HotelInitial();
  @override
  Stream<HotelState> mapEventToState(
    HotelEvent event,
  ) async* {
    if (event is HotelLoadEvent) {
      yield await _mapLoad();
    }
  }

  Future<HotelState> _mapLoad() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    List<Number> numbers = await this._repository.getAll<Number>();
    List<Booking> booking = await this._repository.getAll<Booking>();
    List<Living> living = await this._repository.getAll<Living>();
    FirebaseUser user = await auth.currentUser();

    return HotelReadyState(
      email: user.email,
      numbersCount: numbers.length,
      bookedCount: booking.length,
      busyCount: living.length,
      freeCount: numbers.length - (booking.length + living.length),
    );
  }
}
