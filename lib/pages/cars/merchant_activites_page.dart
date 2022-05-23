import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/vendor_api.dart';
import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/pages/home/online_marchent_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/rounded_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class MerchantActivitesPage extends StatefulWidget {
  bool isMedical;

  MerchantActivitesPage({this.isMedical: false});

  @override
  _MerchantActivitesPageState createState() => _MerchantActivitesPageState();
}

class _MerchantActivitesPageState extends State<MerchantActivitesPage>
    with TickerProviderStateMixin {
  double latitude;
  double longitude;
  var currentLocation;
  List<BrandModel> _searchResult = [];
  List<BrandModel> listBrands = [];
  TextEditingController controller = new TextEditingController();
  List<CategoryModel> listCategories = [];
  List<CategoryModel> searchListCategories = [];
  List<CategoryModel> tempListCategories = [];
  var titleController = TextEditingController();

  AnimationController animationController;

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
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

  @override
  void initState() {
    super.initState();
    getAllActivities();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  getAllActivities() async {
    listCategories =
        await VendorApi.fetchMerchantActivities(isMedical: widget.isMedical);
    tempListCategories = listCategories;
    setState(() {});
  }

  void searchingList(String text) {

    print('m text$text');
    listCategories = tempListCategories;
    text = text.toLowerCase();

    searchListCategories = listCategories.where((categoryModel) {
      var noteTitle = categoryModel.name.toLowerCase();
      return noteTitle.contains(text);
    }).toList();
    if (text.isNotEmpty) {
      setState(() {
        listCategories = searchListCategories;
      });
    } else {
      setState(() {
        listCategories = tempListCategories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    final width = MediaQuery.of(context).size.width;
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
            title: Text(
                widget.isMedical ? 'medical_educational'.tr():"online_dealers".tr() ?? "",
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
        body: listCategories.isEmpty
            ? Container(
                child: Center(
                    child: LoadingIndicator(
                  color: HColors.colorPrimaryDark,
                )),
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10),
                    child: SizedBox(
                      // color: Colors.red,
                      height: 60,
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(
                            labelText: "Search",
                            hintText: "Search",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)))),
                        onChanged: (text) {
                          searchingList(text);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: listCategories.length,
                        itemBuilder: (BuildContext context, int index) {
                          final int count = listCategories.length;

                          final Animation<double> animation =
                              Tween<double>(begin: 0.0, end: 1.0)
                                  .animate(CurvedAnimation(
                            parent: animationController,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn),
                          ));
                          animationController.forward();

                          return AnimatedBuilder(
                              animation: animationController,
                              builder: (BuildContext context, Widget child) {
                                return AnimatedBuilder(
                                    animation: animationController,
                                    builder:
                                        (BuildContext context, Widget child) {
                                      return FadeTransition(
                                          opacity: animation,
                                          child: Transform(
                                              transform:
                                                  Matrix4.translationValues(
                                                      100 *
                                                          (1.0 -
                                                              animation.value),
                                                      0.0,
                                                      0.0),
                                              child: Column(
                                                children: [
                                                  RoundedWidget(
                                                      onTap: () async {
                                                        await getCurrentLocation();
                                                        Navigator.push(
                                                            context,
                                                            CupertinoPageRoute(
                                                                builder: (_) => OnlineMerchantPage(
                                                                    lat:
                                                                        latitude,
                                                                    lng:
                                                                        longitude,
                                                                    activity:
                                                                        listCategories[
                                                                            index])));
                                                      },
                                                      child: ListTile(
                                                        leading: Image.network(
                                                          listCategories[index]
                                                              .logo,
                                                          width: width * .1,
                                                          height: height * .1,
                                                          fit: BoxFit.fill,
                                                        ),
                                                        title: Text(
                                                            listCategories[
                                                                    index]
                                                                .name,
                                                            style: style),
                                                        trailing: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(listCategories[
                                                                        index]
                                                                    .merchants_number_in ??
                                                                ""),
                                                            Icon(Icons
                                                                .keyboard_arrow_down_rounded),
                                                          ],
                                                        ),
                                                      )),
                                                  space,
                                                ],
                                              )));
                                    });
                              });
                        },
                      ),
                    ),
                  ),
                ],
              ));
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
