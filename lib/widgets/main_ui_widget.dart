import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainUiWidget extends StatelessWidget {
  var width;
  var height;
  Widget child;
  MainUiWidget({this.width, this.height, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      // height: height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/Shapes.png"), fit: BoxFit.fill)),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Container(padding: EdgeInsets.all(width * .05), child: child),
      ),
    );
  }
}
