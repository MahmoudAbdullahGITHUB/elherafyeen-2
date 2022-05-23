import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/activity_model.dart';
import 'package:elherafyeen/models/message_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/image_picker_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:octo_image/octo_image.dart';

class MessagesPage extends StatefulWidget {
  VendorModel user;

  MessagesPage({this.user});

  @override
  State<StatefulWidget> createState() => ChatPageState();
}

class ChatPageState extends State<MessagesPage> {
  double radius = 18;
  final databaseReference = FirebaseDatabase.instance.reference();
  var sendMessages = FirebaseDatabase.instance.reference().child("messages");

  List<Message> items;
  StreamSubscription<Event> _onRoomAddedSubscription;
  StreamSubscription<Event> _onRoomChangedSubscription;
  String myId = RegisterModel.shared.id;
  String key;
  var _controller = new TextEditingController();
  final FocusNode _nodeText = FocusNode();
  var _messagesController = new ScrollController();

  String recordingFile;

  bool isRecord = false;

  @override
  void initState() {
    super.initState();

    items = [];
    sendMessages = databaseReference.reference().child("messages");
    sendMessages.keepSynced(true);
    _onRoomAddedSubscription = sendMessages
        .orderByChild("id")
        .equalTo(keyArrangement())
        .onChildAdded
        .listen(_onRoomAdded);

    _onRoomChangedSubscription =
        sendMessages.onChildChanged.listen(onRoomUpdated);
  }

  String keyArrangement() {
    if (int.parse(widget.user.userId) > int.parse(myId))
      return "${widget.user.id}-$myId";
    else
      return "$myId-${widget.user.id}";
  }

  Future<void> _onRoomAdded(Event event) async {
    print("mahmud");
    print(event.snapshot.value.toString());
    setState(() {
      var item = new Message.fromSnapshot(event.snapshot);
      items.add(item);
      items.reversed;
      Timer(
          Duration(milliseconds: 100),
          () => _messagesController
              .jumpTo(_messagesController.position.maxScrollExtent));
    });

    if (int.parse(
            Message.fromSnapshot(event.snapshot).senderModel.id.toString()) !=
        int.parse(RegisterModel.shared.id)) {
      sendMessages
          .child(Message.fromSnapshot(event.snapshot).key.toString())
          .update({
        'read': 'true',
      }).then((value) {
        print("child updated successfully");
      });
    }
  }

  void onRoomUpdated(Event event) {
    var oldNoteValue =
        items.singleWhere((note) => note.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldNoteValue)] =
          new Message.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double factor = 1;
    final orientation = MediaQuery.of(context).orientation;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;
    var timeStyle = TextStyle(fontSize: 9, color: Colors.grey.shade700);
    var profileImage = ClipRRect(
        borderRadius: BorderRadius.circular(8 * factor),
        child: widget.user.logo != ""
            ? Image.network(
                widget.user.logo,
                height: 40 * factor,
                width: 40 * factor,
                fit: BoxFit.cover,
              )
            : SizedBox(
                height: 40 * factor,
                width: 40 * factor,
              ));

    getImageOrVideo(Message message) {
      print("mahmoud image or sound");
      var file = new File(message.message);

      return file != null
          ? Image.file(
              file,
              width: width * .6,
              fit: BoxFit.fill,
              height: height * .2,
            )
          : Image.asset(
              'assets/asset-207.png',
              width: width * .6,
              fit: BoxFit.fill,
              height: height * .2,
            );
    }

    Widget messageMe(Message message) {
      var imageuint;
      if (message.image == "true") imageuint = base64Decode(message.message);

      return Container(
        width: width * 0.7,
        margin: EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.topRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: width * 0.7,
              padding: EdgeInsets.all(8),
              alignment: Alignment.centerRight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(radius),
                    bottomLeft: Radius.circular(radius),
                    topRight: Radius.circular(radius),
                  ),
                  color: HColors.colorPrimaryDark),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    message.image == null || message.image == "false"
                        ? Text(
                            message.message,
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.right,
                          )
                        : Image.memory(
                            imageuint,
                            width: width,
                            height: height * .25,
                            errorBuilder: OctoError.icon(color: Colors.red),
                            fit: BoxFit.fill,
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(message.time ?? "", style: timeStyle),
                        Icon(
                          message.read == "true"
                              ? FontAwesomeIcons.checkDouble
                              : FontAwesomeIcons.check,
                          color: message.read == "true"
                              ? Colors.blue
                              : Colors.grey.shade700,
                          size: 10 * factor,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget messageSmOne(Message message, String image) {
      var imageuint;
      if (message.image == "true") imageuint = base64Decode(message.message);

      return Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        alignment: Alignment.topLeft,
        width: width * 0.75,
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  profileImage,
                  Expanded(
                    child: Container(
                      width: width * 0.75,
                      padding: EdgeInsets.all(8),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            bottomRight: Radius.circular(radius),
                            topRight: Radius.circular(radius),
                          ),
                          color: HColors.colorSecondary),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          message.image == null || message.image == "false"
                              ? Text(
                                  message.message,
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.left,
                                )
                              : Image.memory(
                                  imageuint,
                                  width: width,
                                  height: height * .25,
                                  errorBuilder:
                                      OctoError.icon(color: Colors.red),
                                  fit: BoxFit.fill,
                                ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(message.time ?? "", style: timeStyle),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Row(
            children: [
              Padding(padding: const EdgeInsets.all(4.0), child: profileImage),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.user.name ?? "",
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
            height: height,
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _messagesController,
                      physics: BouncingScrollPhysics(),
                      reverse: false,
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        // var item = items[items.length - 1 - index];
                        var item = items[index];
                        if (item.sender == myId.toString())
                          return messageMe(item);
                        else
                          return messageSmOne(item, "");
                      },
                    ),
                  ),
                  Container(
                    height: height * 0.08,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: height * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(9999.0, 9999.0)),
                              color: Colors.grey.shade300,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        ImagePickerWidget(
                                            context: context,
                                            onTap: (value) {
                                              getImage(value);
                                            });
                                      },
                                      icon: Icon(Icons.camera_alt_rounded,
                                          color: HColors.colorPrimaryDark,
                                          size: 25 * factor)),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: TextFormField(
                                        textInputAction: TextInputAction.done,
                                        controller: _controller,
                                        focusNode: _nodeText,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "typeMessage".tr()),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8 * factor),
                        FloatingActionButton(
                            backgroundColor: HColors.colorPrimaryDark,
                            onPressed: () {
                              sendMessage(_controller.text, false);
                              _nodeText.unfocus();
                            },
                            child: Icon(
                              Icons.send,
                              color: Colors.white,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  sendMessage(String text, bool image) {
    if (image == null) image = false;

    ActivityModel userActivity = new ActivityModel();
    userActivity.name = widget.user.name;
    userActivity.id = int.parse(widget.user.userId);
    userActivity.photo = widget.user.logo;
    userActivity.description = widget.user.name;

    ActivityModel meActivity = new ActivityModel();
    meActivity.name = RegisterModel.shared.username;
    meActivity.id = int.parse(RegisterModel.shared.id);
    meActivity.photo = "";
    meActivity.description = RegisterModel.shared.email;

    if (text.isNotEmpty) {
      sendMessages.push().set(<String, String>{
        "id": keyArrangement(),
        "message": text,
        "sender_id": RegisterModel.shared.id,
        "receiver_id": "${widget.user.id}",
        "sender": jsonEncode(meActivity),
        "read": "false",
        "image": image.toString(),
        "receiver": jsonEncode(userActivity),
        "time": "", //DateFormat.jm().format(DateTime.now()).toString(),
        "date": "" //DateFormat.yMd().format(DateTime.now()).toString()
      });
      _controller.text = "";
      Timer(
        Duration(milliseconds: 100),
        () => _messagesController
            .jumpTo(_messagesController.position.maxScrollExtent),
      );
    }
  }

  File _image;
  var imageString = "";
  final picker = ImagePicker();

  Future getImage(bool gallery) async {
    final pickedFile = await picker.getImage(
        source: gallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      List<int> imageBytes = _image.readAsBytesSync();
      print(imageBytes);
      final bytes = await _image.readAsBytes();
      imageString = base64Encode(bytes);
      sendMessage(imageString, true);
      print(imageString);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }
}
