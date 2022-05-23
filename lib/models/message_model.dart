import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

// import 'package:hareem/models/UserModel.dart';

import 'activity_model.dart';
// import 'media_model.dart';

class Message {
  String key;
  String id;
  String message;
  String time;
  String read;
  String image;
  String sender;
  String receiver;
  ActivityModel receiverModel;
  ActivityModel senderModel;
  ActivityModel user;
  bool isMine;

  Message.map(dynamic obj) {
    this.key = obj["id"];
    this.id = obj["id"];
    this.message = obj["message"];
    this.sender = obj["sender_id"];
    this.image = obj["image"];
    this.receiver = obj["receiver_id"];
    this.read = obj["read"] ?? "readed";
    // this.time = DateTime.tryParse(obj["time"]);
    this.time = obj["time"];
    this.user = obj["media_user"];
    this.isMine = obj["isMine"] == "1" ? true : false ?? false;
    this.user = obj["media_user"] != null
        ? ActivityModel.fromJson(jsonDecode(obj["media_user"]))
        : null;
    this.receiverModel = obj["receiver"] != null
        ? ActivityModel.fromMap(jsonDecode(obj["receiver"]))
        : null;
    this.senderModel = obj["sender"] != null
        ? ActivityModel.fromMap(jsonDecode(obj["sender"]))
        : null;
  }

  Message.fromSnapshot(DataSnapshot snapshot) {
    this.key = snapshot.key;
    this.id = snapshot.value["id"];
    this.message = snapshot.value["message"];
    this.sender = snapshot.value["sender_id"];
    this.receiver = snapshot.value["receiver_id"];
    this.read = snapshot.value["read"] ?? "readed";
    // this.time = DateTime.tryParse(obj["time"]);
    this.time = snapshot.value["time"];
    this.image = snapshot.value["image"];
    this.user = snapshot.value["media_user"] != null
        ? ActivityModel.fromJson(jsonDecode(snapshot.value["media_user"]))
        : null;
    this.receiverModel = snapshot.value["receiver"] != null
        ? ActivityModel.fromMap(jsonDecode(snapshot.value["receiver"]))
        : null;
    this.senderModel = snapshot.value["sender"] != null
        ? ActivityModel.fromMap(jsonDecode(snapshot.value["sender"]))
        : null;
    this.isMine = snapshot.value["isMine"] == "1" ? true : false ?? false;
  }

  Message(
      this.id,
      this.message,
      this.time,
      this.sender,
      this.read,
      this.receiver,
      this.user,
      this.isMine,
      this.image,
      this.receiverModel,
      this.senderModel);
}

class FirebaseMessagesDecoder extends Converter<Map, Iterable<Message>> {
  const FirebaseMessagesDecoder();

  @override
  Iterable<Message> convert(Map input) {
    return input.keys.map((id) => new Message(
        input[id]['id'].toString(),
        input[id]['message'],
        input[id]["time"],
        input[id]["sender_id"],
        input[id]["readed"],
        input[id]["receiver_id"],
        input[id]["media_user"] != null
            ? ActivityModel.fromJson(jsonDecode(input[id]["media_user"]))
            : null,
        input[id]["isMine"] == "1" ? true : false ?? false,
        input[id]["image"],
        input[id]["receiver"] != null
            ? ActivityModel.fromMap(jsonDecode(input[id]["receiver"]))
            : null,
        input[id]["sender"] != null
            ? ActivityModel.fromMap(jsonDecode(input[id]["sender"]))
            : null));
  }
}
