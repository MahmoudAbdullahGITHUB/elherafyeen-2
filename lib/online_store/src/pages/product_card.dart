import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/cart.dart';
import 'package:elherafyeen/models/cart_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final VendorModel product;
  bool fromCartPage;
  bool isCart;
  bool cartPage;
  var cartBadge;

  ProductCard(
      {this.product,
      this.isCart,
      this.cartBadge,
      this.cartPage: false,
      this.fromCartPage: false});

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    print(widget.product.price_after.toString());

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    //   if (height > 2040) factor = 3.0;
    return  InkWell(
      onTap: () {

      },
      child: ListTile(
         leading: Container(
            width: width * 0.275,
            height: height * 0.275,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xffFFCBCB),
            ),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: Color(0xffFFCBCB)),
              clipBehavior: Clip.hardEdge,
              child: CachedNetworkImage(
                imageUrl: widget.product.logo,
                errorWidget: (context, url, error) =>
                    Icon(Icons.error),
                placeholder: (context, url) =>
                    Center(child: Text("Loading")),
                fit: BoxFit.cover,
              ),
            ),
          ),
         title: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product.name,
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.black),
                ),
                Text(
                 widget.product.description,
                  maxLines: 2,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2
                      .copyWith(
                          color: Color(0xffD9D9D9), fontSize: 10),
                ),
                SizedBox(height: 15 * factor),
                Container(
                  height: 40 * factor,
                  decoration: BoxDecoration(
                      color: Color(0xffF0F0F0),
                      borderRadius: BorderRadius.all(
                          Radius.circular(20 * factor))),
                  width: 135 * factor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // IconButton(
                      //     icon: Icon(
                      //       Icons.remove,
                      //       color: Colors.black,
                      //       size: 10 * factor,
                      //     ),
                      //     onPressed: () {
                      //
                      //     }),
                      // Container(
                      //   height: 20 * factor,
                      //   color: Color(0xff808080),
                      //   width: 1 * factor,
                      // ),
                      // Container(
                      //   height: 20 * factor,
                      //   color: Color(0xff808080),
                      //   width: 1,
                      // ),
                      // IconButton(
                      //     icon: Icon(
                      //       Icons.add,
                      //       size: 10 * factor,
                      //       color: Colors.black,
                      //     ),
                      //     onPressed: () {
                      //       BlocProvider.of<CounterBloc>(context)
                      //           .add(CounterEvent.increment);
                      //     }),
                    ],
                  ),
                )
              ],
            ),
          ),
         trailing: Text(
            "${(widget.product.price_after.toString() == "null"
                || widget.product.price_after==null || widget.product
                .price_after == "0" ? (double.tryParse(widget.product.price_before)
                * widget.product.qty).toStringAsFixed(1) :
            (double.tryParse(widget.product.price_after) *
                widget.product.qty).toStringAsFixed(1))}" +
                "LE".tr(),
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: Colors.black),
          ),
      ),
    );
  }

  void fillingCart() {
    if (count != 0) {
      print("mahmoud gamal");
      bool old = false;
      for (var d in Cart.cartProducts) {
        if (d.id == widget.product.id) {
          d.quntity = count;
          widget.product.qty = count;
          old = true;
        }
      }
      if (!old) {
        widget.product.qty = count;
        Cart.cartProducts
            .add(CartModel(count, int.tryParse(widget.product.id), widget.product));
      }
      Strings.badgeData = Cart.cartProducts.length.toString();
      if (widget.cartBadge != null)
        widget.cartBadge.setState(() {
          Strings.showBadge = true;
        });
    } else {
      if (Cart.cartProducts != [] && Cart.cartProducts.length == 0)
        widget.cartBadge.setState(() {
          Strings.showBadge = false;
          Strings.badgeData = "";
        });
    }
    setState(() {});
  }
}
