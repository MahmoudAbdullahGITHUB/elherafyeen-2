import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:giffy_dialog/giffy_dialog.dart';

class ImagePickerWidget {
  ImagePickerWidget({context, Function onTap}) {
    showDialog(
        context: context,
        builder: (_) => AssetGiffyDialog(
              image: Image(
                image: AssetImage('assets/gif.gif'),
                fit: BoxFit.fill,
              ),
              title: Text(
                '',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
              ),
              description: Text(
                "promptCamera".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(color: HColors.colorPrimaryDark),
              ),
              buttonCancelText: Text(
                "capture".tr(),
                style: TextStyle(color: Colors.white),
              ),
              buttonCancelColor: HColors.colorSecondary,
              entryAnimation: EntryAnimation.BOTTOM,
              buttonOkColor: HColors.colorPrimaryDark,
              onCancelButtonPressed: () {
                onTap(false);
                Navigator.of(context).pop();
              },
              onOkButtonPressed: () {
                onTap(true);
                Navigator.of(context).pop();
              },
              buttonOkText: Text(
                "gallery".tr(),
                style: TextStyle(color: Colors.white),
              ),
            ));
  }
}
