import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImage extends StatelessWidget {
  String image;
  ShowImage({this.image});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
            child: PhotoView(
          imageProvider: NetworkImage(image),
        )));
  }
}
