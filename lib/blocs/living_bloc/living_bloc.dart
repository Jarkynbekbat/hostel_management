import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/models/living.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:hostel_app/data/repositories/repository.dart';
import 'package:meta/meta.dart';

part 'living_event.dart';
part 'living_state.dart';

class LivingBloc extends Bloc<LivingEvent, LivingState> {
  final Repository _repository;
  LivingBloc(this._repository);

  @override
  LivingState get initialState => LivingInitial();

  @override
  Stream<LivingState> mapEventToState(
    LivingEvent event,
  ) async* {
    List<Living> living = await _repository.getAll<Living>();
    List<Guest> guests = await this._repository.getAll<Guest>();
    List<Number> numbers = await this._repository.getAll<Number>();

    if (event is LivingLoadEvent) {
      yield LivingLoaded(living: living, numbers: numbers, guests: guests);
    }

    if (event is LivingAddEvent) {
      living = await _repository.add<Living>(event.living);
      yield LivingLoaded(living: living, numbers: numbers, guests: guests);
    }

    if (event is LivingDeleteEvent) {
      living = await _repository.delete<Living>(event.living);
      yield LivingLoaded(living: living, numbers: numbers, guests: guests);
    }

    if (event is LivingEditEvent) {
      living = await _repository.edit<Living>(event.living);
      yield LivingLoaded(living: living, numbers: numbers, guests: guests);
    }
  }
}
