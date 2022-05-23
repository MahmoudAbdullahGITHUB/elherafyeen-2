import 'dart:async';

import 'package:elherafyeen/models/activity_model.dart';
import 'package:elherafyeen/models/message_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageWidget extends StatefulWidget {
  Function onTap;
  ActivityModel user;
  bool hideMessages;
  MessageWidget({this.onTap, this.user, this.hideMessages: false});

  @override
  State<StatefulWidget> createState() =>
      MessageWidgetState(this.onTap, this.user, this.hideMessages);
}

class MessageWidgetState extends State<MessageWidget> {
  Function onTap;
  ActivityModel user;
  bool hideMessages;
  MessageWidgetState(this.onTap, this.user, this.hideMessages);
  var sendMessages = FirebaseDatabase.instance.reference().child("messages");
  final databaseReference = FirebaseDatabase.instance.reference();
  int myId = int.parse(RegisterModel.shared.id.toString());
  List<Message> items;
  StreamSubscription<Event> _onMessageAddedSubscription;
  StreamSubscription<Event> _onMessageChangedSubscription;
  @override
  void initState() {
    super.initState();

    items = [];
    sendMessages = databaseReference.reference().child("messages");
    sendMessages.keepSynced(true);
    print("mahmud1");

    _onMessageAddedSubscription = sendMessages
        .orderByChild("id")
        .equalTo(keyArrangement())
        .onChildAdded
        .listen(_onMessageAdded);

    _onMessageChangedSubscription =
        sendMessages.onChildChanged.listen(onMessageUpdated);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    double factor = 1;
    final orientation = MediaQuery.of(context).orientation;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;
    return InkWell(
      onTap: onTap,
      child: ListTile(
          leading: user.photo != null && user.photo != ""
              ? ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12 * factor)),
                  child: Image.network(
                    user.photo,
                    height: 55 * factor,
                    width: 55 * factor,
                    fit: BoxFit.cover,
                  ),
                )
              : SizedBox(
                  height: 55 * factor,
                  width: 55 * factor,
                ),
          title: Row(
            children: <Widget>[
              Text(
                user.name,
                style: TextStyle(
                    color: HColors.colorPrimaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 18 * factor),
              ),
              SizedBox(
                width: 16.0,
              ),
            ],
          ),
          subtitle: Text(
            items != null && items.length != 0 ? lastMessage() : user.name,
          ),
          trailing: Column(
            children: [
              Text(
                items.length != 0 ? items[items.length - 1].time : "",
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 6),
              ClipOval(
                child: Container(
                  width: 20 * factor,
                  height: 20 * factor,
                  color: HColors.colorPrimaryDark,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        "1",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }

  String lastMessage() {
    if (items[items.length - 1].message.contains("http"))
      return "photo attached";
    else
      return items[items.length - 1].message;
  }

  String keyArrangement() {
    if (widget.user.id > myId)
      return "${widget.user.id}-$myId";
    else
      return "$myId-${widget.user.id}";
  }

  void _onMessageAdded(Event event) {
    print("mahmud");
    print("mahmoud" + event.snapshot.value.toString());
    print(event.snapshot.value.toString());
    setState(() {
      items.add(new Message.fromSnapshot(event.snapshot));
    });
  }

  void onMessageUpdated(Event event) {
    var oldNoteValue =
        items.singleWhere((note) => note.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldNoteValue)] = new Message.map(event.snapshot);
    });
  }
}
