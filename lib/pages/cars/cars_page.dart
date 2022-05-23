import 'package:elherafyeen/bloc/home/home_bloc.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/search_model.dart';
import 'package:elherafyeen/pages/cars/market_page.dart';
import 'package:elherafyeen/pages/cars/shipping_captines.dart';
import 'package:elherafyeen/pages/cars/shipping_companies.dart';
import 'package:elherafyeen/pages/cars/store_vendors.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/rounded_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'category_page.dart';

class CarsPage extends StatefulWidget {
  CategoryModel category;
  bool store;

  CarsPage({Key key, this.category, this.store}) : super(key: key);

  @override
  _CarsPageState createState() => _CarsPageState();
}

class _CarsPageState extends State<CarsPage> with TickerProviderStateMixin {
  AnimationController animationController;
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
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
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
        .copyWith(color: Colors.black, fontSize: 16 * factor);

    var space = SizedBox(
      height: height * .03,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HColors.colorPrimaryDark,
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
      ),
      body: BlocProvider(
        create: (_) => HomeBloc()
          ..add(FetchVendorsToSearchWith(categoryId: widget.category.id)),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is VendrosToSearchWith) {
            navigateToPage(List<SearchModel> searches, int index) async {
              await getCurrentLocation();
              var search = searches[index];
              if (searches.length == 2 || searches.length == 3) {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => index == 2
                            ? ShippingCaptines(
                                name: search.field_name,
                                storeId: search.id,
                                latitude: latitude,
                                longitude: longitude)
                            : ShippingCompanies(
                                name: search.field_name,
                                storeId: search.id,
                              )));
              } else {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => widget.store || searches.length == 4
                            ? StoreVendors(
                                name: search.field_name,
                                storeId: search.id,
                              )
                            : searches.length > 4 &&
                                    index == searches.length - 1
                                ? MarketPage(
                                    name: searches[index].field_name,
                                  )
                                : CategoryPage(
                                    category: widget.category,
                                    searchId: searches[index].id)));
              }
            }

            return Container(
                padding: EdgeInsets.symmetric(horizontal: 16 * factor),
                child: ListView.builder(
                  itemCount: state.searches.length,
                  itemBuilder: (BuildContext context, int index) {
                    final int count = state.searches.length;

                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    animationController.forward();

                    return AnimatedBuilder(
                        animation: animationController,
                        builder: (BuildContext context, Widget child) {
                          return AnimatedBuilder(
                              animation: animationController,
                              builder: (BuildContext context, Widget child) {
                                return FadeTransition(
                                    opacity: animation,
                                    child: Transform(
                                        transform: Matrix4.translationValues(
                                            100 * (1.0 - animation.value),
                                            0.0,
                                            0.0),
                                        child: Column(
                                          children: [
                                            RoundedWidget(
                                                onTap: () {
                                                  navigateToPage(
                                                      state.searches, index);
                                                },
                                                child: ListTile(
                                                  leading: Image.network(
                                                      state
                                                          .searches[index].logo,
                                                      width: width * .08,
                                                      height: height * .08),
                                                  title: Text(
                                                      state.searches[index]
                                                          .field_name,
                                                      style: style),
                                                  trailing: Icon(Icons
                                                      .keyboard_arrow_down_rounded),
                                                )),
                                            space,
                                          ],
                                        )));
                              });
                        });
                  },
                ));
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
    );
  }
}
