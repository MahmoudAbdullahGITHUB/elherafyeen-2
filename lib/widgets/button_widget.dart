import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const ButtonWidget({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return Container(
      width: width * 0.7,
      height: height * 0.08,
      color: Colors.transparent,
      child: RaisedButton(
        onPressed: onPressed,
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(height * 0.04)),
        child: Text(
          text,
          style: TextStyle(color: HColors.colorPrimary, fontSize: 16 * factor),
        ),
      ),
    );
  }
}
