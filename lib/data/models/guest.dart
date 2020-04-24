import 'dart:convert';

class Guest {
  String id;
  String fio;
  String info;
  String phone;
  Guest({
    this.id,
    this.fio,
    this.info,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fio': fio,
      'info': info,
      'phone': phone,
    };
  }

  static Guest fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Guest(
      id: map['id'],
      fio: map['fio'],
      info: map['info'],
      phone: map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  static Guest fromJson(String source) => fromMap(json.decode(source));
}
