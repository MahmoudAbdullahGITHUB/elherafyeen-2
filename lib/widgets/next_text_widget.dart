import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NextTextWidget extends StatelessWidget {
  Function onTap;
  String text;
  NextTextWidget({this.onTap, this.text});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return InkWell(
      onTap: () {
        print("1El herafyeen");
        onTap();
      },
      child: Container(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .headline1
                  .copyWith(fontSize: 18 * factor, color: Colors.white),
            ),
            Icon(Icons.keyboard_arrow_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
