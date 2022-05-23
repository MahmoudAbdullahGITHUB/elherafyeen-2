import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

class UserActiveModel {
  String id;
  String lat;
  String lng;
  String key;

  UserActiveModel({
    this.key,
    this.id,
    this.lat,
    this.lng,
  });

  factory UserActiveModel.fromMap(Map<String, dynamic> map) {
    return new UserActiveModel(
      key: map['id'] as String,
      id: map['id'] as String,
      lat: map['lat'] as String,
      lng: map['lng'] as String,
    );
  }

  UserActiveModel.fromSnapshot(DataSnapshot snapshot) {
    this.key = snapshot.key;
    this.id = snapshot.value["id"];
    this.lat = snapshot.value["lat"];
    this.lng = snapshot.value["lng"];
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'lat': this.lat,
      'lng': this.lng,
    } as Map<String, dynamic>;
  }
}

class UserActiveDecoder extends Converter<Map, Iterable<UserActiveModel>> {
  const UserActiveDecoder();

  @override
  Iterable<UserActiveModel> convert(Map input) {
    return input.keys.map((id) {
      return new UserActiveModel(
        key: input.keys.toList()[0].toString(),
        id: input[id]['id'].toString(),
        lat: input[id]['lat'],
        lng: input[id]["lng"],
      );
    });
  }
}
