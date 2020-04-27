import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:hostel_app/data/models/category.dart';

import 'package:hostel_app/data/models/number.dart';
import 'package:hostel_app/data/repositories/repository.dart';
import 'package:meta/meta.dart';

part 'numbers_event.dart';
part 'numbers_state.dart';

class NumbersBloc extends Bloc<NumbersEvent, NumbersState> {
  final Repository repository;
  NumbersBloc(this.repository);

  @override
  NumbersState get initialState => NumbersInitial();

  @override
  Stream<NumbersState> mapEventToState(
    NumbersEvent event,
  ) async* {
    String category = 'все';
    if (this.repository.categories[0].name != 'все') {
      this.repository.categories.insert(0, Category(name: 'все', id: 'все'));
    }
    if (event is NumbersLoadEvent) yield _mapLoadToState(event, category);
    if (event is NumbersAddEvent) yield await _mapAddToState(event, category);
    if (event is NumbersEditEvent) yield await _mapEditToState(event, category);
    if (event is NumberDeleteEvent) yield await _mapDelToState(event, category);
  }

  Future<NumbersState> _mapDelToState(event, category) async {
    bool isBooked =
        this.repository.booking.map((e) => e.number).contains(event.number.id);
    bool isLiving =
        this.repository.living.map((e) => e.number).contains(event.number.id);
    if (isLiving && isBooked) {
      return NumbersErrorState(
          message:
              'Выбранный номер поселен и забронирован, сначала удалите бронь и выселите гостя!');
    } else if (isLiving || isBooked) {
      if (isBooked)
        return NumbersErrorState(
            message: 'Выбранный номер поселен, сначала выселите гостя!');
      if (isBooked)
        return NumbersErrorState(
            message: 'Выбранный номер забронирован, сначала удалите бронь!');
    } else {
      bool isDeleted = await this.repository.delete<Number>(event.number);
      if (isDeleted)
        this.repository.numbers.removeWhere((n) => n.id == event.number.id);
      else
        return NumbersErrorState(
            message: 'Не удалось удалить! Проверьте интернет соединение');
    }
    return NumbersLoadedState(
      numbers: this.repository.numbers,
      categories: this.repository.categories,
      category: category,
    );
  }

  Future<NumbersState> _mapEditToState(event, category) async {
    bool isExistName =
        this.repository.numbers.map((e) => e.name).contains(event.number.name);

    if (isExistName) {
      return NumbersErrorState(
          message: 'номер с таким названием уже существует!');
    } else {
      bool isEdited = await this.repository.edit<Number>(event.number);
      if (isEdited) {
        this.repository.numbers.removeWhere((el) => el.id == event.number.id);
        this.repository.numbers.add(event.number);
      } else
        return NumbersErrorState(message: 'не удалось изменить название!');
    }
    return NumbersLoadedState(
      numbers: this.repository.numbers,
      categories: this.repository.categories,
      category: category,
    );
  }

  Future<NumbersState> _mapAddToState(event, category) async {
    bool isExistName =
        this.repository.numbers.map((e) => e.name).contains(event.number.name);

    if (isExistName) {
      return NumbersErrorState(
          message: 'номер с таким названием уже существует!');
    } else {
      bool isAdded = await this.repository.add<Number>(event.number);
      if (isAdded)
        this.repository.numbers.add(event.number);
      else
        return NumbersErrorState(message: 'не удалось добавить!');
    }

    return NumbersLoadedState(
      numbers: this.repository.numbers,
      categories: this.repository.categories,
      category: category,
    );
  }

  NumbersState _mapLoadToState(event, category) {
    List<Number> tempNumbers = this.repository.numbers;

    if (event.status == 'free') {
      tempNumbers = this.repository.numbers.where(
        (el) {
          bool isBooked =
              this.repository.booking.contains((b) => b.number == el.id);
          bool isLiving =
              this.repository.living.contains((l) => l.number == el.id);
          return (!isBooked && !isLiving) ? true : false;
        },
      ).toList();
    }
    if (event.categoryId != 'все') {
      category = event.categoryId;
      tempNumbers = this
          .repository
          .numbers
          .where((number) => number.category == category)
          .toList();
      category = event.categoryId;
    }
    return NumbersLoadedState(
      numbers: tempNumbers,
      categories: this.repository.categories,
      category: category,
    );
  }
}
