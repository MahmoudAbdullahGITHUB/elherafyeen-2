import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderSentPage extends StatelessWidget {

  const OrderSentPage();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    //   if (height > 2040) factor = 3.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(height: height * 0.15),
          Image.asset(
               "assets/order_sent.png"),
          SizedBox(height: 15 * factor),
          Center(
            child:  Text(
                    "تم إرسال الطلب بنجاح سيتم التواصل معك قريباً ",
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 20 * factor, color: Colors.black),
              textAlign: TextAlign.center,
                  )
          ),
          Container(
            width: width * 0.6,
            child: Text(
                     "التطبيق "
                         "غير مسئول عن إختيار مندوب الشحن أو البائع  وغير مسئول عن أي سخافات تنتج من "
                         "البائع أو المشتري أو الشحن فالتطبيق ليس مسؤل عن أي تلاعب ينتج عن أي طرف",
                    style: Theme.of(context)
                        .textTheme
                        .headline3
                        .copyWith(fontSize: 12 * factor, color: Colors.black),
                    textAlign: TextAlign.center,
                  )
          ),
          SizedBox(height: height * 0.05),

          Padding(
            padding: EdgeInsets.only(right: width * 0.2, left: width * 0.2),
            child: TextButton(
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
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (BuildContext context) =>
                        TabBarPage(currentIndex: 0),
                  ),
                );
              },
              child: Text("ok".tr(),style: TextStyle(
                  color: Colors.white
              ),),
            ),
          ),
        ],
      ),
    );
  }
}
