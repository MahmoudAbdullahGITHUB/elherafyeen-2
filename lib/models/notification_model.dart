import 'dart:convert';

import 'package:elherafyeen/models/vendor_model.dart';
import 'package:firebase_database/firebase_database.dart';

class NotificationModel {
  String title;
  String id;
  String phone;
  String image;
  String time;
  String date;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  NotificationModel({
    this.title,
    this.id,
    this.phone,
    this.image,
    this.time,
    this.date,
  });

  NotificationModel copyWith({
    String title,
    String id,
    String phone,
    String image,
  }) {
    return new NotificationModel(
      title: title ?? this.title,
      id: id ?? this.id,
      phone: phone ?? this.phone,
      image: image ?? this.image,
    );
  }

  NotificationModel.fromSnapshot(DataSnapshot snapshot) {
    this.id = snapshot.value["id"];
    this.phone = snapshot.value["phone"];
    this.title = snapshot.value["title"];
    this.image = snapshot.value["image"];
    this.time = snapshot.value["time"];
    this.date = snapshot.value["date"];
  }
  @override
  String toString() {
    return 'NotificationModel{title: $title, id: $id, phone: $phone, image: $image}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          id == other.id &&
          phone == other.phone &&
          image == other.image);

  @override
  int get hashCode =>
      title.hashCode ^ id.hashCode ^ phone.hashCode ^ image.hashCode;

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return new NotificationModel(
      title: map['title'] as String,
      id: map['id'] as String,
      phone: map['phone'] as String,
      image: map['image'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'title': this.title,
      'id': this.id,
      'phone': this.phone,
      'image': this.image,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}

class FirebaseNotificationDecoder extends Converter<Map, Iterable<VendorModel>> {
  const FirebaseNotificationDecoder();

  @override
  Iterable<VendorModel> convert(Map input) {
    return input.keys.map((id) => new VendorModel(
        id:input[id]["id"],
        phone :input[id]["phone"],
    name :input[id]["title"],
    logo : input[id]["image"]));
    // time : input[id]["time"],
    // date : input[id]["date"]));
  }
}
