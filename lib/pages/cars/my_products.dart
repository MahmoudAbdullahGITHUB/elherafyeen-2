import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/offer_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProductsPage extends StatefulWidget {
  String userID;

  MyProductsPage({this.userID});

  @override
  _MyProductsPageState createState() => _MyProductsPageState();
}

class _MyProductsPageState extends State<MyProductsPage>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<VendorModel> products = [];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    fetchDetails();
  }

  fetchDetails() async {
    products = await HomeApi.fetchProductsForUser(user_id: widget.userID);
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

    var textStyle = TextStyle(color: Colors.white, fontSize: 15 * factor);

    return Scaffold(
      appBar: AppBar(
          title: Text(
            "myProducts".tr(),
            style: textStyle,
          ),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context))),
      body: products == null
          ? Container(
              child: Center(
                  child: LoadingIndicator(
                color: HColors.colorPrimaryDark,
              )),
            )
          : Container(
              color: Colors.white,
              child: products.isNotEmpty
                  ? new GridView.count(
                      childAspectRatio:
                          MediaQuery.of(context).size.aspectRatio * 3 / 2,
                      crossAxisCount: 2,
                      children: List.generate(
                          products.length,
                          (index) => OfferItem(
                                offer: products[index],
                                edit: true,
                                onDelete: () {
                                  products.removeAt(index);
                                  setState(() {});
                                },
                              )).toList())
                  : SizedBox(),
            ),
    );
  }
}
