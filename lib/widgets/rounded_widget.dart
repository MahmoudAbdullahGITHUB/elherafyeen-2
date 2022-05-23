import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedWidget extends StatelessWidget {
  Widget child;
  Function onTap;
  RoundedWidget({this.child, this.onTap});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(width * .02))),
        elevation: 5,
        child: Container(
          padding: EdgeInsets.all(height * .01),
          child: child,
        ),
      ),
    );
  }
}
