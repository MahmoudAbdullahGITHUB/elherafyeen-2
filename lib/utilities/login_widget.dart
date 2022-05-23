import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/pages/auth/authentication_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget LoginWidget(BuildContext context) {
  return CupertinoAlertDialog(
    title: Center(child: Text("login".tr())),
    content: Text(
      "loginOrRigister".tr(),
      textAlign: TextAlign.center,
    ),
    actions: [
      Center(
        child: ButtonTheme(
          minWidth: MediaQuery.of(context).size.width * .4,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              Navigator.push(context,
                  CupertinoPageRoute(builder: (_) => AuthenticationPage()));
            },
            color: HColors.colorPrimaryDark,
            child: Text(
              "login".tr(),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      )
    ],
  );
}
