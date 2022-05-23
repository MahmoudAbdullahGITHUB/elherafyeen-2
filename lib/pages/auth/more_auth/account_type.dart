import 'package:auto_size_text/auto_size_text.dart';
import 'package:bicolor_icon/bicolor_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/pages/auth/more_auth/add_marchant.dart';
import 'package:elherafyeen/pages/auth/more_auth/add_store.dart';
import 'package:elherafyeen/pages/auth/more_auth/vendor_types.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../applicant_page.dart';
import '../shipping_page.dart';
import '../winch_page.dart';
import 'add_vehicle_page.dart';

class AccountType extends StatefulWidget {
  int idOfStaff;

  AccountType({Key key, this.idOfStaff: -1}) : super(key: key);

  @override
  _AccountTypeState createState() => _AccountTypeState();
}

class _AccountTypeState extends State<AccountType> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;
    var style = Theme.of(context)
        .textTheme
        .headline1
        .copyWith(fontSize: 22 * factor, color: HColors.colorPrimaryDark);

    return Scaffold(
      backgroundColor: HColors.colorPrimary,
      body: Stack(
        children: [
          Container(
            // color: Colors.red,
            padding: EdgeInsets.all(width * .05),
            child: Center(
                child: Column(
              children: [
                Text("accountType".tr(),
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 25 * factor, color: Colors.white)),
                Divider(
                  color: Colors.white,
                  thickness: 2,
                ),
                SizedBox(height: 25),
                Expanded(
                  child: GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio:
                          MediaQuery.of(context).size.aspectRatio * 3.9 / 3,
                      // 0.7,
                      children: List.generate(9, (index) {
                        return InkWell(
                          onTap: () async {
                            if (index == 0) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => AddMarchantPage(
                                          staff: false, medical: true)));
                            }
                            if (index == 1) {
                              try {
                                var a = await HomeApi.addNormalUser();
                                if (a == true) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => TabBarPage(
                                                currentIndex: 0,
                                              )),
                                      (route) => false);
                                }
                              } catch (e) {
                                Fluttertoast.showToast(msg: e.toString());
                              }
                            }
                            if (index == 2) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => AddVehiclePage()));
                            } else if (index == 3) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => VendorTypes()));
                            } else if (index == 4) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => ApplicantPage()));
                            } else if (index == 5) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => AddMarchantPage()));
                            } else if (index == 6) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => ShippingPage(
                                            staff: false,
                                          )));
                            } else if (index == 7) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => WinchPage(staff: false)));
                            } else if (index == 8) {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => AddStorePage(
                                            staff: widget.idOfStaff == -1
                                                ? false
                                                : true,
                                          )));
                            }
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(height * .012))),
                            child: Container(
                              // color: Colors.red,
                              // width: width * .6,
                              // height: height * .25,
                              padding: EdgeInsets.all(height * .005),
                              child: index == 0
                                  ? Container(
                                      // color: Colors.red,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Image.asset(
                                              "assets/edu.jpg",
                                              height: height * .15,
                                              width: width * .18,
                                              fit: BoxFit.fitWidth,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: AutoSizeText(
                                              "medical_educational".tr(),
                                              style:
                                                  style.copyWith(fontSize: 13),
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : index == 1
                                      ? Column(
                                          children: [
                                            Expanded(
                                                flex: 5,
                                                child: BicolorIcon(
                                                    iconData: Icons.person,
                                                    iconSize: width * .2,
                                                    rate: 0.5,
                                                    beginAlignment:
                                                        Alignment.centerLeft,
                                                    beginColor: HColors
                                                        .colorPrimaryDark,
                                                    endColor:
                                                        HColors.colorPrimary)),
                                            AutoSizeText(
                                              "normal_user".tr(),
                                              style:
                                                  style.copyWith(fontSize: 13),
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        )
                                      : index == 2
                                          ? Column(
                                              children: [
                                                Expanded(
                                                    flex: 5,
                                                    child: BicolorIcon(
                                                        iconData:
                                                            FontAwesomeIcons
                                                                .car,
                                                        iconSize: width * .2,
                                                        rate: 0.5,
                                                        beginAlignment:
                                                            Alignment
                                                                .centerLeft,
                                                        beginColor: HColors
                                                            .colorPrimaryDark,
                                                        endColor: HColors
                                                            .colorPrimary)),
                                                AutoSizeText(
                                                  "carOwner".tr(),
                                                  style: style.copyWith(
                                                      fontSize: 13),
                                                  maxLines: 2,
                                                )
                                              ],
                                            )
                                          : index == 3
                                              ? Container(
                                                  color: Colors.red,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                          flex: 5,
                                                          child: BicolorIcon(
                                                            iconData: Icons
                                                                .person_pin_outlined,
                                                            iconSize:
                                                                width * .2,
                                                            rate: 0.5,
                                                            beginAlignment:
                                                                Alignment
                                                                    .centerLeft,
                                                            beginColor: HColors
                                                                .colorPrimaryDark,
                                                            endColor: HColors
                                                                .colorPrimary,
                                                          )),
                                                      AutoSizeText(
                                                        "vendor".tr(),
                                                        style: style.copyWith(
                                                            fontSize: 13),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : index == 4
                                                  ? Container(
                                                      // color: Colors.red,
                                                      child: Column(
                                                        children: [
                                                          Expanded(
                                                            flex: 5,
                                                            child: Image.asset(
                                                              "assets/headphone.png",
                                                              height:
                                                                  height * .15,
                                                              width:
                                                                  width * .18,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child: AutoSizeText(
                                                              "register_as_employee"
                                                                  .tr(),
                                                              style: style
                                                                  .copyWith(
                                                                      fontSize:
                                                                          13),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : index == 5
                                                      ? Container(
                                                          // color: Colors.red,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    Image.asset(
                                                                  "assets/online-shopping.png",
                                                                  height:
                                                                      height *
                                                                          .15,
                                                                  width: width *
                                                                      .199,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ),
                                                              AutoSizeText(
                                                                "online_dealers"
                                                                    .tr(),
                                                                style: style
                                                                    .copyWith(
                                                                        fontSize:
                                                                            13),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      : index == 6
                                                          ? Container(
                                                              // color: Colors.red,
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 5,
                                                                    child: Image
                                                                        .asset(
                                                                      "assets/Group 3023.png",
                                                                      height:
                                                                          height *
                                                                              .15,
                                                                      width: width *
                                                                          .199,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                    ),
                                                                  ),
                                                                  Divider(
                                                                      height:
                                                                          height *
                                                                              .05),
                                                                  AutoSizeText(
                                                                    "shipping"
                                                                        .tr(),
                                                                    style: style.copyWith(
                                                                        fontSize:
                                                                            13),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          : index == 7
                                                              ? Column(
                                                                  children: [
                                                                    Expanded(
                                                                      child: Image
                                                                          .asset(
                                                                        "assets/4.png",
                                                                        height: height *
                                                                            .15,
                                                                        width: width *
                                                                            .199,
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      ),
                                                                    ),
                                                                    AutoSizeText(
                                                                      "Crane"
                                                                          .tr(),
                                                                      maxLines:
                                                                          2,
                                                                      style: style.copyWith(
                                                                          fontSize:
                                                                              13),
                                                                    )
                                                                  ],
                                                                )
                                                              : Container(
                                                                  width: width *
                                                                      .47,
                                                                  height:
                                                                      height *
                                                                          .25,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Expanded(
                                                                            flex:
                                                                                5,
                                                                            child:
                                                                                Image.asset("assets/6.png")),
                                                                        AutoSizeText(
                                                                          "storeBorrow"
                                                                              .tr(),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              style.copyWith(fontSize: 13),
                                                                          maxLines:
                                                                              2,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            )),
          ),
          // Positioned.fill(
          //     child: Align(
          //         alignment: Alignment.topLeft,
          //         child: Padding(
          //           padding: EdgeInsets.all(30 * factor),
          //           child: InkWell(
          //             onTap: () {
          //               Navigator.pushAndRemoveUntil(
          //                   context,
          //                   CupertinoPageRoute(
          //                       builder: (_) => TabBarPage(
          //                             currentIndex: 0,
          //                           )),
          //                   (route) => false);
          //             },
          //             child: Text("skip".tr(),
          //                 style: Theme.of(context).textTheme.headline1.copyWith(
          //                     fontSize: 16 * factor, color: Colors.white)),
          //           ),
          //         ))),
          Positioned.fill(
              child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(30 * factor),
                    child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  )))
        ],
      ),
    );
  }
}
