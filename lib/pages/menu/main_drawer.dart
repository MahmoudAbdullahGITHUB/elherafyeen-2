import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/auth_api.dart';
import 'package:elherafyeen/api/user_api.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/auth/authentication_page.dart';
import 'package:elherafyeen/pages/auth/language_page.dart';
import 'package:elherafyeen/pages/auth/more_auth/vendor_types.dart';
import 'package:elherafyeen/pages/home/search_page.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/pages/menu/more/rules_page.dart';
import 'package:elherafyeen/pages/menu/more/settings_page.dart';
import 'package:elherafyeen/pages/staff/add_staff_page.dart';
import 'package:elherafyeen/pages/staff/employees_page.dart';
import 'package:elherafyeen/pages/staff/unhandeled_vendors_page.dart';
import 'package:elherafyeen/pages/staff/vendors_page.dart';
import 'package:elherafyeen/pages/user/update_captin.dart';
import 'package:elherafyeen/pages/user/update_company.dart';
import 'package:elherafyeen/pages/user/update_merchant.dart';
import 'package:elherafyeen/pages/user/update_vendor.dart';
import 'package:elherafyeen/pages/user/user_info_page.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/crop_image.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/utilities/login_widget.dart';
import 'package:elherafyeen/widgets/image_picker_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

import 'more/phone_list_page.dart';

class CustomeDrawer extends StatelessWidget {
  final Widget scaffoldBody;
  Function onRefresh;

  CustomeDrawer({this.scaffoldBody, this.onRefresh});

  GlobalKey<InnerDrawerState> innerDrawerKey = GlobalKey<InnerDrawerState>();

  void _toggle() {
    innerDrawerKey.currentState.toggle(
        // direction is optional
        // if not set, the last direction will be used
        //InnerDrawerDirection.start OR InnerDrawerDirection.end
        direction: InnerDrawerDirection.start);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var height = MediaQuery.of(context).size.height;
    return InnerDrawer(
      key: innerDrawerKey,
      colorTransitionScaffold: Colors.black54,
      onTapClose: true,
      // default false
      swipe: false,
      colorTransitionChild: Colors.white,
      duration: Duration(milliseconds: 300),
      offset: IDOffset.only(bottom: 0.05, right: 0.2, left: 0.2),
      scale: IDOffset.horizontal(0.8),
      // set the offset in both directions
      proportionalChildArea: true,
      // default true
      borderRadius: 50,
      // default 0
      leftAnimationType: InnerDrawerAnimation.static,
      // default static
      rightAnimationType: InnerDrawerAnimation.quadratic,
      backgroundDecoration: BoxDecoration(
        color: Colors.white,
        // image: DecorationImage(
        //   image: AssetImage(
        //     "assets/images/bg2.png",
        //   ),
        //   fit: BoxFit.cover,
        // ),
      ),
      onDragUpdate: (double val, InnerDrawerDirection direction) {
        print(val);

        print(direction == InnerDrawerDirection.start);
      },
      swipeChild: true,
      tapScaffoldEnabled: false,
      innerDrawerCallback: (a) => print(a),
      leftChild: MainDrawer(),
      // rightChild: menus(context),
      scaffold: Scaffold(
        body: scaffoldBody,
        appBar: AppBar(
          title: Text(
            "appTitle".tr(),
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: HColors.colorPrimaryDark,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _toggle();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(FontAwesomeIcons.qrcode),
              color: Colors.white,
              onPressed: () async {
                String barcodeScanRes = "-1";
                // Platform messages may fail, so we use a try/catch PlatformException.
                try {
                  barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                      "#ff6666", "Cancel", true, ScanMode.BARCODE);
                  print(barcodeScanRes);
                } on PlatformException {
                  barcodeScanRes = 'Failed to get platform version.';
                }

                String result =
                    barcodeScanRes.substring(0, barcodeScanRes.indexOf('/'));

                UserApi.get_user_events(userId: result)
                    .then((List<VendorModel> events) {
                  try {
                    showModalBottomSheet(
                        context: context,
                        barrierColor: Colors.white.withOpacity(0),
                        backgroundColor: Colors.white.withOpacity(0),
                        builder: (_) => Card(
                              margin: EdgeInsets.all(12),
                              color: Colors.white,
                              child: Container(
                                  height: height * .5,
                                  child: ListView.builder(
                                    itemCount: events.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title:
                                            Text(events[index].subscriber_name),
                                        subtitle:
                                            Text(events[index].event_name),
                                      );
                                    },
                                  )),
                            ));
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }
                });
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (builder) => Container(
                            height: MediaQuery.of(context).size.height * .9,
                            child: SearchPage())));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MainDrawer extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainDrawer>
    with SingleTickerProviderStateMixin {
  var image;
  AnimationController _staggeredController;
  var _itemSlideIntervals = [];
  VendorModel user;
  String version = "";
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  final _animationDuration = _initialDelayTime + (_staggerTime * 10);

  @override
  void initState() {
    loadData();
    _staggeredController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  loadData() async {
    try {
      user = await UserApi.getUserData(context: context);
      if (user == null) {
        Fluttertoast.showToast(
            msg:
                "عفوا لقد انتهي صلاحية الدخول من فضلك قم بتسجيل الدخول مرة اخري");
        Navigator.of(context).pushAndRemoveUntil(
            // MaterialPageRoute(builder: (_) => LanguagePage()),
            MaterialPageRoute(builder: (_) => AuthenticationPage()),
            (route) => false);
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg:
              "عفوا لقد انتهي صلاحية الدخول من فضلك قم بتسجيل الدخول مرة اخري");
      Navigator.of(context).pushAndRemoveUntil(
        // MaterialPageRoute(builder: (_) => LanguagePage()),
        MaterialPageRoute(builder: (_) => AuthenticationPage()),
        (route) => false,
      );
    }
    await RegisterModel.shared.getUserData();

    if (user.logo != null && user.logo != "") {
      // image = base64Decode(RegisterModel.shared.image);
    }
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      version = packageInfo.version;
      setState(() {});
    } catch (e) {
      print("," + e);
    }
    setState(() {});
  }

  File _image;
  final picker = ImagePicker();

  Future getImage(bool gallery) async {
    final pickedFile = await picker.getImage(
        source: gallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _image = await CropImageMethod(image: _image);
      setState(() async {
        List<int> imageBytes = _image.readAsBytesSync();
        print(imageBytes);
        final bytes = await _image.readAsBytes();
        var imageString = base64Encode(bytes);
        print(imageString);

        try {
          bool success = await UserApi.updateUserImage(image: imageString);
          if (success)
            errorSnackBar("imageUpdated".tr(), context, success: true);
          image = base64Decode(imageString);
          loadData();
        } catch (e) {
          print("mahmoud" + e.toString());
          errorSnackBar(e.toString(), context);
        }
      });
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  int counter = 0;
  navRoute(typeId) {
    //print("navRoute ${typeId}");
    if (typeId == "2")
      return UpdateVendor();
    else if (typeId == "9")
      return UpdateMerchant();
    else if (typeId == "8")
      return UpdateCompany();
    else if (typeId == "10")
      return UpdateCaptines();
    else
      return UserInfoPage();
  }


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    double factor = 1;


    customDrawerItem({Widget child}) {
      final Animation<double> animation = Tween<double>(begin: 0.0, end: 1.0)
          .animate(CurvedAnimation(
              parent: _staggeredController,
              curve: Interval((1 / 1) * counter, 1.0,
                  curve: Curves.fastOutSlowIn)));
      _staggeredController.forward();

      return SlideTransition(
        position: animation.drive(
            Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0))
                .chain(CurveTween(curve: Curves.ease))),
        child: child,
      );
    }

    var style =
        TextStyle(fontSize: 16 * factor, color: HColors.colorPrimaryDark);
    return Drawer(
      elevation: 0,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Container(
        color: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              // color: Colors.white,
              //   height: user != null &&
              //           user.typeId != null &&
              //           user.typeId != "" &&
              //           user.typeId == "1"
              //       ? 370
              //       : 200 ,
              //   child: DrawerHeader(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  InkWell(
                      onTap: () {
                        if (RegisterModel.shared.token != "") {
                          ImagePickerWidget(
                              context: context,
                              onTap: (value) {
                                getImage(value);
                              });
                        }
                      },
                      child: ClipOval(
                        child:
                            user != null && user.logo != null && user.logo != ""
                                ? Image.network(user.logo,
                                    width: 80 * factor,
                                    height: 70 * factor,
                                    fit: BoxFit.fill)
                                : Image.asset("assets/profile_image.png",
                                    width: 80 * factor,
                                    height: 70 * factor,
                                    fit: BoxFit.fill),
                      )),
                  user != null &&
                          user.typeId != null &&
                          user.typeId != "" &&
                          user.typeId == "1"
                      ? RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => VendorTypes(
                                          idOfStaff: 1,
                                        )));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(width * 0.02))),
                          color: Colors.green,
                          child: Text(
                            "AddNewVendor".tr(),
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ))
                      : SizedBox(),
                  Text(
                    RegisterModel.shared.username ?? "",
                    style: TextStyle(color: HColors.colorPrimaryDark),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    RegisterModel.shared.phone ?? "",
                    style: TextStyle(color: HColors.colorPrimaryDark),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
            ),
            // ),
            RegisterModel.shared.token == null ||
                    RegisterModel.shared.token == ""
                ? SizedBox()
                : customDrawerItem(
                    child: ListTile(
                      selectedTileColor: HColors.colorPrimaryDark,
                      hoverColor: HColors.colorPrimaryDark,
                      focusColor: HColors.colorPrimaryDark,
                      tileColor: Colors.white,
                      title: Row(
                        children: [
                          Text("numOfViews".tr(), style: style),
                          SizedBox(width: 10),
                          Text("${user.visits}", style: style)
                        ],
                      ),
                    ),
                  ),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            RegisterModel.shared.token == null ||
                    RegisterModel.shared.token == ""
                ? SizedBox()
                : customDrawerItem(
                    child: ListTile(
                      selectedTileColor: HColors.colorPrimaryDark,
                      hoverColor: HColors.colorPrimaryDark,
                      focusColor: HColors.colorPrimaryDark,
                      tileColor: Colors.white,
                      title: Text("numList".tr(), style: style),
                      leading:
                          Icon(Icons.person, color: HColors.colorPrimaryDark),
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => PhoneListPage()));
                      },
                    ),
                  ),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            RegisterModel.shared.token == null ||
                    RegisterModel.shared.token == ""
                ? SizedBox()
                : customDrawerItem(
                    child: ListTile(
                      selectedTileColor: HColors.colorPrimaryDark,
                      hoverColor: HColors.colorPrimaryDark,
                      focusColor: HColors.colorPrimaryDark,
                      tileColor: Colors.white,
                      title: Text("profile".tr(), style: style),
                      leading:
                          Icon(Icons.person, color: HColors.colorPrimaryDark),
                      onTap: () {
                        if (RegisterModel.shared.token == null ||
                            RegisterModel.shared.token == "") {
                          goToLogin();
                        } else {
                          ///
                          // if (user.color.contains(Strings.red))
                          //   Fluttertoast.showToast(
                          //       msg: "DeniedUser".tr(),
                          //       toastLength: Toast.LENGTH_LONG,
                          //       gravity: ToastGravity.BOTTOM,
                          //       timeInSecForIosWeb: 1,
                          //       backgroundColor: Colors.red,
                          //       textColor: HColors.colorPrimaryDark,
                          //       fontSize: 16.0);
                          // else

                          print('user.typeId = ${user.typeId}');
                          // return navRoute(user.typeId);

                          Navigator.push(context,
                              CupertinoPageRoute(builder: (_) {
                                // print('token ${RegisterModel.shared.token}');
                                return navRoute(user.typeId);
                              }));
                          // Navigator.push(
                          //     context,
                          //     CupertinoPageRoute(
                          //         builder: (_) =>
                          //         (user.typeId == "2")
                          //             ? UpdateVendor()
                          //             : user.typeId == "9"
                          //                 ? UpdateMerchant()
                          //                 : user.typeId == "8"
                          //                     ? UpdateCompany()
                          //                     : user.typeId == "10"
                          //                         ? UpdateCaptines()
                          //                         : UserInfoPage()
                          //
                          //     ));
                        }
                      },
                    ),
                  ),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            RegisterModel.shared.token != "" &&
                    user != null &&
                    user.roleId != null &&
                    user.roleId != "" &&
                    user.typeId != null &&
                    (user.roleId == "4" || user.roleId == "1") &&
                    user.typeId == "1"
                ? customDrawerItem(
                    child: ListTile(
                      selectedTileColor: HColors.colorPrimaryDark,
                      hoverColor: HColors.colorPrimaryDark,
                      focusColor: HColors.colorPrimaryDark,
                      tileColor: Colors.white,
                      title: Text("addStaff".tr(), style: style),
                      leading:
                          Icon(Icons.person, color: HColors.colorPrimaryDark),
                      onTap: () {
                        if (RegisterModel.shared.token == null ||
                            RegisterModel.shared.token == "") {
                          goToLogin();
                        } else
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => AddStaffPage()));
                      },
                    ),
                  )
                : SizedBox(),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            RegisterModel.shared.token != "" &&
                    user != null &&
                    user.typeId == "1" &&
                    user.roleId != "" &&
                    user.roleId != "5" &&
                    user.roleId != "6"
                ? customDrawerItem(
                    child: ListTile(
                      selectedTileColor: HColors.colorPrimaryDark,
                      hoverColor: HColors.colorPrimaryDark,
                      focusColor: HColors.colorPrimaryDark,
                      tileColor: Colors.white,
                      title: Text("show Employee".tr(), style: style),
                      leading:
                          Icon(Icons.person, color: HColors.colorPrimaryDark),
                      onTap: () {
                        if (RegisterModel.shared.token == null ||
                            RegisterModel.shared.token == "") {
                          goToLogin();
                        } else
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => EmployeesPage(
                                        role: user.roleId,
                                      )));
                      },
                    ),
                  )
                : SizedBox(),

            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            RegisterModel.shared.token != "" &&
                    user != null &&
                    user.typeId == "1"
                ? customDrawerItem(
                    child: ListTile(
                      selectedTileColor: HColors.colorPrimaryDark,
                      hoverColor: HColors.colorPrimaryDark,
                      focusColor: HColors.colorPrimaryDark,
                      tileColor: Colors.white,
                      title: Text("show Vendors".tr(), style: style),
                      leading:
                          Icon(Icons.person, color: HColors.colorPrimaryDark),
                      onTap: () {
                        if (RegisterModel.shared.token == null ||
                            RegisterModel.shared.token == "") {
                          goToLogin();
                        } else
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => VendorsPage(
                                        role: user.roleId,
                                      )));
                      },
                    ),
                  )
                : SizedBox(),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            RegisterModel.shared.token != "" &&
                    user != null &&
                    user.typeId == "1"
                // &&
                // user.roleId != ""
                // (user.roleId == "5" ||
                //     user.roleId == "6")
                ? customDrawerItem(
                    child: ListTile(
                      selectedTileColor: HColors.colorPrimaryDark,
                      hoverColor: HColors.colorPrimaryDark,
                      focusColor: HColors.colorPrimaryDark,
                      tileColor: Colors.white,
                      title: Text("Unhandeld".tr(), style: style),
                      leading:
                          Icon(Icons.person, color: HColors.colorPrimaryDark),
                      onTap: () {
                        if (RegisterModel.shared.token == null ||
                            RegisterModel.shared.token == "") {
                          goToLogin();
                        } else
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => UnHandeleVendorsdPage(
                                        role: user.roleId,
                                      )));
                      },
                    ),
                  )
                : SizedBox(),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            RegisterModel.shared.token == null ||
                    RegisterModel.shared.token == ""
                ? SizedBox()
                : customDrawerItem(
                    child: ListTile(
                      selectedTileColor: HColors.colorPrimaryDark,
                      hoverColor: HColors.colorPrimaryDark,
                      focusColor: HColors.colorPrimaryDark,
                      tileColor: Colors.white,
                      title: Text("myCars".tr(), style: style),
                      leading: Icon(Icons.car_rental,
                          color: HColors.colorPrimaryDark),
                      onTap: () {
                        if (RegisterModel.shared.token == null ||
                            RegisterModel.shared.token == "") {
                          goToLogin();
                        } else {
                          print('pushed TabBarPage');

                          /// beso
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => TabBarPage(currentIndex: 1)),
                          );
                          // Navigator.pushAndRemoveUntil(
                          //     context,
                          //     CupertinoPageRoute(
                          //         builder: (_) => TabBarPage(currentIndex: 1)),
                          //     (route) => false);
                        }
                      },
                    ),
                  ),
            // Divider(
            //   height: 1,
            //   color: HColors.colorPrimaryDark,
            // ),
            // ListTile(
            //   tileColor: Colors.white,
            //   title: Text("myOrders".tr(), style: style),
            //   leading: Icon(Icons.stairs_rounded, color: HColors.colorPrimaryDark),
            //   onTap: () {
            //     // Update the state of the app.
            //     // ...
            //   },
            // ),

            // RegisterModel.shared.token == ""
            //     ? SizedBox()
            //     : ListTile(
            //
            //         tileColor: Colors.white,
            //         title: Text("myFav".tr(), style: style),
            //         leading: Icon(Icons.agriculture_sharp, color: HColors.colorPrimaryDark),
            //         onTap: () {
            //           Navigator.push(context,
            //               CupertinoPageRoute(builder: (_) => FavoritesPage()));
            //         },
            //       ),
            // Divider(
            //   height: 1,
            //   color: HColors.colorPrimaryDark,
            // ),
            // ListTile(
            //
            //   tileColor: Colors.white,
            //   title: Text("aboutApp".tr(), style: style),
            //   leading: Icon(Icons.search, color: HColors.colorPrimaryDark),
            //   onTap: () {
            //     // Update the state of the app.
            //     // ...
            //   },
            // ),
            // Divider(
            //   height: 1,
            //   color: HColors.colorPrimaryDark,
            // ),
            // ListTile(
            //
            //   tileColor: Colors.white,
            //   title: Text("callUs".tr(), style: style),
            //   leading: Icon(Icons.call, color: HColors.colorPrimaryDark),
            //   onTap: () {
            //     Navigator.push(context,
            //         CupertinoPageRoute(builder: (_) => ContactUsPage()));
            //   },
            // ),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            customDrawerItem(
              child: ListTile(
                selectedTileColor: HColors.colorPrimaryDark,
                hoverColor: HColors.colorPrimaryDark,
                focusColor: HColors.colorPrimaryDark,
                tileColor: Colors.white,
                title: Text("settings".tr(), style: style),
                leading: Icon(Icons.settings, color: HColors.colorPrimaryDark),
                onTap: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (_) => SettingsPage()));
                },
              ),
            ),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            RegisterModel.shared.token == null ||
                    RegisterModel.shared.token == ""
                ? SizedBox()
                : customDrawerItem(
                    child: ListTile(
                      selectedTileColor: HColors.colorPrimaryDark,
                      hoverColor: HColors.colorPrimaryDark,
                      focusColor: HColors.colorPrimaryDark,
                      tileColor: Colors.white,
                      title: Text("shareProfile".tr(), style: style),
                      leading:
                          Icon(Icons.share, color: HColors.colorPrimaryDark),
                      onTap: () {
                        if (user.color.contains(Strings.red))
                          Fluttertoast.showToast(
                              msg: "DeniedUser".tr(),
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: HColors.colorPrimaryDark,
                              fontSize: 16.0);
                        else
                          Share.share(
                              'https://elherafyeen.net/profile/${RegisterModel.shared.phone}');
                      },
                    ),
                  ),
            customDrawerItem(
              child: ListTile(
                selectedTileColor: HColors.colorPrimaryDark,
                hoverColor: HColors.colorPrimaryDark,
                focusColor: HColors.colorPrimaryDark,
                tileColor: Colors.white,
                title: Text("shareApp".tr(), style: style),
                leading: Icon(Icons.share, color: HColors.colorPrimaryDark),
                onTap: () {
                  Share.share('https://elherafyeen.net/apps-page');
                },
              ),
            ),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            customDrawerItem(
              child: ListTile(
                selectedTileColor: HColors.colorPrimaryDark,
                hoverColor: HColors.colorPrimaryDark,
                focusColor: HColors.colorPrimaryDark,
                tileColor: Colors.white,
                title: Text("rules".tr(), style: style),
                leading: Icon(Icons.drafts, color: HColors.colorPrimaryDark),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => RulesPage(
                                title: "rules".tr(),
                                text: "rulesPageText".tr(),
                              )));
                },
              ),
            ),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            customDrawerItem(
              child: ListTile(
                selectedTileColor: HColors.colorPrimaryDark,
                hoverColor: HColors.colorPrimaryDark,
                focusColor: HColors.colorPrimaryDark,
                tileColor: Colors.white,
                title: Text("user_agreament_title".tr(), style: style),
                leading: Icon(Icons.drafts, color: HColors.colorPrimaryDark),
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => RulesPage(
                                title: "user_agreament_title".tr(),
                                text: "service_agreement".tr(),
                              )));
                },
              ),
            ),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            RegisterModel.shared.token == null ||
                    RegisterModel.shared.token == ""
                ? customDrawerItem(
                    child: ListTile(
                      selectedTileColor: HColors.colorPrimaryDark,
                      hoverColor: HColors.colorPrimaryDark,
                      focusColor: HColors.colorPrimaryDark,
                      tileColor: Colors.white,
                      title: Text("login".tr(), style: style),
                      leading:
                          Icon(Icons.login, color: HColors.colorPrimaryDark),
                      onTap: () async {
                        Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => AuthenticationPage()),
                            (route) => false);
                      },
                    ),
                  )
                : customDrawerItem(
                    child: ListTile(
                      selectedTileColor: HColors.colorPrimaryDark,
                      hoverColor: HColors.colorPrimaryDark,
                      focusColor: HColors.colorPrimaryDark,
                      tileColor: Colors.white,
                      title: Text("logout".tr(), style: style),
                      leading: Icon(Icons.assignment_return_outlined,
                          color: HColors.colorPrimaryDark),
                      onTap: () async {
                        await AuthApi.logout();
                        await RegisterModel.shared.deleteUserData();
                        await RegisterModel.shared.getUserData();
                        Navigator.pushAndRemoveUntil(
                            context,
                            // CupertinoPageRoute(builder: (_) => LanguagePage()),
                            CupertinoPageRoute(
                                builder: (_) => AuthenticationPage()),
                            (route) => false);
                      },
                    ),
                  ),
            Divider(
              height: 1,
              color: HColors.colorPrimaryDark,
            ),
            SizedBox(
              height: 15 * factor,
            ),
            Container(
              child: Center(
                child: Text(
                  "Version".tr() + ": " + version ?? "",
                  style: TextStyle(color: HColors.colorPrimaryDark),
                ),
              ),
            ),
            SizedBox(
              height: 15 * factor,
            )
          ],
        ),
      ),
    );
  }

  goToLogin() {
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
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }
}
