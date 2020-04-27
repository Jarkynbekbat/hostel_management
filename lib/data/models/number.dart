import 'dart:convert';

class Number {
  String id;
  int name;
  String category;

  Number({
    this.id,
    this.name,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
    };
  }

  static Number fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Number(
      id: map['id'],
      name: map['name'],
      category: map['category'],
    );
  }

  String toJson() => json.encode(toMap());

  static Number fromJson(String source) => fromMap(json.decode(source));
}
