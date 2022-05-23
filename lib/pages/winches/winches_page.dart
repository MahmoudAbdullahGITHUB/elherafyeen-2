import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/pages/winches/winches_items.dart';
import 'package:elherafyeen/pages/winches/winches_map.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class WinchesPage extends StatefulWidget {
  WinchesPage({Key key}) : super(key: key);

  @override
  _WinchesPageState createState() => _WinchesPageState();
}

class _WinchesPageState extends State<WinchesPage> {
  double latitude;
  double longitude;
  var currentLocation;

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
    getCurrentLocation().then((result) {
      longitude = result["longitude"];
      latitude = result["latitude"];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;
    var style = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: Colors.white, fontSize: 16 * factor);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("winch".tr()),
        backgroundColor: HColors.colorPrimaryDark,
      ),
      body: Container(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) => WinchesMap(
                              // lat: latitude.toString(),
                              // lng: longitude.toString(),
                              // company: true,
                              // type: "individuals".tr(),
                              )));
                },
                child: ClipOval(
                  child: Container(
                    height: 80 * factor,
                    width: 80 * factor,
                    color: HColors.colorPrimaryDark,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(21.0),
                        child: Text("individuals".tr(), style: style),
                      ),
                    ),
                  ),
                ),
              ),
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
                child: ClipOval(
                  child: Container(
                    height: 80 * factor,
                    width: 80 * factor,
                    color: HColors.colorPrimaryDark,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("companies".tr(), style: style),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
