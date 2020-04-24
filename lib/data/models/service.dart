import 'dart:convert';

import 'package:meta/meta.dart';

class Service {
  String id;
  String name;
  int price;

  Service({
    this.id,
    @required this.name,
    @required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }

  static Service fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Service(
      id: map['id'],
      name: map['name'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  static Service fromJson(String source) => fromMap(json.decode(source));
}
