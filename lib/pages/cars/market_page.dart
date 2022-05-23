import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/cars/vendor_details.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/car_widget.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MarketPage extends StatefulWidget {
  String name;

  MarketPage({this.name});

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  double latitude;
  double longitude;
  var currentLocation;
  List<VendorModel> markets = [];

  @override
  void initState() {
    super.initState();
    getMarket();
  }

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

  getMarket() async {
    await getCurrentLocation();
    try {
      markets = await HomeApi.fetchMarkets(
          lat: latitude.toString(), lng: longitude.toString(), page: 1);
    } catch (e) {
      print(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.name,
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: HColors.colorPrimaryDark,
        ),
        body: markets.length != 0
            ? ListView.builder(
                itemCount: markets.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) =>
                                    VendorDetails(vendor: markets[index])));
                      },
                      child: CarWidget(
                        vendor: markets[index],
                        // company: widget.company,
                      ));
                },
              )
            : Container(
                child: Center(
                    child: LoadingIndicator(
                  color: HColors.colorPrimaryDark,
                )),
              ));
  }
}
