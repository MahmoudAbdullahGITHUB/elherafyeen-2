import 'dart:io';

import 'package:badges/badges.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/pages/home/chat_page.dart';
import 'package:elherafyeen/pages/menu/main_drawer.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/login_widget.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
import 'my_cars_page.dart';
import 'notification_page.dart';

class TabBarPage extends StatefulWidget {
  int currentIndex = 0;

  TabBarPage({this.currentIndex: 0});

  @override
  _TabBarPageState createState() => _TabBarPageState(currentIndex);
}

class _TabBarPageState extends State<TabBarPage> {
  int _currentIndex = 0;

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  _TabBarPageState(this._currentIndex);

  final List<Widget> _children = [
    HomePage(),
    MyCarsPage(),
    // CartPage(),
    ChatPage(),
    NotificationPage(),
  ];

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid || Platform.isIOS) {
      // NewVersion(
      //   // dismissText: "later".tr(),
      //   // dialogText: "updateDesc".tr(),
      //   // dialogTitle: "updateTitle".tr(),
      //   // updateText: "update".tr(),
      //   // context: context,
      //   iOSId: '1538364994',
      //   androidId: 'com.elherafyeen.elherafyeen',
      // ).showAlertIfNecessary(context: context);
    }
    loadNotifications();
  }

  loadNotifications() async {
    print("NOTI SHOULD FIRE");
    Strings.notifications = await HomeApi.getNotifications();
    if (Strings.notifications != null && Strings.notifications.isNotEmpty) {
      Strings.showBadgeNotification = true;
      Strings.badgeDataNotification = Strings.notifications.length.toString();
      setState(() {});
    } else {
      Strings.showBadgeNotification = true;
      Strings.badgeDataNotification = "0";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 1.5;
//    if (height > 2040) factor = 3.0;

    final selectedSize = 22.0 * factor;
    final unSelectedSize = 22.0 * factor;

    return CustomeDrawer(
      scaffoldBody: Scaffold(
        key: _scaffoldkey,
        // drawer: MainDrawer(),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey,
          onTap: onTabTapped,
          elevation: 10.0,
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          // this will be set when a new tab is tapped
          items: [
            BottomNavigationBarItem(
              icon: ImageIcon(
                AssetImage("assets/Path 2740.png"),
                size: unSelectedSize,
                color: Colors.grey,
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/Path 2740.png"),
                size: selectedSize,
                color: Theme.of(context).primaryColor,
              ),
              label: "",
              backgroundColor: Colors.white,
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: ImageIcon(
                AssetImage(
                  "assets/Icon awesome-car-alt-5.png",
                ),
                size: unSelectedSize,
                color: Colors.grey,
              ),
              activeIcon: ImageIcon(
                AssetImage(
                  "assets/Icon awesome-car-alt-5.png",
                ),
                size: selectedSize,
                color: Theme.of(context).primaryColor,
              ),
              label: "",
            ),
            // BottomNavigationBarItem(
            //   icon: ImageIcon(
            //     AssetImage("assets/Path 2742.png"),
            //     size: unSelectedSize,
            //     color: Colors.grey,
            //   ),
            //   activeIcon: ImageIcon(
            //     AssetImage("assets/Path 2742.png"),
            //     size: selectedSize,
            //     color: Theme.of(context).primaryColor,
            //   ),
            //   label: "",
            //   backgroundColor: Colors.white,
            // ),
            BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: ImageIcon(
                AssetImage("assets/Group 2606.png"),
                size: unSelectedSize,
                color: Colors.grey,
              ),
              activeIcon: ImageIcon(
                AssetImage("assets/Group 2606.png"),
                size: selectedSize,
                color: Theme.of(context).primaryColor,
              ),
              label: "",
            ),
            BottomNavigationBarItem(
              icon: Badge(
                showBadge: true,
                badgeColor: Colors.redAccent,
                position: BadgePosition.topEnd(top: 0, end: 3),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
                badgeContent: Text(
                  Strings.badgeDataNotification.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: ImageIcon(
                  AssetImage("assets/Path 2741.png"),
                  size: unSelectedSize,
                  color: Colors.grey,
                ),
              ),
              activeIcon: Badge(
                showBadge: true,
                badgeColor: Colors.redAccent,
                position: BadgePosition.topEnd(top: 0, end: 3),
                animationDuration: Duration(milliseconds: 300),
                animationType: BadgeAnimationType.slide,
                badgeContent: Text(
                  Strings.badgeDataNotification.toString(),
                  style: TextStyle(color: Colors.white),
                ),
                child: ImageIcon(
                  AssetImage("assets/Path 2741.png"),
                  size: selectedSize,
                  color: HColors.colorPrimaryDark,
                ),
              ),
              label: "",
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    if (index == 1 || index == 2) {
      if (RegisterModel.shared.token == null ||
          RegisterModel.shared.token == "") {
        showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel:
                MaterialLocalizations.of(context).modalBarrierDismissLabel,
            barrierColor: Colors.black45,
            transitionDuration: const Duration(milliseconds: 200),
            pageBuilder: (BuildContext buildContext, Animation animation,
                Animation secondaryAnimation) {
              return LoginWidget(context);
            });
      } else {
        setState(() {
          _currentIndex = index;
        });
      }
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    return false; // return true if the route to be popped
  }
}
