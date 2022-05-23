import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'colors.dart';

void errorSnackBar(String error, BuildContext context, {bool success: false}) {
  if (Platform.isIOS) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(error),
          actions: <Widget>[
            Container(
              child: CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "Ok",
                ),
              ),
            )
          ],
        );
      },
    );
  } else {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: success ? HColors.colorSecondary : Colors.red,
      ),
    );
  }
}
class FlutterMessage{
  review({BuildContext context, Function onReviewed}) {
    double progress;
    showAnimatedDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext) {
        return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
                side: BorderSide(color: Colors.redAccent)),
            child: Padding(
                padding: EdgeInsets.all(3.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      side: BorderSide(color: HColors.colorPrimaryDark)),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .3,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                           "review_item".tr(),
                            style: TextStyle(color: HColors.colorPrimaryDark),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(6.0),
                          child: RatingBar.builder(
                            initialRating: 0.0,
                            itemSize: 30,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            // ignoreGestures: true,
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amberAccent,
                            ),
                            onRatingUpdate: (ratingValue) async {
                              progress = ratingValue;
                            },
                          ),
                        ),
                        TextButton(
                            style: ButtonStyle(
                              shape:
                              ButtonStyleButton.allOrNull<OutlinedBorder>(
                                new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            MediaQuery.of(context).size.height *
                                                .03))),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  HColors.colorPrimaryDark),
                            ),
                            onPressed: () {
                              onReviewed(progress);
                              Navigator.pop(buildContext);
                            },
                            child: Text(
                              "ok".tr(),
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0),
                            ))
                      ],
                    ),
                  ),
                )));
      },
      animationType: DialogTransitionType.slideFromBottom,
      curve: Curves.fastOutSlowIn,
      duration: Duration(seconds: 1),
    );
  }
}