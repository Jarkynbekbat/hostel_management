import 'dart:convert';

class Category {
  String name;
  String id;
  int price;
  int rooms;
  String description;

  Category({
    this.id,
    this.name,
    this.price,
    this.rooms,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'id': id,
      'price': price,
      'rooms': rooms,
      'description': description,
    };
  }

  static Category fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Category(
      name: map['name'],
      id: map['id'],
      price: map['price'],
      rooms: map['rooms'],
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  static Category fromJson(String source) => fromMap(json.decode(source));
}
