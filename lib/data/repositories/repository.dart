import 'package:hostel_app/data/models/booking.dart';
import 'package:hostel_app/data/models/category.dart';
import 'package:hostel_app/data/models/guest.dart';
import 'package:hostel_app/data/models/living.dart';
import 'package:hostel_app/data/models/number.dart';
import 'package:hostel_app/data/models/service.dart';
import 'package:hostel_app/data/providers/firestore_provider.dart';

class Repository {
  FirestoreProvider _numberProvider;
  FirestoreProvider _categoryProvider;
  FirestoreProvider _guestProvider;
  FirestoreProvider _bookingProvider;
  FirestoreProvider _serviceProvider;
  FirestoreProvider _livingProvider;

  List<Number> _numbers = [];
  List<Category> _categories = [];
  List<Guest> _guests = [];
  List<Booking> _booking = [];
  List<Booking> _services = [];
  List<Booking> _living = [];

  Repository() {
    _numberProvider = FirestoreProvider(collection: 'numbers');
    _categoryProvider = FirestoreProvider(collection: 'categories');
    _guestProvider = FirestoreProvider(collection: 'guests');
    _bookingProvider = FirestoreProvider(collection: 'booking');
    _serviceProvider = FirestoreProvider(collection: 'services');
    _livingProvider = FirestoreProvider(collection: 'living');
  }

// interface methods

  Future<List<M>> getAll<M>() async {
    try {
      switch (M) {
        case Number:
          return await _getAll<M>(_numberProvider, this._numbers);
        case Category:
          return await _getAll<M>(_categoryProvider, this._categories);
        case Guest:
          return await _getAll<M>(_guestProvider, this._guests);
        case Booking:
          return await _getAll<M>(_bookingProvider, this._booking);
        case Service:
          return await _getAll<M>(_serviceProvider, this._services);
        case Living:
          return await _getAll<M>(_livingProvider, this._living);
      }
      return [];
    } catch (ex) {
      print(ex);
      return [];
    }
  }

  Future<List<M>> add<M>(model) async {
    try {
      switch (M) {
        case Number:
          return await _add<M>(_numberProvider, model, this._numbers);
        case Category:
          return await _add<M>(_categoryProvider, model, this._categories);
        case Guest:
          return await _add<M>(_guestProvider, model, this._guests);
        case Booking:
          return await _add<M>(_bookingProvider, model, this._booking);
        case Service:
          return await _add<M>(_serviceProvider, model, this._services);
        case Living:
          return await _add<M>(_livingProvider, model, this._living);
      }
      return [];
    } catch (ex) {
      print(ex);
      return [];
    }
  }

  Future<List<M>> edit<M>(model) async {
    try {
      switch (M) {
        case Number:
          return await _edit(_numberProvider, model, this._numbers);
        case Category:
          return await _edit(_categoryProvider, model, this._categories);
        case Guest:
          return await _edit(_guestProvider, model, this._guests);
        case Booking:
          return await _edit(_bookingProvider, model, this._booking);
        case Service:
          return await _edit(_serviceProvider, model, this._services);
        case Living:
          return await _edit(_livingProvider, model, this._living);
      }
      return [];
    } catch (ex) {
      print(ex);
      return [];
    }
  }

  Future<List<M>> delete<M>(model) async {
    try {
      switch (M) {
        case Number:
          return await _delete<M>(_numberProvider, model, this._numbers);
        case Category:
          return await _delete<M>(_categoryProvider, model, this._categories);
        case Guest:
          return await _delete<M>(_guestProvider, model, this._guests);
        case Booking:
          return await _delete<M>(_bookingProvider, model, this._booking);
        case Service:
          return await _delete<M>(_serviceProvider, model, this._services);
        case Living:
          return await _delete<M>(_livingProvider, model, this._living);
      }
      return [];
    } catch (ex) {
      print(ex);
      return [];
    }
  }

// template methods
  Future<List<M>> _add<M>(provider, model, array) async {
    bool isAdded = await provider.create(model.toMap());
    return isAdded ? await this.getAll<M>() : array;
  }

  Future<List<M>> _edit<M>(provider, model, array) async {
    bool isDeleted = await provider.update(model.toMap());
    if (isDeleted) {
      // array.removeWhere((el) => el.id == model.id);
      // array.add(model);
      return await this.getAll<M>();
    }
    return array;
  }

  Future<List<M>> _delete<M>(provider, model, array) async {
    bool isDeleted = await provider.delete(model.id);
    // if (isDeleted) {
    //   array.removeWhere((el) => el.id == model.id);
    // }
    // return array;
    if (isDeleted) {
      return await this.getAll<M>();
    }
    return array;
  }

  Future<List<M>> _getAll<M>(provider, array) async {
    List<dynamic> maps = await provider.getAll();
    array = maps.map((e) => _mapToModel<M>(e)).toList();
    return array;
  }

// backgraund methods
  M _mapToModel<M>(Map<String, dynamic> map) {
    if (M == Number) return Number.fromMap(map) as M;
    if (M == Category) return Category.fromMap(map) as M;
    if (M == Guest) return Guest.fromMap(map) as M;
    if (M == Booking) return Booking.fromMap(map) as M;
    if (M == Service) return Service.fromMap(map) as M;
    if (M == Living) return Living.fromMap(map) as M;
    return null;
  }
}
