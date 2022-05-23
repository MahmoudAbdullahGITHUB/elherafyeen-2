import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/pages/auth/login_page.dart';
import 'package:elherafyeen/pages/auth/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthenticationPage extends StatefulWidget {
  AuthenticationPage({Key key}) : super(key: key);

  @override
  _AuthenticationPageState createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  String _phone = '';
  getUserPhone() async {
    if (RegisterModel.shared.sugPhone == null ||
        RegisterModel.shared.sugPhone == "null" ||
        RegisterModel.shared.sugPhone == '') {
      await RegisterModel.shared.getSugNumber();
    }
    _phone = RegisterModel.shared.sugPhone;
    //_phone = ph;
    setState(() {
      //_phone = '98988888';
    });
  }

  @override
  void initState() {
    super.initState();
    getUserPhone();
  }



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
        appBar: AppBar(
          bottom: new PreferredSize(
            preferredSize: new Size(50 * factor, 50 * factor),
            child: TabBar(
              indicatorColor: Colors.white,
              labelStyle: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(fontSize: 18 * factor, color: Colors.white),
              tabs: [Tab(text: "login".tr()), Tab(text: "register".tr())],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            LoginPage(filteredPhone: _phone),
            RegisterPage(),
          ],
        ),
      ),
    );
  }
}
