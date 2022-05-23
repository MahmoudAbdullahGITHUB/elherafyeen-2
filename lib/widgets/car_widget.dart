import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CarWidget extends StatefulWidget {
  VendorModel vendor;
  bool merchant;
  CarWidget({this.vendor, this.merchant: false});

  @override
  State<StatefulWidget> createState() => CarWidgetState();
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

class CarWidgetState extends State<CarWidget> {
  var isFav = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    print(widget.vendor.distance.toString());
    var distance = widget.vendor.distance != ""
        ? double.parse(widget.vendor.distance ?? 0.0) * 1000
        : 0.0;
    var distanceString = (distance) > 1000.0
        ? (distance / 1000).toStringAsFixed(2) + "km".tr()
        : distance.toStringAsFixed(2) + "m".tr();

    double getReview() {
      if (widget.vendor.reviews != null && widget.vendor.reviews.length != 0) {
        int total_number = 0;
        for (var review in widget.vendor.reviews) {
          total_number += int.parse(review.stars);
        }

        var score = (total_number / (widget.vendor.reviews.length * 5)) * 100;
        print(total_number.toString() +
            "&" +
            (widget.vendor.reviews.length * 5).toString() +
            "&" +
            score.toString());
        return score;
      } else {
        return 0.0;
      }
    }

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
                  widget.vendor.color.contains(Strings.red)
                      ? Image.asset(
                          "assets/red_color.jpg",
                          width: width * .2,
                          fit: BoxFit.fill,
                          height: height * .14,
                        )
                      : CachedNetworkImage(
                          imageUrl: widget.vendor.logo,
                          width: width * .2,
                          fit: BoxFit.fill,
                          height: height * .14,
                        ),
                  SizedBox(
                    height: height * .02,
                  ),
                  InkWell(
                    onTap: () {
                      FlutterMessage().review(
                          context: context,
                          onReviewed: (progress) async {
                            var result = await HomeApi.addReview(
                                rev_user_id: widget.vendor.userId,
                                review: " ",
                                stars: progress.toString());
                            if (result) {
                              Fluttertoast.showToast(
                                  msg: "review".tr(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.green,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          });
                    },
                    child: RatingBar.builder(
                      initialRating: getReview()??0.0,
                      itemSize: 16,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      ignoreGestures: true,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amberAccent,
                      ),
                      onRatingUpdate: (ratingValue) async {
                      },
                    ),
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
                        widget.vendor.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: HColors.colorPrimaryDark,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  if (widget.merchant)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Text(
                        widget.vendor?.activities.isNotEmpty?widget.vendor?.activities[0]?.name ?? "":"",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),

                  if (widget.vendor.distance != "")
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 0, 0),
                        child: Text(
                          "distance".tr() + distanceString.toString(),
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
