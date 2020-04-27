import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hostel_app/data/models/booking.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/models/living.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:hostel_app/data/repositories/repository.dart';
import 'package:meta/meta.dart';

part 'living_event.dart';
part 'living_state.dart';

class LivingBloc extends Bloc<LivingEvent, LivingState> {
  final Repository repository;
  LivingBloc(this.repository);

  @override
  LivingState get initialState => LivingInitial();

  @override
  Stream<LivingState> mapEventToState(
    LivingEvent event,
  ) async* {
    if (event is LivingLoadEvent) yield _mapLoadToState();
    if (event is LivingAddEvent) yield await _mapAddToState(event.living);
    if (event is LivingDeleteEvent) yield await _mapDelToState(event.living);
    if (event is LivingEditEvent) yield await _mapEditToState(event.living);
    if (event is LivingAddFromBookingEvent)
      yield await _mapAddFromBookingToState(event.booking);
  }

  Future<LivingState> _mapAddFromBookingToState(Booking model) async {
    Living newone = Living(
        arriving: model.arriving,
        leaving: model.leaving,
        guest: model.guest,
        number: model.number);

    bool isAdded = await this.repository.add<Living>(newone);
    if (isAdded) {
      this.repository.living.add(newone);
    } else
      return LivingErrorState(
          message: 'Не удалось добавить,проверьте интернет соединение!');

    return LivingLoaded(
      living: this.repository.living,
      numbers: this.repository.numbers,
      guests: this.repository.guests,
    );
  }

  Future<LivingState> _mapEditToState(Living model) async {
    // TODO bool isFreeNumber = _isFreeNumber(model);

    // if (true) {
    bool isEdited = await this.repository.edit<Living>(model);
    if (isEdited) {
      this.repository.living.removeWhere((l) => l.id == model.id);
      this.repository.living.add(model);
    } else
      return LivingErrorState(
          message: 'Не удалось добавить,проверьте интернет соединение!');
    // } else
    //   return LivingErrorState(message: 'Выбранный номер занят!');
    return LivingLoaded(
      living: this.repository.living,
      numbers: this.repository.numbers,
      guests: this.repository.guests,
    );
  }

  Future<LivingState> _mapDelToState(Living model) async {
    bool isDeleted = await this.repository.delete<Living>(model);
    if (isDeleted) {
      this.repository.living.removeWhere((l) => l.id == model.id);
    } else
      return LivingErrorState(
          message: 'Не удалось удалить,проверьте интернет соединение!');
    return LivingLoaded(
      living: this.repository.living,
      numbers: this.repository.numbers,
      guests: this.repository.guests,
    );
  }

  Future<LivingState> _mapAddToState(Living model) async {
    bool isFreeNumber = _isFreeNumber(model);
    if (isFreeNumber) {
      bool isAdded = await this.repository.add<Living>(model);
      if (isAdded) {
        this.repository.living.add(model);
      } else
        return LivingErrorState(
            message: 'Не удалось добавить,проверьте интернет соединение!');
    } else
      return LivingErrorState(message: 'Выбранный номер занят!');
    return LivingLoaded(
      living: this.repository.living,
      numbers: this.repository.numbers,
      guests: this.repository.guests,
    );
  }

  bool _isFreeNumber(Living model) {
    for (Booking booking in this.repository.booking) {
      if (booking.number == model.number) {
        bool isBefore = model.leaving.isBefore(booking.arriving);
        bool isAfter = model.arriving.isAfter(booking.leaving);
        if (!isBefore && !isAfter) return false;
      }
    }
    for (Living living in this.repository.living) {
      if (living.number == model.number) {
        bool isBefore = model.leaving.isBefore(living.arriving);
        bool isAfter = model.arriving.isAfter(living.leaving);
        if (!isBefore && !isAfter) return false;
      }
    }
    return true;
  }

  LivingState _mapLoadToState() {
    return LivingLoaded(
      living: this.repository.living,
      numbers: this.repository.numbers,
      guests: this.repository.guests,
    );
  }
}
