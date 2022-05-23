import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'event_details.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key key}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<VendorModel> events = [];

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  loadEvents() async {
    events = await HomeApi.fetchEvents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "event".tr(),
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: HColors.colorPrimaryDark,
      ),
      body: Container(
          padding: EdgeInsets.all(16),
          child: events.isNotEmpty
              ? ListView.builder(
                  itemCount: events.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    var event = events[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => EventDetails(
                                      vendor: event,
                                      fetchDetails: -1,
                                    )));
                      },
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              child: CachedNetworkImage(
                                imageUrl: event.logo,
                                width: width,
                                height: height * .25,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(
                                event.name,
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  child: Center(
                      child: LoadingIndicator(
                    color: HColors.colorPrimaryDark,
                  )),
                )),
    );
  }
}
