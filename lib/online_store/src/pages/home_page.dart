import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clippy_flutter/arc.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/online_store/src/model/category.dart';
import 'package:elherafyeen/online_store/src/model/data.dart';
import 'package:elherafyeen/online_store/src/pages/product_detail.dart';
import 'package:elherafyeen/online_store/src/themes/light_color.dart';
import 'package:elherafyeen/online_store/src/themes/theme.dart';
import 'package:elherafyeen/online_store/src/widgets/product_card.dart';
import 'package:elherafyeen/online_store/src/widgets/product_icon.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m;
import 'package:easy_localization/easy_localization.dart';

import 'cart_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

List<Category> categoryList = [
  Category(id: 1, name: "offers".tr(), image: '', isSelected: true),
  Category(id: 1, name: "products".tr(), image: '', isSelected: false)
];

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<VendorModel> offers = [];
  List<VendorModel> products = [];

  @override
  void initState() {
    super.initState();
    loadOffersAndProducts();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        setState(() {});
        // Handle this case
        break;
      case AppLifecycleState.inactive:
        // Handle this case
        break;
      case AppLifecycleState.paused:
        // Handle this case
        break;
      case AppLifecycleState.detached:
        // Handle this case
        break;
    }
  }

  Widget _icon(IconData icon, {Color color = LightColor.iconColor}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(13)),
          color: Theme.of(context).backgroundColor,
          boxShadow: AppTheme.shadow),
      child: Icon(
        icon,
        color: color,
      ),
    );
  }

  Widget _categoryWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: 80,
      child: ListView(scrollDirection: Axis.horizontal, children: [
        ProductIcon(
            model: categoryList[0],
            onSelected: (model) {
              setState(() {
                categoryList[0].isSelected = true;
                categoryList[1].isSelected = false;
                model.isSelected = true;
              });
            }),
        ProductIcon(
            model: categoryList[1],
            onSelected: (model) {
              setState(() {
                categoryList[1].isSelected = true;
                categoryList[0].isSelected = false;
                model.isSelected = true;
              });
            })
      ]),
    );
  }

  Widget _productWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: AppTheme.fullWidth(context),
      height: AppTheme.fullWidth(context) * .7,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 4 / 3,
            mainAxisSpacing: 30,
            crossAxisSpacing: 20),
        padding: EdgeInsets.only(left: 20),
        scrollDirection: Axis.horizontal,
        children: AppData.productList
            .map(
              (product) => ProductCard(
                product: product,
                onSelected: (model) {
                  setState(() {
                    AppData.productList.forEach((item) {
                      item.isSelected = false;
                    });
                    model.isSelected = true;
                  });
                },
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _search() {
    return Container(
      margin: AppTheme.padding,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: LightColor.lightGrey.withAlpha(100),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search Products",
                    hintStyle: TextStyle(fontSize: 12),
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 5),
                    prefixIcon: Icon(Icons.search, color: Colors.black54)),
              ),
            ),
          ),
          SizedBox(width: 20),
          _icon(Icons.filter_list, color: Colors.black54)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    listofProducts(List<VendorModel> products,isProduct) {
      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            elevation: 3,
            margin: EdgeInsets.only(top: 8, bottom: 8, right: 4, left: 4),
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                      Colors.white,
                      Colors.grey.shade200,
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
                borderRadius: const BorderRadius.all(Radius.circular(12)),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (_) =>
                              ProductDetailPage(product: products[index],isProduct: isProduct,)));
                },
                leading: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: products[index].color.contains(Strings.red)
                      ? Image.asset(
                          "assets/red_color.jpg",
                          width: width * .2,
                          fit: BoxFit.fill,
                          height: 90,
                        )
                      : CachedNetworkImage(
                          imageUrl: products[index].logo,
                          width: width * .2,
                          fit: BoxFit.fill,
                          height: 90,
                        ),
                ),
                title: Text(
                  products[index].description ?? "",
                  textAlign: TextAlign.start,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: HColors.colorPrimaryDark, fontSize: 15),
                ),
                subtitle: Text(products[index].name ?? "",
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1
                        .copyWith(fontSize: 12)),
                trailing: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 4,
                    ),
                    Container(
                      height: 55,
                      width: 1,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    products[index].price_after.isNotEmpty
                        ? Column(
                            children: [
                              Text(products[index].price_after,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                          color: Colors.redAccent,
                                          fontSize: 13)),
                              Text("LE".tr(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                          color: Colors.redAccent,
                                          fontSize: 11)),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return Directionality(
      textDirection: m.TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context, CupertinoPageRoute(builder: (_) => CartPage()));
                },
                child: Badge(
                    showBadge: Strings.showBadge,
                    badgeContent: Text(
                      Strings.badgeData.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                    child: Icon(
                      Icons.add_shopping_cart_outlined,
                      color: HColors.colorPrimaryDark,
                    )),
              ),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height,
          // child:
          // SingleChildScrollView(
          //   physics: BouncingScrollPhysics(),
          //   dragStartBehavior: DragStartBehavior.down,
          child: offers.isNotEmpty || products.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    _search(),
                    _categoryWidget(),
                    Expanded(
                        child: (categoryList[0].isSelected)
                            ? listofProducts(offers,false)
                            : listofProducts(products,true))
                    // _productWidget(),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(HColors.colorPrimaryDark),
                      strokeWidth: .6),
                ),
          // ),
        ),
      ),
    );
  }

  void loadOffersAndProducts() async {
    products = await HomeApi.fetchAllProducts();
    offers = await HomeApi.fetchAllOffers();
    setState(() {});
  }
}
