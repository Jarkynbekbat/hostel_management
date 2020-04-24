import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:hostel_app/data/models/booking.dart';
import 'package:hostel_app/data/models/category.dart';
import 'package:hostel_app/data/models/living.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:hostel_app/data/repositories/repository.dart';
import 'package:meta/meta.dart';

part 'numbers_event.dart';
part 'numbers_state.dart';

class NumbersBloc extends Bloc<NumbersEvent, NumbersState> {
  final Repository _repository;
  NumbersBloc(this._repository);

  @override
  NumbersState get initialState => NumbersInitial();

  @override
  Stream<NumbersState> mapEventToState(
    NumbersEvent event,
  ) async* {
    List<Number> numbers = await this._repository.getAll<Number>();
    List<Category> categories = await this._repository.getAll<Category>();
    List<Booking> booking = await this._repository.getAll<Booking>();
    List<Living> living = await this._repository.getAll<Living>();

    categories.insert(0, Category(id: 'все', name: 'все'));
    String category = 'все';

    if (event is NumbersLoadEvent) {
      if (event.status == 'free') {
        numbers = numbers.where((el) {
          bool isBooked = booking.where((b) => b.number == el.id).length != 0
              ? true
              : false;
          bool isLiving =
              living.where((l) => l.number == el.id).length != 0 ? true : false;

          return (!isBooked && !isLiving) ? true : false;
        }).toList();
      }
      category = event.categoryId;
      if (category != 'все') {
        numbers =
            numbers.where((number) => number.category == category).toList();
      }
      yield NumbersLoadedState(
        numbers: numbers,
        categories: categories,
        category: category,
      );
    }
    if (event is NumbersAddEvent) {
      numbers = await this._repository.add<Number>(event.number);

      yield NumbersLoadedState(
          numbers: numbers, categories: categories, category: category);
    }

    if (event is NumberDeleteEvent) {
      numbers = await this._repository.delete<Number>(event.number);
      yield NumbersLoadedState(
          numbers: numbers, categories: categories, category: category);
    }

    if (event is NumbersEditEvent) {
      numbers = await this._repository.edit<Number>(event.number);
      yield NumbersLoadedState(
          numbers: numbers, categories: categories, category: category);
    }
  }
}
