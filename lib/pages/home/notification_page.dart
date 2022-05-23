import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/notification_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/cars/vendor_details.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  var sendMessages = FirebaseDatabase.instance.reference().child("offers");
  final databaseReference = FirebaseDatabase.instance.reference();
  List<VendorModel> notifications = [];
  double radius = 18;
  StreamSubscription<Event> _onRoomAddedSubscription;
  StreamSubscription<Event> _onRoomChangedSubscription;

  @override
  void initState() {
    sendMessages = databaseReference.reference().child("offers");
    sendMessages.keepSynced(true);
    sendMessages.limitToLast(15).once().then((DataSnapshot snapshot) {
      final decoder = const FirebaseNotificationDecoder();
      decoder.convert(snapshot.value).toList().forEach((item) {
        // var item = new NotificationModel.fromSnapshot(item);
        notifications.add(item);
        notifications = notifications.reversed;
        setState(() {});
      });
    });
    // _onRoomAddedSubscription = sendMessages.onChildAdded.listen(_onRoomAdded);

    // _onRoomChangedSubscription =
    // sendMessages.onChildChanged.listen(onRoomUpdated);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 1.5;
//    if (height > 2040) factor = 3.0;

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("notifications".tr()),
              Divider(
                height: 1,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: Strings.notifications != null &&
                          Strings.notifications.isNotEmpty
                      ? Strings.notifications.length
                      : notifications.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    VendorModel notification = Strings.notifications != null &&
                            Strings.notifications.isNotEmpty
                        ? Strings.notifications[index]
                        : notifications[index];
                    return InkWell(
                      onTap: () {
                        var vendor = new VendorModel(
                          phone: notification.phone,
                          id: notification.id ?? "0",
                        );
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => VendorDetails(
                                      vendor: vendor,
                                      fetchDetails: 1,
                                    )));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.94,
                        child: Card(
                          margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(height * 0.03),
                          ),
                          elevation: 10,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Image.memory(
                                      base64.decode(notification.logo ?? ""),
                                      width: width * .2,
                                      height: height * .16,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
                                          child: Text(
                                            notification.name ?? "",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 10, 0, 0),
                                          child: Text(
                                            notification.title ?? "",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Container(
                                      //   width:
                                      //       MediaQuery.of(context).size.width *
                                      //           0.5,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.fromLTRB(
                                      //         5, 10, 0, 0),
                                      //     child: Text(
                                      //       notification.time +
                                      //           " " +
                                      //           notification.date,
                                      //       style: TextStyle(
                                      //           fontSize: 9,
                                      //           color: Colors.black),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
