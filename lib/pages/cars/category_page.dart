import 'package:cached_network_image/cached_network_image.dart';
import 'package:elherafyeen/bloc/home/home_bloc.dart';
import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/pages/cars/vendor_result_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class CategoryPage extends StatefulWidget {
  String searchId;
  CategoryModel category;

  CategoryPage({Key key, this.category, this.searchId}) : super();

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  double latitude;
  double longitude;
  var currentLocation;
  List<BrandModel> _searchResult = [];
  List<BrandModel> listBrands = [];
  TextEditingController controller = new TextEditingController();

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
    listItem(var brand) {
      return InkWell(
        onTap: () async {
          await getCurrentLocation().then((result) {
            longitude = result["longitude"];
            latitude = result["latitude"];
          });
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: (_) => VendorResultPage(
                      category: widget.category,
                      brand: brand,
                      searchId: widget.searchId,
                      lat: latitude,
                      lng: longitude)));
        },
        child: Container(
          margin: EdgeInsets.all(4),
          width: 55 * factor,
          decoration: new BoxDecoration(
            color: HColors.colorPrimaryDark,
            shape: BoxShape.circle,
          ),
          height: height * .1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: CachedNetworkImage(
                  imageUrl: brand.photo,
                  width: 65 * factor,
                  height: 65 * factor,
                  fit: BoxFit.fill,
                ),
              ),
              Text(brand.name,
                  style: TextStyle(color: Colors.white, fontSize: 16 * factor))
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.category.name ?? "",
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(color: Colors.white),
          ),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: HColors.colorPrimaryDark),
      body: BlocProvider(
        create: (_) =>
            HomeBloc()..add(FetchCategoryBrands(catId: widget.category.id)),
        child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state is BrandsLoaded) {
            if (listBrands.isEmpty) {
              listBrands = state.brands;
            }
            return Column(
              children: [
                Container(
                  height: 55 * factor,
                  color: HColors.colorPrimaryDark,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 0.04),
                      color: Colors.white,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        new Icon(Icons.search),
                        Expanded(
                          child: new TextField(
                            controller: controller,
                            scrollPadding: EdgeInsets.zero,
                            decoration: new InputDecoration(
                                hintText: 'Search', border: InputBorder.none),
                            onChanged: onSearchTextChanged,
                          ),
                        ),
                        new IconButton(
                          icon: new Icon(Icons.cancel),
                          onPressed: () {
                            controller.clear();
                            onSearchTextChanged('');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                new Expanded(
                    child: _searchResult.length != 0 ||
                            controller.text.isNotEmpty
                        ? GridView.builder(
                            gridDelegate:
                                new SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        (orientation == Orientation.portrait)
                                            ? factor > 1
                                                ? 4
                                                : 3
                                            : 3,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10),
                            itemCount: _searchResult.length,
                            itemBuilder: (context, i) {
                              return listItem(_searchResult[i]);
                            },
                          )
                        : Container(
                            child: GridView.builder(
                              gridDelegate:
                                  new SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          (orientation == Orientation.portrait)
                                              ? factor > 1
                                                  ? 4
                                                  : 3
                                              : 3,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemCount: listBrands.length,
                              // itemExtent: height * .2,
                              itemBuilder: (BuildContext context, int index) {
                                return listItem(listBrands[index]);
                              },
                            ),
                          )),
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
    );
  }

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    listBrands.forEach((userDetail) {
      if (userDetail.name.contains(text)) _searchResult.add(userDetail);
    });

    setState(() {});
  }
}
