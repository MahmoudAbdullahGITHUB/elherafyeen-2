import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/cart.dart';
import 'package:elherafyeen/models/cart_model.dart';
import 'package:elherafyeen/online_store/src/pages/product_card.dart';
import 'package:elherafyeen/online_store/src/pages/shopping_cart_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  CartPage();

  @override
  _CartPageState createState() => _CartPageState();
}


class _CartPageState extends State<CartPage> {
  double price;
  double deliveryCost;
  double total;
  String notes;
  String deliveryMethod;
  int addressId;
  int branchId;
  List<CartModel> products;
  int _radioValue1 = 0;
  var payment = "cod";

  String time;

  String coupon;

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
      if (_radioValue1 == 0) {
        payment = "cod";
      } else
        payment = "tap";
    });
  }

  @override
  Widget build(BuildContext context) {
    final _padding = const EdgeInsets.only(right: 12.0, left: 12);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    //   if (height > 2040) factor = 3.0;
    Widget billWidget({String title, String price, bool isTotal = false}) {
      return Padding(
        padding: EdgeInsets.only(left: 12.0 * factor, right: 12.0 * factor),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: isTotal
                      ? Theme.of(context).textTheme.headline2.copyWith(
                            fontSize: 17 * factor,
                            color: Theme.of(context).primaryColor,
                          )
                      : Theme.of(context).textTheme.headline3.copyWith(
                            fontSize: 15 * factor,
                            color: Colors.black,
                          ),
                ),
                Spacer(),
                Text(
                  price + "LE".tr(),
                  style: isTotal
                      ? Theme.of(context).textTheme.headline2.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17 * factor,
                          )
                      : Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.black, fontSize: 15 * factor),
                ),
              ],
            ),
            isTotal
                ? SizedBox()
                : Divider(
                    color: Theme.of(context).primaryColor,
                  )
          ],
        ),
      );
    }

    Widget header(String title) {
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0, top: 20),
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 16),
            textAlign: TextAlign.start,
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: HColors.colorPrimaryDark,
            ),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "cart".tr(),
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(color: HColors.colorPrimaryDark),
          ),
        ),
        body: Cart.cartProducts != [] && Cart.cartProducts.length != 0
            ? SingleChildScrollView(
                padding: _padding,
                physics: BouncingScrollPhysics(),
                child: Column(children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemExtent: 150,
                    itemCount: Cart.cartProducts.length + 1,
                    itemBuilder: (_, index) {
                      if (index == Cart.cartProducts.length) {
                        return Container(
                          height: 50,
                          child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (_) => ShoppingCartPage()));
                              },
                              style: ButtonStyle(
                                shape:
                                    ButtonStyleButton.allOrNull<OutlinedBorder>(
                                  new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              MediaQuery.of(context).size.height *
                                                  .02))),
                                ),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    HColors.colorPrimaryDark),
                              ),
                              child: Text(
                                "ok".tr(),
                                style: TextStyle(color: Colors.white),
                              )),
                        );
                      }
                      return Dismissible(
                          key: ValueKey(Cart.cartProducts[index]),
                          secondaryBackground: Container(
                            width: width*.9,
                            alignment: AlignmentDirectional.centerEnd,
                            padding:
                                EdgeInsetsDirectional.only(start: 10, end: 10),
                            color: Colors.redAccent,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          background: Container(
                            alignment: AlignmentDirectional.centerStart,
                            padding:
                                EdgeInsetsDirectional.only(start: 10, end: 10),
                            color: Colors.redAccent,
                            child: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (DismissDirection direction) {
                            Cart.cartProducts.remove(Cart.cartProducts[index]);
                            Strings.badgeData = Cart.cartProducts.length.toString();
                          },
                          child: ProductCard(
                              fromCartPage: true,
                              isCart: true,
                              cartPage: true,
                              product: Cart.cartProducts[index].product));
                    },
                  ),
                  if (deliveryCost != null)
                    billWidget(title: "Subtotal", price: price.toString()),
                  if (deliveryCost != null)
                    billWidget(
                        title: "Delivery Fee", price: deliveryCost.toString()),
                  if (deliveryCost != null)
                    billWidget(
                        title: "Total", price: total.toString(), isTotal: true),
                ]),
              )
            : SizedBox());
  }
}
