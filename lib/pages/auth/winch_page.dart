import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/pages/auth/more_auth/add_company_winsh_page.dart';
import 'package:elherafyeen/pages/auth/more_auth/add_winsh_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WinchPage extends StatefulWidget {
  bool staff;

  WinchPage({Key key, this.staff: false}) : super(key: key);

  @override
  _WinchPageState createState() => _WinchPageState();
}

class _WinchPageState extends State<WinchPage> {
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
            "Crane".tr(),
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
                .copyWith(fontSize: 22 * factor, color: Colors.white),
            tabs: [
              Tab(text: "CraneIndividual".tr()),
              Tab(text: "CraneCompany".tr())
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AddWinshPage(staff: widget.staff),
            AddCompanyWinchPage(staff: widget.staff),
          ],
        ),
      ),
    );
  }
}
