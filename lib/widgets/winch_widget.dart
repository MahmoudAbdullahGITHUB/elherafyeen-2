import 'package:cached_network_image/cached_network_image.dart';
import 'package:elherafyeen/models/winsh_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';

class WinchWidget extends StatefulWidget {
  WinshModel winsh;
  bool company;
  WinchWidget({this.winsh, this.company});
  @override
  State<StatefulWidget> createState() => WinchWidgetState();
}

extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}

class WinchWidgetState extends State<WinchWidget> {
  var isFav = false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: MediaQuery.of(context).size.width * 0.94,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(height * 0.03),
        ),
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.winsh.winsh_img,
                    width: width * .2,
                    fit: BoxFit.fill,
                    height: height * .14,
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                  RatingBar(
                    rating: 66.0 ?? 0.0,
                    icon: Icon(
                      Icons.star,
                      size: 16,
                      color: Colors.grey,
                    ),
                    starCount: 5,
                    spacing: 0.0,
                    color: Colors.amber,
                    size: 16,
                    isIndicator: false,
                    onRatingCallback:
                        (double value, ValueNotifier<bool> isIndicator) {
                      isIndicator.value = true;
                    },
                    allowHalfRating: false,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Text(
                        widget.company
                            ? widget.winsh.company_name
                            : widget.winsh.driver_name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HColors.colorPrimaryDark,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                  //   child: Container(
                  //     width: width * .08,
                  //     height: height * .02,
                  //     color: HexColor.fromHex(widget.winsh.),
                  //     // widget.vendor.color,
                  //     // style: TextStyle(fontSize: 12, color: Colors.black),
                  //   ),
                  // ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                      child: Text(
                        widget.winsh.phone.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.fromLTRB(5, 40, 0, 0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isFav = !isFav;
                          });
                        },
                        child: ImageIcon(
                            AssetImage("assets/Icon awesome-heart.png"),
                            size: 30,
                            color: isFav ? Colors.red : Colors.grey),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
