import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chevron extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // set the paint color to be white
    paint.color = Colors.grey.shade300;

    // Create a rectangle with size and width same as the canvas
    var rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // draw the rectangle using the paint
    canvas.drawRect(rect, paint);

    canvas.drawRect(
      Rect.fromLTWH(10, 0, size.width, size.height),
      new Paint()..color = Colors.grey.shade300,
    );

    // canvas.drawRect(
    //   new Rect.fromLTRB(
    //       30, size.height - 20, size.width - 30, size.height - 15),
    //   new Paint()..color = Colors.grey.shade300,
    // );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
