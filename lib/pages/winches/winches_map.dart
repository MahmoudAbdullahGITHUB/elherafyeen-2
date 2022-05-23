import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/winsh_api.dart';
import 'package:elherafyeen/bloc/winsh/winsh_bloc.dart';
import 'package:elherafyeen/models/user_active_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/chat/messages_page.dart';
import 'package:elherafyeen/pages/winches/winches_items.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_launcher/map_launcher.dart' as launcher;
import 'package:url_launcher/url_launcher.dart';

class WinchesMap extends StatefulWidget {
  WinchesMap({Key key}) : super(key: key);

  @override
  _WinchesMapState createState() => _WinchesMapState();
}

class _WinchesMapState extends State<WinchesMap> {
  BitmapDescriptor pinLocationIcon;
  BitmapDescriptor myPinLocation;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  List<VendorModel> winches = [];
  double latitude;
  double longitude;
  var currentLocation;
  var userActive = FirebaseDatabase.instance.reference().child("users");

  Future<Map<String, double>> getCurrentLocation() async {
    Map<String, double> result = {"latitude": 0.0, "longitude": 0.0};
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      result = {
        "latitude": currentLocation.latitude,
        "longitude": currentLocation.longitude
      };
      print(currentLocation.latitude);
      print(currentLocation.longitude);
      setState(() {
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
      });
    } catch (e) {
      currentLocation = null;
      print("mahmoud" + e.toString());
    }

    return result;
  }

  @override
  void initState() {
    super.initState();
    WinshApi.winchesNum = "";
    getCurrentLocation().then((result) {
      longitude = result["longitude"];
      latitude = result["latitude"];
      setState(() {});
    });
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(12, 12)), 'assets/4.png');
    myPinLocation = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(12, 12), devicePixelRatio: 2.5),
        'assets/1111.png');
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;
    var textStyle =
        TextStyle(color: HColors.colorPrimaryDark, fontSize: 14 * factor);
    Future<Uint8List> getUint8List(GlobalKey markerKey) async {
      RenderRepaintBoundary boundary =
          markerKey.currentContext.findRenderObject();
      var image = await boundary.toImage(pixelRatio: 2.0);
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      return byteData.buffer.asUint8List();
    }

    getUserLocation({List<VendorModel> winches}) async {
      userActive = FirebaseDatabase.instance.reference().child("users");
      print("gemememem");
      try {
        userActive
            .orderByChild("id")
            // .equalTo("${widget.user.id}")
            .once()
            .then((DataSnapshot snapshot) {
          final decoder = const UserActiveDecoder();
          if (snapshot.value != null) {
            decoder.convert(snapshot.value).toList().forEach((item) {
              print("heres good");
              var d = item.lng;

              for (var user in winches) {
                if (user.id == item.id) {
                  user.lat = item.lat;
                  user.lng = item.lng;
                }
              }
            });
          }
        });
        setState(() {});
      } catch (e) {
        print("heres " + e.toString());
      }

      for (var winch in winches) {
        print(",aj" + winch.lat.toString() + winch.lng.toString());
        LatLng pinPositio1n = LatLng(
            double.parse(winch.lat.toString() == "0.00000000"
                ? latitude.toString()
                : winch.lat.toString()),
            double.parse(winch.lng.toString() == "0.00000000"
                ? longitude.toString()
                : winch.lng.toString()));
        _markers.add(Marker(
            markerId: MarkerId('${winch.id}'),
            position: pinPositio1n,
            icon: BitmapDescriptor.fromBytes(await getUint8List(winch.key)),
            onTap: () {
              print("tapped mahmoud");
              mapDetails(textStyle, factor, width, height, winch);
            }));
      }
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${WinshApi.winchesNum ?? ""}- " + "individuals".tr() ?? "",
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (_) => WinchesItems(
                            lat: latitude.toString(),
                            lng: longitude.toString(),
                            company: true,
                            type: "companies".tr(),
                          )));
            },
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0 * factor),
                child: Text(
                  "companies".tr(),
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Colors.white, fontSize: 19 * factor),
                ),
              ),
            ),
          )
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: HColors.colorPrimaryDark,
      ),
      body: latitude == null || latitude == 0
          ? Container(
              child: Center(
                  child: LoadingIndicator(
                color: HColors.colorPrimaryDark,
              )),
            )
          : BlocProvider(
              create: (_) => WinshBloc()
                ..add(LoadWinches(
                    lat: latitude.toString(),
                    lng: longitude.toString(),
                    company: false,
                    page: 1)),
              child:
                  BlocBuilder<WinshBloc, WinshState>(builder: (context, state) {
                LatLng pinPosition = LatLng(latitude, longitude);

                // _markers.add(Marker(
                //     markerId: MarkerId('00'),
                //     position: pinPosition,
                //     icon: myPinLocation));

                // these are the minimum values to set
                // the camera position
                CameraPosition initialLocation =
                    CameraPosition(zoom: 12, bearing: 25, target: pinPosition);

                if (state is WinchesLoadded) {
                  Future.delayed(Duration(seconds: 1), () {
                    getUserLocation(winches: state.winches);
                  });
                  winches = state.winches;
                }

                if (state is LoadWinches)
                  return Container(
                    child: Center(
                        child: LoadingIndicator(
                      color: HColors.colorPrimaryDark,
                    )),
                  );
                if (state is WinshError)
                  return Container(
                    child: Center(
                        child: Text(
                      state.error,
                      style: TextStyle(color: HColors.colorPrimaryDark),
                    )),
                  );
                Widget MarkerIconsPark() {
                  var listOfMarksers = winches.map((winch) {
                    return Stack(
                      children: [
                        RepaintBoundary(
                            key: winch.key,
                            child: ClipOval(
                              child: Container(
                                height: 66 * factor,
                                width: 66 * factor,
                                padding: EdgeInsets.all(2 * factor),
                                color: Colors.white,
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/4.png",
                                    width: 40 * factor,
                                    height: 40 * factor,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    );
                  }).toList();
                  return Stack(children: listOfMarksers);
                }

                return Stack(
                  children: [
                    MarkerIconsPark(),
                    GoogleMap(
                        myLocationEnabled: true,
                        markers: _markers,
                        initialCameraPosition: initialLocation,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                          // setState(() {
                          //   _markers.add(Marker(
                          //       markerId: MarkerId(""),
                          //       position: pinPosition,
                          //       icon: pinLocationIcon));
                          // });
                        }),
                  ],
                );
              }),
            ),
    );
  }

  mapDetails(textStyle, factor, width, height, VendorModel winch) {
    circleIcon({Widget child}) {
      return ClipOval(
          child: Container(
              width: 40 * factor,
              height: 40 * factor,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 1.5 * factor, color: HColors.colorPrimaryDark),
              ),
              child: Center(
                child: child,
              )));
    }

    return showModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.white.withOpacity(0),
        builder: (_) => Card(
            margin: EdgeInsets.only(
                bottom: 60 * factor, right: 12 * factor, left: 12 * factor),
            elevation: 6 * factor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(width * .06))),
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.all(16 * factor),
              height: height * .22,
              child: ListTile(
                leading: Container(
                  width: width * .15,
                  height: height * 1,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0 * factor),
                      child: Image.network(
                        winch.logo,
                        width: width * .15,
                        height: height * 1,
                      )),
                ),
                title: Column(
                  children: [
                    Text(
                      winch.name,
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          fontSize: 20 * factor,
                          color: HColors.colorPrimaryDark),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              circleIcon(
                                  child: IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.mapMarkerAlt,
                                        size: 30 * factor,
                                        color: Colors.deepOrange.shade400,
                                      ),
                                      onPressed: () {
                                        winch.color.contains(Strings.red)
                                            ? showMessage("")
                                            : _launchMapsUrl(
                                                double.parse(winch.lat),
                                                double.parse(winch.lng));
                                      })),
                              Text("map".tr(), style: textStyle)
                            ],
                          ),
                          Column(
                            children: [
                              circleIcon(
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.message,
                                        size: 25 * factor,
                                        color: HColors.colorPrimaryDark,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (_) =>
                                                    MessagesPage(user: winch)));
                                      })),
                              Text("chat".tr(), style: textStyle)
                            ],
                          ),
                          Column(
                            children: [
                              circleIcon(
                                child: IconButton(
                                    icon: Icon(
                                      Icons.call,
                                      color: HColors.colorPrimaryDark,
                                    ),
                                    onPressed: () {
                                      _launchUrl(winch.phone);
                                    }),
                              ),
                              Text("phoneCall".tr(), style: textStyle)
                            ],
                          ),
                          Column(
                            children: [
                              circleIcon(
                                child: IconButton(
                                    icon: Icon(
                                      FontAwesomeIcons.whatsapp,
                                      color: Colors.green,
                                    ),
                                    onPressed: () {
                                      url(winch.whatsapp);
                                    }),
                              ),
                              Text("whatsapp".tr(), style: textStyle)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }

  void _launchUrl(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchMapsUrl(double lat, double lon) async {
    if (await launcher.MapLauncher.isMapAvailable(launcher.MapType.google)) {
      await launcher.MapLauncher.launchMap(
        mapType: launcher.MapType.google,
        coords: launcher.Coords(lat, lon),
        title: "app_name".tr(),
        description: "الحرفيين",
      );
    }
  }

  showMessage(String tr) {
    Fluttertoast.showToast(
        msg: "Denied".tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  url(String phone) async {
    String url = "";
    if (Platform.isAndroid) {
      // add the [https]
      url = "https://wa.me/2$phone/?text=${Uri.parse(" ")}"; // new line
    } else {
      // add the [https]
      url =
          "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(" ")}"; // new line

    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
