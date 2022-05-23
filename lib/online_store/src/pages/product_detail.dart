import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/models/cart.dart';
import 'package:elherafyeen/models/cart_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/online_store/src/model/data.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:elherafyeen/online_store/src/pages/shopping_cart_page.dart';
import 'package:elherafyeen/online_store/src/themes/light_color.dart';
import 'package:elherafyeen/online_store/src/themes/theme.dart';
import 'package:elherafyeen/online_store/src/widgets/BottomNavigationBar/bottom_navigation_bar.dart';
import 'package:elherafyeen/online_store/src/widgets/title_text.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../main.dart';
import 'cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  VendorModel product;
  bool isProduct;
  ProductDetailPage({Key key, this.product,this.isProduct}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();

    getProductDetails();
  }

  getProductDetails() async {
    if(widget.isProduct == true) {
      try {
        var tempProduct = await HomeApi.fetchProductDetails(
            product_id: widget.product.id.toString());
        if (tempProduct != null) {
          widget.product = tempProduct;
          setState(() {});
        }
      } catch (e) {}
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool isLiked = true;

  Widget _appBar() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 15,
            padding: 12,
            isOutLine: true,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          // _icon(isLiked ? Icons.favorite : Icons.favorite_border,
          //     color: isLiked ? LightColor.red : LightColor.lightGrey,
          //     size: 15,
          //     padding: 12,
          //     isOutLine: false, onPressed: () {
          //   setState(() {
          //     isLiked = !isLiked;
          //   });
          // }),
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
    );
  }

  Widget _icon(IconData icon, {
    Color color = LightColor.iconColor,
    double size = 20,
    double padding = 10,
    bool isOutLine = false,
    Function onPressed,
  }) {
    return InkWell(
        onTap: () {
          if (onPressed != null) {
            onPressed();
          }
        },
        child: Container(
          height: 40,
          width: 40,
          padding: EdgeInsets.all(padding),
          // margin: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            border: Border.all(
                color: LightColor.iconColor,
                style: isOutLine ? BorderStyle.solid : BorderStyle.none),
            borderRadius: BorderRadius.all(Radius.circular(13)),
            color: isOutLine
                ? Colors.transparent
                : Theme
                .of(context)
                .backgroundColor,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xfff8f8f8),
                  blurRadius: 5,
                  spreadRadius: 10,
                  offset: Offset(5, 5)),
            ],
          ),
          child: Icon(icon, color: color, size: size),
        ));
  }

  Widget _productImage(width, height) {
    return AnimatedBuilder(
      builder: (context, child) {
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: animation.value,
          child: child,
        );
      },
      animation: animation,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          // TitleText(
          //   text: widget.product.name,
          //   fontSize: 160,
          //   color: LightColor.lightGrey,
          // ),
          CachedNetworkImage(
            imageUrl: widget.product.logo.isNotEmpty ? widget.product.logo :
            widget.product.gallery != null && widget.product.gallery.isNotEmpty
                ? widget.product.gallery[0]:
                "",
            width: width,
            height: height * .4,
          )
        ],
      ),
    );
  }

  Widget _categoryWidget() {
    return widget.product.gallery != null
        ? Container(
      margin: EdgeInsets.symmetric(vertical: 0),
      width: AppTheme.fullWidth(context),
      height: 80,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children:
          widget.product.gallery?.map((x) => _thumbnail(x))?.toList()),
    )
        : SizedBox();
  }

  Widget _thumbnail(String image) {
    return AnimatedBuilder(
      animation: animation,
      //  builder: null,
      builder: (context, child) =>
          AnimatedOpacity(
            opacity: animation.value,
            duration: Duration(milliseconds: 500),
            child: child,
          ),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 40,
            width: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color: LightColor.grey,
              ),
              borderRadius: BorderRadius.all(Radius.circular(13)),
              // color: Theme.of(context).backgroundColor,
            ),
            child: Image.network(image),
          )),
    );
  }

  Widget _detailWidget() {
    return DraggableScrollableSheet(
      maxChildSize: .8,
      initialChildSize: .53,
      minChildSize: .53,
      builder: (context, scrollController) {
        return Container(
          padding: AppTheme.padding.copyWith(bottom: 0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
              color: Colors.white),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: LightColor.iconColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: MediaQuery.of(context).size.width * .9,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleText(text: widget.product.owner_name, fontSize: 25),
                    ],
                  ),
                ),
                widget.product.price_after.isNotEmpty
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                           double.tryParse(widget.product.price_after).toStringAsFixed(1) ?? "",
                          style:TextStyle(fontSize: 20),
                        ),
                        SizedBox(width: 6),
                        Text(
                            "LE".tr(),
                            style:TextStyle( fontSize: 15,
                              color: LightColor.red,)
                        ),
                      ],
                    )
                  ],
                )
                    : SizedBox(),
                SizedBox(
                  height: 20,
                ),
                Text(widget.product.status ?? ""),
                SizedBox(
                  height: 20,
                ),
                _description(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _availableSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _sizeWidget("US 6"),
            _sizeWidget("US 7", isSelected: true),
            _sizeWidget("US 8"),
            _sizeWidget("US 9"),
          ],
        )
      ],
    );
  }

  Widget _sizeWidget(String text,
      {Color color = LightColor.iconColor, bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: BorderRadius.all(Radius.circular(13)),
        color:
        isSelected ? LightColor.orange : Theme
            .of(context)
            .backgroundColor,
      ),
      child: TitleText(
        text: text,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    );
  }

  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: "Available Size",
          fontSize: 14,
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _colorWidget(LightColor.yellowColor, isSelected: true),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.lightBlue),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.black),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.red),
            SizedBox(
              width: 30,
            ),
            _colorWidget(LightColor.skyBlue),
          ],
        )
      ],
    );
  }

  Widget _colorWidget(Color color, {bool isSelected = false}) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color.withAlpha(150),
      child: isSelected
          ? Icon(
        Icons.check_circle,
        color: color,
        size: 18,
      )
          : CircleAvatar(radius: 7, backgroundColor: color),
    );
  }

  Widget _description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitleText(
          text: widget.product.description ?? "",
          fontSize: 16,
          color: HColors.colorPrimaryDark,
        ),
        SizedBox(height: 20),
        // Text(AppData.description),
      ],
    );
  }

  _flotingButton() {
    return Container(
      alignment: Alignment.center,
      width: 80.0,
      height: 80.0,
      child: new RawMaterialButton(
          onPressed: () {
            Cart.cartProducts.add(
                CartModel(1, int.tryParse(widget.product.id), widget.product));
            Strings.showBadge = true;
            Strings.badgeData = Cart.cartProducts.length.toString();
            Fluttertoast.showToast(msg: "item_added".tr());
            setState(() {});
            // Navigator.push(context,
            //     CupertinoPageRoute(builder: (_) => ShoppingCartPage()));
          },
          fillColor: HColors.colorPrimaryDark,
          shape: new CircleBorder(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.shopping_basket, color: Colors.white),
              Text(
                "buy".tr(),
                style: TextStyle(color: Colors.white),
              )
            ],
          )),
    );
  }

  _callButton(phone) {
    return Container(
      alignment: Alignment.center,
      width: 80.0,
      height: 80.0,
      child: new RawMaterialButton(
          onPressed: () async {
            var url = "tel:$phone";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
          fillColor: HColors.colorPrimaryDark,
          shape: new CircleBorder(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.call, color: Colors.white),
              Text(
                "phone".tr(),
                style: TextStyle(color: Colors.white),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      persistentFooterButtons: [
        _flotingButton(),
        _callButton(widget.product.phone)
      ],
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfffbfbfb),
                  Color(0xfff7f7f7),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _appBar(),
                  _productImage(width, height),
                  _categoryWidget(),
                ],
              ),
              _detailWidget()
            ],
          ),
        ),
      ),
    );
  }
}
