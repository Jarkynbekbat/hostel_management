import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Living {
  String id;
  String guest;
  String number;
  DateTime arriving;
  DateTime leaving;
  Living({
    this.id,
    this.guest,
    this.number,
    this.arriving,
    this.leaving,
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

  static Living fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Living(
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

  static Living fromJson(String source) => fromMap(json.decode(source));
}
