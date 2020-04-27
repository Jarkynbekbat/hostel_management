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

  List<Number> numbers = [];
  List<Category> categories = [];
  List<Guest> guests = [];
  List<Booking> booking = [];
  List<Service> services = [];
  List<Living> living = [];

  Repository() {
    _numberProvider = FirestoreProvider(collection: 'numbers');
    _categoryProvider = FirestoreProvider(collection: 'categories');
    _guestProvider = FirestoreProvider(collection: 'guests');
    _bookingProvider = FirestoreProvider(collection: 'booking');
    _serviceProvider = FirestoreProvider(collection: 'services');
    _livingProvider = FirestoreProvider(collection: 'living');
  }

  Future<bool> initAll() async {
    this.numbers = await this.getAll<Number>();
    this.categories = await this.getAll<Category>();
    this.guests = await this.getAll<Guest>();
    this.booking = await this.getAll<Booking>();
    this.living = await this.getAll<Living>();
    return true;
  }

// interface methods
  Future<List<M>> getAll<M>() async {
    try {
      switch (M) {
        case Number:
          return await _getAll<M>(_numberProvider, this.numbers);
        case Category:
          return await _getAll<M>(_categoryProvider, this.categories);
        case Guest:
          return await _getAll<M>(_guestProvider, this.guests);
        case Booking:
          return await _getAll<M>(_bookingProvider, this.booking);
        case Service:
          return await _getAll<M>(_serviceProvider, this.services);
        case Living:
          return await _getAll<M>(_livingProvider, this.living);
      }
      return [];
    } catch (ex) {
      print(ex);
      return [];
    }
  }

  Future<bool> add<M>(model) async {
    switch (M) {
      case Number:
        return await _add<M>(_numberProvider, model);
      case Category:
        return await _add<M>(_categoryProvider, model);
      case Guest:
        return await _add<M>(_guestProvider, model);
      case Booking:
        return await _add<M>(_bookingProvider, model);
      case Service:
        return await _add<M>(_serviceProvider, model);
      case Living:
        return await _add<M>(_livingProvider, model);
    }
    return false;
  }

  Future<bool> edit<M>(model) async {
    switch (M) {
      case Number:
        return await _edit(_numberProvider, model);
      case Category:
        return await _edit(_categoryProvider, model);
      case Guest:
        return await _edit(_guestProvider, model);
      case Booking:
        return await _edit(_bookingProvider, model);
      case Service:
        return await _edit(_serviceProvider, model);
      case Living:
        return await _edit(_livingProvider, model);
    }
    return false;
  }

  Future<bool> delete<M>(model) async {
    switch (M) {
      case Number:
        return await _delete<M>(_numberProvider, model);
      case Category:
        return await _delete<M>(_categoryProvider, model);
      case Guest:
        return await _delete<M>(_guestProvider, model);
      case Booking:
        return await _delete<M>(_bookingProvider, model);
      case Service:
        return await _delete<M>(_serviceProvider, model);
      case Living:
        return await _delete<M>(_livingProvider, model);
    }
    return false;
  }

// template methods
  Future<bool> _add<M>(provider, model) async {
    bool isAdded = await provider.create(model.toMap());
    return isAdded;
  }

  Future<bool> _edit<M>(provider, model) async {
    bool isUpdated = await provider.update(model.toMap());
    return isUpdated;
  }

  Future<bool> _delete<M>(provider, model) async {
    bool isDeleted = await provider.delete(model.id);
    return isDeleted;
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
