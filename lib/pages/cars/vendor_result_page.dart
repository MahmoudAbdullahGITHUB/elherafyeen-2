import 'package:elherafyeen/bloc/home/home_bloc.dart';
import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/pages/cars/vendor_details.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/car_widget.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VendorResultPage extends StatefulWidget {
  CategoryModel category;
  BrandModel brand;
  String searchId;
  double lat;
  double lng;

  VendorResultPage(
      {Key key, this.category, this.brand, this.searchId, this.lng, this.lat})
      : super(key: key);

  @override
  _VendorResultPageState createState() => _VendorResultPageState();
}

class _VendorResultPageState extends State<VendorResultPage> {
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
          widget.category.name,
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
      body: BlocProvider(
        create: (_) => HomeBloc()
          ..add(Search(
              catId: widget.category.id,
              brandId: widget.brand.id,
              lat: widget.lat.toString(),
              lng: widget.lng.toString(),
              searchId: widget.searchId)),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is VendorLoaded)
            return ListView.builder(
              itemCount: state.vendors.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (_) => VendorDetails(
                                  vendor: state.vendors[index],
                                  fetchDetails: 1)));
                    },
                    child: CarWidget(vendor: state.vendors[index]));
              },
            );
          else {
            return Container(
              child: Center(
                  child: LoadingIndicator(
                color: HColors.colorPrimaryDark,
              )),
            );
          }
        }),
      ),
    );
  }
}
