import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/bloc/home/home_bloc.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/cars/vendor_details.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import 'cars_page.dart';

class CarsCategoriesPage extends StatefulWidget {
  CarsCategoriesPage({Key key}) : super(key: key);

  @override
  _CarsCategoriesPageState createState() => _CarsCategoriesPageState();
}

class _CarsCategoriesPageState extends State<CarsCategoriesPage>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<VendorModel> ads = [];
  double latitude;
  double longitude;
  var currentLocation;

  @override
  void initState() {
    super.initState();
    loadAd();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
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
      setState(() {
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
      });
    } catch (e) {
      currentLocation = null;
    }

    return result;
  }

  loadAd() async {
    await getCurrentLocation();
    ads = await HomeApi.getRandomAd(
        lat: latitude.toString(), lng: longitude.toString());
    setState(() {});
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
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (_) => CarsPage(
                                    category: categories[index],
                                    store: false)));
                      },
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Container(
                          height: height * .17,
                          child: Center(
                            child: Column(
                              children: [
                                Expanded(
                                    child: CachedNetworkImage(
                                  width: width * .2,
                                  imageUrl: categories[index].logo,
                                  height: height * .13,
                                  // fit: BoxFit.fill,
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: AutoSizeText(
                                    categories[index].name,
                                    style: TextStyle(
                                        color: HColors.colorPrimary,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                    minFontSize: 4,
                                    maxLines: 1,
                                    maxFontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )));
          });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: HColors.colorPrimaryDark,
          title: Text(
            "car_services".tr(),
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
          create: (_) => HomeBloc()..add(FetchVehicleCategories()),
          child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is CategoriesLoaded) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: height * .02,
                        childAspectRatio: 1.5,
                        crossAxisSpacing: width * .02,
                        children:
                            List.generate(state.categories.length, (index) {
                          return showHomeItems(index, state.categories);
                        })),
                  ),
                  if (ads.isNotEmpty)
                    Positioned.fill(
                        child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (_) => VendorDetails(
                                      fetchDetails: -1, vendor: ads[0])));
                        },
                        child: Container(
                          width: width,
                          height: 65,
                          child: Image.network(ads[0].logo, fit: BoxFit.fill),
                        ),
                      ),
                    ))
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
        ));
  }
}
