import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/payment_api.dart';
import 'package:elherafyeen/models/payment_model.dart';
import 'package:elherafyeen/models/subscription_model.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentWidget {
  var style = TextStyle(color: HColors.colorPrimaryDark, fontSize: 17);
  var styleMedium = TextStyle(color: HColors.colorPrimaryDark, fontSize: 12);

  PaymentWidget({context, Function onTap}) {
    showBottomSheet(
      context: context,
      // isDismissible: false,
      // enableDrag: false,
      // barrierColor: Colors.white.withOpacity(0),
      backgroundColor: Colors.white.withOpacity(0),
      builder: (_) => GestureDetector(
        onVerticalDragDown: (_) {},
        child: Container(
          height: MediaQuery.of(context).copyWith().size.height * 0.85,
          child: Card(
            margin: EdgeInsets.all(12),
            color: Colors.white,
            child: Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.85,
              margin: EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    "sendPaymentMain".tr(),
                    style: TextStyle(
                        color: HColors.colorPrimaryDark, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      showVodafone(context);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/vodafone.jpg",
                          width: 100,
                          height: 45,
                          fit: BoxFit.fill,
                        ),
                        Text(
                          "vodafone".tr(),
                          style: style,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      var subs = await PaymentApi.getSubscriptionsTypes();
                      Navigator.pop(context);
                      showSubChoices(context: context, subscribtions: subs);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/masary.png",
                          width: 100,
                          height: 45,
                          fit: BoxFit.fill,
                        ),
                        Text(
                          "masary".tr(),
                          style: style,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      var subs = await PaymentApi.getSubscriptionsTypes();
                      Navigator.pop(context);
                      showSubChoices(context: context, subscribtions: subs);
                    },
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/aman.jpg",
                          width: 100,
                          height: 45,
                        ),
                        Text(
                          "aman".tr(),
                          style: style,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    color: HColors.colorPrimaryDark,
                    onPressed: () {
                      onTap(false);
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                              builder: (_) => TabBarPage(currentIndex: 0)),
                          (route) => false);
                    },
                    child: Text(
                      "home".tr(),
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),

      // onOkButtonPressed: () {
      //   onTap(true);
      //   Navigator.pop(context);
      //   url("01001906874");
      //   Navigator.pushAndRemoveUntil(
      //       context,
      //       CupertinoPageRoute(
      //           builder: (_) => TabBarPage(currentIndex: 0)),
      //       (route) => false);
      // },
      // buttonOkText: Text(
      //   "pay".tr(),
      //   style: TextStyle(color: Colors.white),
      // ),
    );
  }

  showVodafone(context) {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.white.withOpacity(0),
        builder: (_) => Card(
            margin: EdgeInsets.all(12),
            color: Colors.white,
            child: Card(
              margin: EdgeInsets.all(12),
              color: Colors.white,
              child: Container(
                  height: MediaQuery.of(context).size.height * .8,
                  margin: EdgeInsets.all(12),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "sendPayment".tr(),
                          style: TextStyle(
                              color: HColors.colorPrimaryDark, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        RaisedButton(
                          onPressed: () {
                            // onTap(true);
                            Navigator.pop(context);
                            url("01001906874");
                            Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) =>
                                        TabBarPage(currentIndex: 0)),
                                (route) => false);
                          },
                          child: Text(
                            "pay".tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ])),
            )));
  }

  url(String phone) async {
    String url = "";
    if (Platform.isAndroid) {
      // add the [https]
      url = "https://wa.me/2$phone/?text=${Uri.parse(" ")}"; // new line
    } else {
      // add the [https]
      url =
          "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(" ")}"; // new line

    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void showSubChoices(
      {BuildContext context, List<SubscriptionModel> subscribtions}) {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.white.withOpacity(0),
        builder: (_) => Card(
              margin: EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: subscribtions.length,
                      itemBuilder: (BuildContext context, int index) {
                        var sub = subscribtions[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () async {
                              var firstStep =
                                  await PaymentApi.getKioskPaymentAuth(
                                      subId: sub.id);
                              Navigator.pop(context);
                              showCodePayment(context, firstStep);
                            },
                            title: Text(
                              sub.name,
                              style: style,
                            ),
                            subtitle: Text(
                              sub.value + "LE".tr(),
                              style: styleMedium,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ));
  }

  showCodePayment(context, PaymentModel lastStep) {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.white.withOpacity(0),
        builder: (_) => Card(
              margin: EdgeInsets.all(12),
              color: Colors.white,
              child: Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("code is".tr()),
                      Text(lastStep.bill_reference ?? "")
                    ],
                  ),
                ),
              ),
            ));
  }
}
