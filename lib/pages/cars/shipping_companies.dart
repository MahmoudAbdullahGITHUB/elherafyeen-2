import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/cars/vendor_details.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/car_widget.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ShippingCompanies extends StatefulWidget {
  String storeId;
  String name;

  ShippingCompanies({Key key, this.storeId, this.name}) : super();

  @override
  _ShippingCompaniesState createState() => _ShippingCompaniesState();
}

class _ShippingCompaniesState extends State<ShippingCompanies> {
  double latitude;
  double longitude;
  var currentLocation;
  List<VendorModel> vendros = [];

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
    try {
      getCurrentLocation().then((result) {
        longitude = result["longitude"];
        latitude = result["latitude"];
        print("here");
        getVendors();
      });
    } catch (e) {
      print(e.toString());
    }
    super.initState();
  }

  getVendors() async {
    vendros = await HomeApi.getCompaniesByShippingType(
        category_id: widget.storeId,
        lat: latitude.toString(),
        lng: longitude.toString());
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
    var style = Theme.of(context)
        .textTheme
        .headline5
        .copyWith(color: Colors.grey.shade600, fontSize: 16 * factor);

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
        body: (vendros != null && vendros.length != 0)
            ? ListView.builder(
                itemCount: vendros.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => VendorDetails(
                                    vendor: vendros[index], fetchDetails: 1)));
                      },
                      child: CarWidget(vendor: vendros[index]));
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
