import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'disable_jobs_page.dart';
import 'jobs_page.dart';

class ApplicantHomePage extends StatefulWidget {
  double lat;
  double lng;

  ApplicantHomePage({Key key, this.lng, this.lat}) : super(key: key);

  @override
  createState() => _ApplicantHomePageState();
}

class _ApplicantHomePageState extends State<ApplicantHomePage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "",
            style: TextStyle(fontSize: 20 * factor, color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelStyle: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(fontSize: 16 * factor, color: Colors.white),
            tabs: [Tab(text: "normal".tr()), Tab(text: "special needs".tr())],
          ),
        ),
        body: TabBarView(
          children: [
            JobsPage(
              lat: widget.lat,
              lng: widget.lng,
            ),
            DisableJobsPage(
              lat: widget.lat,
              lng: widget.lng,
            ),
          ],
        ),
      ),
    );
  }
}
