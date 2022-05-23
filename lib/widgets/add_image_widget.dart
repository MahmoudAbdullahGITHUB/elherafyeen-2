import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddImageWidget extends StatelessWidget {
  Function onTap;
  String title;
  AddImageWidget({this.onTap, this.title});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return InkWell(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Text(title ?? "صورة المركبة".tr(),
              style: Theme.of(context).textTheme.headline1.copyWith(
                  fontSize: 22 * factor, color: HColors.colorPrimary)),
          Image.asset(
            "assets/cam.png",
            width: width * .2,
            height: height * .15,
          )
        ],
      ),
    );
  }
}
