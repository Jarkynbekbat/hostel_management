import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'package:hostel_app/data/providers/absctract_provider.dart';

class FirestoreProvider extends AbstractProvider {
  final String collection;
  CollectionReference _collectionReference;
  FirestoreProvider({@required this.collection}) {
    this._collectionReference = Firestore.instance.collection(collection);
  }

  @override
  Future<bool> create(Map<String, dynamic> map) async {
    try {
      await this._collectionReference.add(map);
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  @override
  Future<bool> delete(String id) async {
    try {
      await this._collectionReference.document(id).delete();
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  @override
  Future<bool> update(Map<String, dynamic> map) async {
    try {
      await this._collectionReference.document(map['id']).updateData(map);
      return true;
    } catch (ex) {
      print(ex);
      return false;
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAll() async {
    try {
      QuerySnapshot snapshot = await this._collectionReference.getDocuments();
      print('$collection-getAll()');
      return snapshot.documents.map((e) {
        var temp = e.data;
        temp['id'] = e.documentID;
        return temp;
      }).toList();
    } catch (ex) {
      return [];
    }
  }

  @override
  Future<Map<String, dynamic>> getOne(String id) async {
    try {
      DocumentSnapshot document =
          await this._collectionReference.document(id).get();
      return document.data;
    } catch (ex) {
      print(ex);
      var temp;
      temp['name'] = 'не найдено';
      return temp;
    }
  }
}
