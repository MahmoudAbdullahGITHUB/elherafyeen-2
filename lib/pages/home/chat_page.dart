import 'package:elherafyeen/models/activity_model.dart';
import 'package:elherafyeen/models/message_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/chat/messages_page.dart';
import 'package:elherafyeen/widgets/message_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var sendMessages = FirebaseDatabase.instance.reference().child("messages");
  final databaseReference = FirebaseDatabase.instance.reference();

  int myId = int.parse(RegisterModel.shared.id);
  List<ActivityModel> fbList = [];
  double radius = 18;

  @override
  void initState() {
    sendMessages = databaseReference.reference().child("messages");
    sendMessages.keepSynced(true);
    sendMessages.once().then((DataSnapshot snapshot) {
      final decoder = const FirebaseMessagesDecoder();
      decoder.convert(snapshot.value).toList().forEach((item) {
        if (item.id.contains("$myId")) {
          if (item.receiverModel != null && item.receiverModel.id != myId) {
            fbList.add(item.receiverModel);
          } else {
            if (item.senderModel != null) fbList.add(item.senderModel);
          }
        }
        setState(() {});
      });
    });

    // var idSet = <int>{};
    // var distinct = <ActivityModel>[];
    // for (var d in fbList) {
    //   if (idSet.add(d.id)) {
    //     distinct.add(d);
    //   }
    // }

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
    var search = Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(height * .04))),
      elevation: 5,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: TextFormField(
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 11.0),
            decoration: InputDecoration(
                // contentPadding:
                //     new EdgeInsets.symmetric(vertical: 0.0),
                border: InputBorder.none,
                prefixIcon: Padding(
                  padding: EdgeInsets.all(0.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ), // icon is 48px widget.
                ),
                hintText: 'ابحث',
                hintStyle: TextStyle(fontSize: 11.0)),
          ),
        ),
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              search,
              ListView.builder(
                itemCount: fbList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return MessageWidget(
                      user: fbList[index],
                      onTap: () {
                        VendorModel myActivity = new VendorModel();
                        myActivity.name = fbList[index].name;
                        myActivity.id = fbList[index].id.toString();
                        myActivity.logo = fbList[index].photo;
                        myActivity.userId = fbList[index].id.toString();

                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => MessagesPage(
                                      user: myActivity,
                                    )));
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  String keyArrangement(int id) {
    if (id > myId)
      return "$id-$myId";
    else
      return "$myId-$id";
  }
}
