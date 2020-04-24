import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class Booking {
  String id;
  String guest;
  String number;
  DateTime arriving;
  DateTime leaving;
  Booking({
    this.id,
    @required this.guest,
    @required this.number,
    @required this.arriving,
    @required this.leaving,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'guest': guest,
      'number': number,
      'arriving': Timestamp.fromDate(arriving),
      'leaving': Timestamp.fromDate(leaving),
    };
  }

  static Booking fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Booking(
      id: map['id'],
      guest: map['guest'],
      number: map['number'],
      arriving: DateTime.fromMillisecondsSinceEpoch(
          map['arriving'].millisecondsSinceEpoch),
      leaving: DateTime.fromMillisecondsSinceEpoch(
          map['leaving'].millisecondsSinceEpoch),
    );
  }

  String toJson() => json.encode(toMap());

  static Booking fromJson(String source) => fromMap(json.decode(source));
}
