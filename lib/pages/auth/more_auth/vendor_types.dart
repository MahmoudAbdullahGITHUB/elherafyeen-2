import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/pages/auth/more_auth/add_market.dart';
import 'package:elherafyeen/pages/auth/more_auth/add_normal_vendor.dart';
import 'package:elherafyeen/pages/auth/more_auth/add_store.dart';
import 'package:elherafyeen/pages/auth/shipping_page.dart';
import 'package:elherafyeen/pages/auth/winch_page.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_marchant.dart';

class VendorTypes extends StatefulWidget {
  int idOfStaff;

  VendorTypes({Key key, this.idOfStaff: -1}) : super(key: key);

  @override
  _VendorTypesState createState() => _VendorTypesState();
}

class _VendorTypesState extends State<VendorTypes> {
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
        .copyWith(fontSize: 18 * factor, color: HColors.colorPrimary);

    return Scaffold(
      backgroundColor: HColors.colorPrimary,
      appBar: AppBar(
        title: Text("serviceIntroduced".tr(),
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(fontSize: 25 * factor, color: Colors.white)),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Container(
        height: height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              // Spacer(flex: 1),
              Divider(
                color: Colors.white,
                thickness: 2,
              ),
              // Spacer(flex: 1),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => widget.idOfStaff == -1
                              ? AddNormalVendor()
                              : AddNormalVendor(
                                  idOfStaff: widget.idOfStaff,
                                )));
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(height * .02))),
                  child: Container(
                    width: width,
                    height: height * .24,
                    child: Column(
                      children: [
                        Text(
                          "chooseServe".tr(),
                          style: style,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "spareParts".tr(),
                                    style: style,
                                  ),
                                  Image.asset(
                                    "assets/1111.png",
                                    width: width * .08,
                                    height: height * .08,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "fix".tr(),
                                    style: style,
                                  ),
                                  Image.asset(
                                    "assets/icon.png",
                                    width: width * .08,
                                    height: height * .08,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "importedSpareParts".tr(),
                                    style: style,
                                  ),
                                  Image.asset(
                                    "assets/1111.png",
                                    width: width * .08,
                                    height: height * .08,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "accessories".tr(),
                                    style: style,
                                  ),
                                  Image.asset(
                                    "assets/2.png",
                                    width: width * .08,
                                    height: height * .08,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: height * .247,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         CupertinoPageRoute(
                    //             builder: (_) => WinchPage(
                    //                 staff: widget.idOfStaff == -1
                    //                     ? false
                    //                     : true)));
                    //   },
                    //   child: Card(
                    //     elevation: 5,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.all(
                    //             Radius.circular(height * .02))),
                    //     child: Container(
                    //       width: width * .47,
                    //       height: height * .25,
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Column(
                    //           children: [
                    //             Expanded(child: Image.asset("assets/4.png")),
                    //             Text("Crane".tr(), style: style)
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => AddMarketPage(
                                      staff:
                                          widget.idOfStaff == -1 ? false : true,
                                    )));
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(height * .02))),
                        child: Container(
                          width: width * .47,
                          height: height * .25,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Expanded(
                                    child: Image.asset(
                                  "assets/Group 3416.png",
                                  height: height * .1,
                                  width: width * .25,
                                  fit: BoxFit.fill,
                                )),
                                Text(
                                  "market".tr(),
                                  style: style,
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ///
              // Container(
              //   height: height * .247,
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       InkWell(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               CupertinoPageRoute(
              //                   builder: (_) => AddStorePage(
              //                         staff:
              //                             widget.idOfStaff == -1 ? false : true,
              //                       )));
              //         },
              //         child: Card(
              //           elevation: 5,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.all(
              //                   Radius.circular(height * .02))),
              //           child: Container(
              //             width: width * .47,
              //             height: height * .25,
              //             child: Padding(
              //               padding: const EdgeInsets.all(8.0),
              //               child: Column(
              //                 children: [
              //                   Expanded(child: Image.asset("assets/6.png")),
              //                   Text(
              //                     "storeBorrow".tr(),
              //                     style: Theme.of(context)
              //                         .textTheme
              //                         .headline1
              //                         .copyWith(
              //                             fontSize: 15 * factor,
              //                             color: HColors.colorPrimary),
              //                     textAlign: TextAlign.center,
              //                   )
              //                 ],
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       // InkWell(
              //       //   onTap: () {
              //       //     Navigator.push(
              //       //         context,
              //       //         CupertinoPageRoute(
              //       //             builder: (_) => ShippingPage(
              //       //                   staff:
              //       //                       widget.idOfStaff == -1 ? false : true,
              //       //                 )));
              //       //   },
              //       //   child: Card(
              //       //     elevation: 5,
              //       //     shape: RoundedRectangleBorder(
              //       //         borderRadius: BorderRadius.all(
              //       //             Radius.circular(height * .02))),
              //       //     child: Container(
              //       //       width: width * .47,
              //       //       height: height * .25,
              //       //       child: Padding(
              //       //         padding: const EdgeInsets.all(8.0),
              //       //         child: Column(
              //       //           children: [
              //       //             Expanded(
              //       //                 child: Image.asset(
              //       //               "assets/Group 3023.png",
              //       //               height: height * .15,
              //       //             )),
              //       //             AutoSizeText("shipping".tr(), style: style)
              //       //           ],
              //       //         ),
              //       //       ),
              //       //     ),
              //       //   ),
              //       // ),
              //     ],
              //   ),
              // ),
              ///
              // Container(
              //   height: height * .247,
              //   child: Row(
              //     children: [
              //       InkWell(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               CupertinoPageRoute(
              //                   builder: (_) => AddMarchantPage(
              //                       staff: widget.idOfStaff == -1
              //                           ? false
              //                           : true)));
              //         },
              //         child: Card(
              //           elevation: 5,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.all(
              //                   Radius.circular(height * .02))),
              //           child: Container(
              //             height: height * .24,
              //             width: width * .47,
              //             child: Column(
              //               children: [
              //                 Image.asset(
              //                   "assets/online-shopping.png",
              //                   height: height * .15,
              //                   width: width * .199,
              //                   fit: BoxFit.fill,
              //                 ),
              //                 AutoSizeText(
              //                   "online_dealers".tr(),
              //                   style: style,
              //                   textAlign: TextAlign.center,
              //                   minFontSize: 14 * factor,
              //                   maxFontSize: 22 * factor,
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       ),
              //       InkWell(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               CupertinoPageRoute(
              //                   builder: (_) => AddMarchantPage(
              //                       staff:
              //                           widget.idOfStaff == -1 ? false : true,
              //                       medical: true)));
              //         },
              //         child: Card(
              //           elevation: 5,
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.all(
              //                   Radius.circular(height * .02))),
              //           child: Container(
              //             height: height * .24,
              //             width: width * .47,
              //             child: Column(
              //               children: [
              //                 Image.asset(
              //                   "assets/edu.jpg",
              //                   height: height * .15,
              //                   width: width * .199,
              //                   fit: BoxFit.fill,
              //                 ),
              //                 AutoSizeText(
              //                   "medical_educational".tr(),
              //                   style: style,
              //                   textAlign: TextAlign.center,
              //                   minFontSize: 14 * factor,
              //                   maxFontSize: 22 * factor,
              //                 )
              //               ],
              //             ),
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
