import 'dart:convert';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:bicolor_icon/bicolor_icon.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_codes/country_codes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/bloc/home/home_bloc.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/pages/cars/cars_categories_page.dart';
import 'package:elherafyeen/pages/cars/cars_page.dart';
import 'package:elherafyeen/pages/cars/merchant_activites_page.dart';
import 'package:elherafyeen/pages/cars/services_types_page.dart';
import 'package:elherafyeen/pages/events/events_page.dart';
import 'package:elherafyeen/pages/winches/winches_map.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/constants.dart';
import 'package:elherafyeen/utilities/shared_preferences.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:rate_my_app/rate_my_app.dart';

import 'applicant_home_page.dart';
import 'outside_maintenence_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  double latitude;
  double longitude;
  var currentLocation;
  bool isEvents = true;
  String address = 'search';
  String countryName = 'search';
  String countryDialCode = '20';

  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    googlePlayIdentifier: "com.elherafyeen.elherafyeen",
    appStoreIdentifier: '1538364994',
    minDays: 1,
    // Show rate popup on first day of install.
    minLaunches:
        4, // Show rate popup after 5 launches of app after minDays is passed.
  );

  var animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    PreferenceUtils.init();

    try {
      showRate();
    } catch (e) {
      print("Elherafyeen" + e.toString());
    }
    if (RegisterModel.shared.id != null && RegisterModel.shared.id != "") {
      OneSignal.shared.setExternalUserId(RegisterModel.shared.id);
    }
    changeLocationForVehicle();
    // Position position = Position(longitude: longitude, latitude: latitude);
    // GetAddressFromLatLong(position);
  }

  changeLocationForVehicle() async {
    isEvents = await HomeApi.getEventsViewable();
    setState(() {});

    await getCurrentLocation();
    if (RegisterModel.shared.id != null && RegisterModel.shared.id != "") {
      if (RegisterModel.shared.type_id == "3") {
        final response = await http.post(
            Uri.parse(Strings.apiLink +
                "update_location?lang=${RegisterModel.shared.lang}"),
            body: {
              "lat": latitude.toString(),
              "lng": longitude.toString(),
            },
            headers: {
              "Authorization": "Bearer " + RegisterModel.shared.token
            });
        final body = json.decode(response.body);
        print("mahmoud" + body.toString());
      }
    }
  }

  Future<Map<String, double>> getCurrentLocation() async {
    Map<String, double> result = {"latitude": 0.0, "longitude": 0.0};
    try {
      currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      print('here we are $currentLocation');
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentLocation.latitude, currentLocation.longitude);
      print(placemarks);
      Placemark place = placemarks[0];
      address =
          'mon address ${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} , ${place.locality}';
      countryName = place.country;

      print('local  $address');

      countryDialCode = await getCountryDialCode();

      print('countryDialCode $countryDialCode');

      result = {
        "latitude": currentLocation.latitude,
        "longitude": currentLocation.longitude
      };
      print('here we are again ${result['latitude']} ${result['longitude']}');

      setState(() {
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
      });
    } catch (e) {
      currentLocation = null;
    }

    return result;
  }

  Future<String> getCountryDialCode() async {
    final item =
        MyConstants.COUNTRIES.firstWhere((e) => e['name'] == '$countryName');
    await PreferenceUtils.setString(
        '${Strings.SPCountryDialCode}', '$countryDialCode');

    return item['dial_code'];
  }

  // Future<void> GetAddressFromLatLong(Position position) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   print(placemarks);
  //   Placemark place = placemarks[0];
  //   address =
  //       'mon address ${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} , ${place.postalCode}';
  //   countryName = place.country;
  // }

  showRate() async {
    Future.delayed(Duration(seconds: 1), () async {
      await rateMyApp.init();
      if (mounted && rateMyApp.shouldOpenDialog) {
        rateMyApp.init().then((_) {
          if (rateMyApp.shouldOpenDialog) {
            rateMyApp.showRateDialog(context,
                title: 'Rate this app'.tr(),
                // The dialog title.
                message: 'like_app'.tr(),
                // The dialog message.
                rateButton: 'RATE'.tr(),
                // The dialog "rate" button text.
                noButton: 'NO THANKS'.tr(),
                // The dialog "no" button text.
                laterButton: 'MAYBE LATER'.tr());
          }
        });
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    Widget showHomeItems(int index, List<CategoryModel> categories) {
      final int count = categories.length + 3;
      final Animation<double> animation =
          Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve:
              Interval((1 / count) * index, 1.0, curve: Curves.fastOutSlowIn),
        ),
      );
      animationController.forward();
      return AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
                opacity: animation,
                child: Transform(
                    transform: Matrix4.translationValues(
                        0.0, 50 * (1.0 - animation.value), 0.0),
                    child: (index == categories.length + 2)
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) => MerchantActivitesPage()));
                            },
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(7))),
                              child: Container(
                                height: height * .17,
                                child: Center(
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: Image.asset(
                                        'assets/store.jpeg',
                                        // width: width * .2,
                                        // height: height * .14,
                                        fit: BoxFit.fill,
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.all(3.0),
                                        child: AutoSizeText(
                                          "store".tr(),
                                          style: TextStyle(
                                              color: HColors.colorPrimary,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                          minFontSize: 10 * factor,
                                          maxLines: 1,
                                          maxFontSize: 22 * factor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : (index == categories.length + 1)
                            ? InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => ApplicantHomePage(
                                                lat: latitude,
                                                lng: longitude,
                                              )));
                                },
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(7))),
                                  child: Container(
                                    // color: Colors.red,
                                    height: height * .17,
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Expanded(
                                              child: Image.asset(
                                            'assets/search_employee.png',
                                            width: width * .2,
                                            height: height * .14,
                                            // fit: BoxFit.fill,
                                          )),
                                          Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: AutoSizeText(
                                              "search_employee".tr(),
                                              style: TextStyle(
                                                  color: HColors.colorPrimary,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                              minFontSize: 10 * factor,
                                              maxLines: 1,
                                              maxFontSize: 22 * factor,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : (index == categories.length)
                                ? InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (_) =>
                                                  MerchantActivitesPage(
                                                    isMedical: true,
                                                  )));
                                    },
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7))),
                                      child: Container(
                                        height: height * .17,
                                        child: Center(
                                          child: Column(
                                            children: [
                                              Expanded(
                                                  child: Image.asset(
                                                'assets/edu.jpg',
                                                width: width * .2,
                                                height: height * .13,
                                              )),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: AutoSizeText(
                                                  "medical_educational".tr(),
                                                  style: TextStyle(
                                                      color:
                                                          HColors.colorPrimary,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                  minFontSize: 4,
                                                  maxLines: 1,
                                                  maxFontSize: 14,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (_) => (index == 0)
                                                    ? CarsCategoriesPage()
                                                    : CarsPage(
                                                        category: categories[
                                                            index - 1],
                                                        store: index ==
                                                                categories
                                                                        .length -
                                                                    2
                                                            ? true
                                                            : false)));
                                      },
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(7))),
                                        child: Container(
                                          height: height * .17,
                                          child: Center(
                                            child: Column(
                                              children: [
                                                Expanded(
                                                    child: index == 0
                                                        ? BicolorIcon(
                                                            iconData:
                                                                FontAwesomeIcons
                                                                    .carSide,
                                                            iconSize:
                                                                height * .1,
                                                            rate: 0.5,
                                                            beginAlignment:
                                                                Alignment
                                                                    .centerLeft,
                                                            beginColor: HColors
                                                                .colorPrimaryDark,
                                                            endColor: HColors
                                                                .colorPrimary)
                                                        : CachedNetworkImage(
                                                            width: width * .2,
                                                            imageUrl:
                                                                categories[
                                                                        index -
                                                                            1]
                                                                    .logo,
                                                            height:
                                                                height * .13,
                                                            // fit: BoxFit.fill,
                                                          )),
                                                Container(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: AutoSizeText(
                                                      index == 0
                                                          ? "car_services".tr()
                                                          : categories[
                                                                  index - 1]
                                                              .name,
                                                      style: TextStyle(
                                                          color: HColors
                                                              .colorPrimary,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      textAlign:
                                                          TextAlign.center,
                                                      minFontSize: 4,
                                                      maxLines: 1,
                                                      maxFontSize: 22,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )));
          });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      floatingActionButton: FabCircularMenu(
          alignment: Alignment.bottomCenter,
          fabSize: 80 * factor,
          fabColor: HColors.colorPrimaryDark,
          ringColor: Colors.blue[200],
          ringDiameter: 365.0 * factor,
          ringWidth: 70.0 * factor,
          fabElevation: 8.0,
          fabIconBorder: CircleBorder(),
          // fabMargin: const EdgeInsets.all(16.0),
          animationDuration: const Duration(milliseconds: 800),
          animationCurve: Curves.bounceIn,
          onDisplayChange: (isOpen) {
            // _showSnackBar(context, "The menu is ${isOpen ? "open" : "closed"}");
          },
          fabOpenIcon: Container(
            height: 88 * factor,
            width: 58 * factor,
            decoration: new BoxDecoration(
              color: HColors.colorPrimaryDark,
              shape: BoxShape.circle,
            ),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/Group 3635.png",
                  height: 42 * factor,
                  width: 50 * factor,
                ),
                FittedBox(
                  child: Text(
                    "saveEmergency".tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),
          children: <Widget>[
            // Column(mainAxisSize: MainAxisSize.min, children: [
            //   Image.asset(
            //     "assets/30.png",
            //     fit: BoxFit.fitHeight,
            //     height: 20 * factor,
            //     width: 40 * factor,
            //   ),
            //   Text(
            //     "محطات بنزين",
            //     style: TextStyle(
            //         fontSize: 14 * factor,
            //         color: HColors.colorPrimaryDark),
            //   ),
            // ]),

            InkWell(
              onTap: () {
                Navigator.push(
                    context, CupertinoPageRoute(builder: (_) => WinchesMap()));
              },
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                // Icon(Icons.looks_one, color: Colors.black),
                Image.asset(
                  "assets/4.png",
                  height: 20 * factor,
                  width: 35 * factor,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  "Crane".tr(),
                  style: TextStyle(
                      fontSize: 14 * factor, color: HColors.colorPrimaryDark),
                ),
              ]),
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => ServiceTypesPage(
                              lat: latitude,
                              lng: longitude,
                            )),
                  );
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Image.asset(
                    "assets/customer.png",
                    height: 20 * factor,
                    width: 35 * factor,
                    fit: BoxFit.fitWidth,
                  ),
                  Text(
                    "my_services".tr(),
                    style: TextStyle(
                        fontSize: 14 * factor, color: HColors.colorPrimaryDark),
                  ),
                ])),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_) => OutsideMaintenancePage(
                            lat: latitude,
                            lng: longitude,
                          )),
                );
              },
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Image.asset(
                  "assets/31.png",
                  height: 20 * factor,
                  width: 35 * factor,
                  fit: BoxFit.fitWidth,
                ),
                Text(
                  "outsideMaintenance".tr(),
                  style: TextStyle(
                      fontSize: 14 * factor, color: HColors.colorPrimaryDark),
                ),
              ]),
            ),
          ]),
      body: BlocProvider(
        create: (_) => HomeBloc()..add(FetchHomeCategories()),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is CategoriesLoaded) {
            return Stack(
              children: [
                Container(
                  // color: Colors.red,
                  height: height,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        // Container(
                        //   height: 80,
                        //   margin: const EdgeInsets.all(16.0),
                        //   decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.all(Radius.circular(7)),
                        //       gradient: LinearGradient(colors: [
                        //         Colors.green,
                        //         Colors.lightGreen,
                        //         Colors.greenAccent,
                        //       ])),
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           CupertinoPageRoute(
                        //               builder: (_) => MyHomePage()));
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //         primary: Colors.transparent,
                        //         shadowColor: Colors.transparent),
                        //     child: Row(
                        //       children: [
                        //         Text(
                        //           ' عروض وخصومات   ',
                        //           style: TextStyle(
                        //               fontSize: 20, fontStyle: FontStyle.italic),
                        //         ),
                        //         SizedBox(width: 50),
                        //         Text(
                        //           'الحرفيين ',
                        //           style: GoogleFonts.reemKufi(
                        //             color: Colors.white,
                        //             fontSize: 35.0,
                        //             decoration: TextDecoration.underline,
                        //             fontWeight: FontWeight.w400,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            child: GridView.count(
                                crossAxisCount: 2,
                                mainAxisSpacing: height * .02,
                                childAspectRatio: 1.5,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                crossAxisSpacing: width * .02,
                                children: List.generate(
                                    state.categories.length + 3, (index) {
                                  return showHomeItems(index, state.categories);
                                })),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => EventsPage()));
                          },
                          child: Visibility(
                            visible: isEvents,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(7))),
                                child: Container(
                                  height: height * .17,
                                  width: width,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                            child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(7),
                                              topRight: Radius.circular(7)),
                                          child: Image.asset(
                                            'assets/event.jpg',
                                            width: width,
                                            // height: height * .14,
                                            fit: BoxFit.fill,
                                          ),
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: AutoSizeText(
                                            "event".tr(),
                                            style: TextStyle(
                                                color: HColors.colorPrimary,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.center,
                                            minFontSize: 10 * factor,
                                            maxLines: 1,
                                            maxFontSize: 22 * factor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Positioned.fill(
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: FabCircularMenu(
                //           alignment: Alignment.bottomCenter,
                //           fabSize: 80 * factor,
                //           fabColor: HColors.colorPrimaryDark,
                //           ringColor: Colors.blue[200],
                //           ringDiameter: 365.0 * factor,
                //           ringWidth: 70.0 * factor,
                //           fabElevation: 8.0,
                //           fabIconBorder: CircleBorder(),
                //           // fabMargin: const EdgeInsets.all(16.0),
                //           animationDuration:
                //               const Duration(milliseconds: 800),
                //           animationCurve: Curves.bounceIn,
                //           onDisplayChange: (isOpen) {
                //             // _showSnackBar(context, "The menu is ${isOpen ? "open" : "closed"}");
                //           },
                //           fabOpenIcon: Container(
                //             height: 88 * factor,
                //             width: 58 * factor,
                //             decoration: new BoxDecoration(
                //               color: HColors.colorPrimaryDark,
                //               shape: BoxShape.circle,
                //             ),
                //             child: Column(
                //               // mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 Image.asset(
                //                   "assets/Group 3635.png",
                //                   height: 42 * factor,
                //                   width: 50 * factor,
                //                 ),
                //                 FittedBox(
                //                   child: Text(
                //                     "saveEmergency".tr(),
                //                     style: TextStyle(
                //                       color: Colors.white,
                //                       fontSize: 11,
                //                       fontWeight: FontWeight.w400,
                //                     ),
                //                     textAlign: TextAlign.center,
                //                   ),
                //                 )
                //               ],
                //             ),
                //           ),
                //           children: <Widget>[
                //             // Column(mainAxisSize: MainAxisSize.min, children: [
                //             //   Image.asset(
                //             //     "assets/30.png",
                //             //     fit: BoxFit.fitHeight,
                //             //     height: 20 * factor,
                //             //     width: 40 * factor,
                //             //   ),
                //             //   Text(
                //             //     "محطات بنزين",
                //             //     style: TextStyle(
                //             //         fontSize: 14 * factor,
                //             //         color: HColors.colorPrimaryDark),
                //             //   ),
                //             // ]),
                //
                //             InkWell(
                //               onTap: () {
                //                 Navigator.push(
                //                     context,
                //                     CupertinoPageRoute(
                //                         builder: (_) => WinchesMap()));
                //               },
                //               child: Column(
                //                   mainAxisSize: MainAxisSize.min,
                //                   children: [
                //                     Image.asset(
                //                       "assets/4.png",
                //                       height: 20 * factor,
                //                       width: 35 * factor,
                //                       fit: BoxFit.fitWidth,
                //                     ),
                //                     Text(
                //                       "Crane".tr(),
                //                       style: TextStyle(
                //                           fontSize: 14 * factor,
                //                           color: HColors.colorPrimaryDark),
                //                     ),
                //                   ]),
                //             ),
                //             InkWell(
                //                 onTap: () {
                //                   Navigator.push(
                //                       context,
                //                     CupertinoPageRoute(builder: (_) => Temp())
                //                       // CupertinoPageRoute(
                //                       //     builder: (_) => ServiceTypesPage(
                //                       //           lat: latitude,
                //                       //           lng: longitude,
                //                       //         ))
                //                     ,);
                //                 },
                //                 child: Column(
                //                     mainAxisSize: MainAxisSize.min,
                //                     children: [
                //                       Image.asset(
                //                         "assets/customer.png",
                //                         height: 20 * factor,
                //                         width: 35 * factor,
                //                         fit: BoxFit.fitWidth,
                //                       ),
                //                       Text(
                //                         "my_services".tr(),
                //                         style: TextStyle(
                //                             fontSize: 14 * factor,
                //                             color: HColors.colorPrimaryDark),
                //                       ),
                //                     ])),
                //             InkWell(
                //               onTap: () {
                //                 Navigator.push(
                //                     context,
                //                     CupertinoPageRoute(
                //                         builder: (_) =>
                //                             OutsideMaintenancePage(
                //                               lat: latitude,
                //                               lng: longitude,
                //                             ))
                //                 ,);
                //               },
                //               child: Column(
                //                   mainAxisSize: MainAxisSize.min,
                //                   children: [
                //                     Image.asset(
                //                       "assets/31.png",
                //                       height: 20 * factor,
                //                       width: 35 * factor,
                //                       fit: BoxFit.fitWidth,
                //                     ),
                //                     Text(
                //                       "outsideMaintenance".tr(),
                //                       style: TextStyle(
                //                           fontSize: 14 * factor,
                //                           color: HColors.colorPrimaryDark),
                //                     ),
                //                   ]),
                //             ),
                //           ]),
                //       /*child: FloatingActionButton(child: Icon(Icons.height),)
                //     */
                //     ),
                //   ),
                // )
              ],
            );
          } else {
            return Container(
              child: Center(
                  child: LoadingIndicator(
                color: HColors.colorPrimaryDark,
              )),
            );
          }
        }),
      ),
      // floatingActionButton: FabCircularMenu(
      //     alignment: Alignment.bottomCenter,
      //     fabSize: 80 * factor,
      //     fabColor: HColors.colorPrimaryDark,
      //     ringColor: Colors.yellow[400],
      //     ringDiameter: 365.0 * factor,
      //     ringWidth: 70.0 * factor,
      //     fabElevation: 8.0,
      //     fabIconBorder: CircleBorder(),
      //     // fabMargin: const EdgeInsets.all(16.0),
      //     animationDuration:
      //     const Duration(milliseconds: 800),
      //     animationCurve: Curves.bounceIn,
      //     onDisplayChange: (isOpen) {
      //       // _showSnackBar(context, "The menu is ${isOpen ? "open" : "closed"}");
      //     },
      //     fabOpenIcon: Container(
      //       height: 88 * factor,
      //       width: 58 * factor,
      //       decoration: new BoxDecoration(
      //         color: HColors.colorPrimaryDark,
      //         shape: BoxShape.circle,
      //       ),
      //       child: Column(
      //         // mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Image.asset(
      //             "assets/Group 3635.png",
      //             height: 42 * factor,
      //             width: 50 * factor,
      //           ),
      //           FittedBox(
      //             child: Text(
      //               "saveEmergency".tr(),
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 11,
      //                 fontWeight: FontWeight.w400,
      //               ),
      //               textAlign: TextAlign.center,
      //             ),
      //           )
      //         ],
      //       ),
      //     ),
      //     children: <Widget>[
      //       // Column(mainAxisSize: MainAxisSize.min, children: [
      //       //   Image.asset(
      //       //     "assets/30.png",
      //       //     fit: BoxFit.fitHeight,
      //       //     height: 20 * factor,
      //       //     width: 40 * factor,
      //       //   ),
      //       //   Text(
      //       //     "محطات بنزين",
      //       //     style: TextStyle(
      //       //         fontSize: 14 * factor,
      //       //         color: HColors.colorPrimaryDark),
      //       //   ),
      //       // ]),
      //
      //       InkWell(
      //         onTap: () {
      //           Navigator.push(
      //               context,
      //               CupertinoPageRoute(
      //                   builder: (_) => WinchesMap()));
      //         },
      //         child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Image.asset(
      //                 "assets/4.png",
      //                 height: 20 * factor,
      //                 width: 35 * factor,
      //                 fit: BoxFit.fitWidth,
      //               ),
      //               Text(
      //                 "Crane".tr(),
      //                 style: TextStyle(
      //                     fontSize: 14 * factor,
      //                     color: HColors.colorPrimaryDark),
      //               ),
      //             ]),
      //       ),
      //       InkWell(
      //           onTap: () {
      //             Navigator.push(
      //                 context,
      //                 CupertinoPageRoute(
      //                     builder: (_) => ServiceTypesPage(
      //                       lat: latitude,
      //                       lng: longitude,
      //                     )));
      //           },
      //           child: Column(
      //               mainAxisSize: MainAxisSize.min,
      //               children: [
      //                 Image.asset(
      //                   "assets/customer.png",
      //                   height: 20 * factor,
      //                   width: 35 * factor,
      //                   fit: BoxFit.fitWidth,
      //                 ),
      //                 Text(
      //                   "my_services".tr(),
      //                   style: TextStyle(
      //                       fontSize: 14 * factor,
      //                       color: HColors.colorPrimaryDark),
      //                 ),
      //               ])),
      //       InkWell(
      //         onTap: () {
      //           Navigator.push(
      //               context,
      //               CupertinoPageRoute(
      //                   builder: (_) =>
      //                       OutsideMaintenancePage(
      //                         lat: latitude,
      //                         lng: longitude,
      //                       )));
      //         },
      //         child: Column(
      //             mainAxisSize: MainAxisSize.min,
      //             children: [
      //               Image.asset(
      //                 "assets/31.png",
      //                 height: 20 * factor,
      //                 width: 35 * factor,
      //                 fit: BoxFit.fitWidth,
      //               ),
      //               Text(
      //                 "outsideMaintenance".tr(),
      //                 style: TextStyle(
      //                     fontSize: 14 * factor,
      //                     color: HColors.colorPrimaryDark),
      //               ),
      //             ]),
      //       ),
      //     ]),
    );
  }
}

/// basic scaffold
