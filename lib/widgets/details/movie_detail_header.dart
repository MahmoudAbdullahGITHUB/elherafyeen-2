import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/widgets/details/rating_information.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'arc_banner_image.dart';

class MovieDetailHeader extends StatelessWidget {
  MovieDetailHeader(this.vendor);
  final VendorModel vendor;

  // List<Widget> _buildCategoryChips(TextTheme textTheme) {
  //   return vendor.categories.map((category) {
  //     return Padding(
  //       padding: const EdgeInsets.only(right: 8.0),
  //       child: Chip(
  //         label: Text(category),
  //         labelStyle: textTheme.caption,
  //         backgroundColor: Colors.black12,
  //       ),
  //     );
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var movieInformation = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          vendor.name,
          style: textTheme.subtitle1,
        ),
        SizedBox(height: 8.0),
        RatingInformation(vendor),
        SizedBox(height: 12.0),
        // Row(children: _buildCategoryChips(textTheme)),
      ],
    );

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 140.0),
          child: ArcBannerImage(vendor.logo),
        ),
        Positioned(
          bottom: 0.0,
          left: 16.0,
          right: 16.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: () {
                  _launchMapsUrl(
                      double.parse(vendor.lat), double.parse(vendor.lng));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: Image.asset(
                    "assets/map2.jpg",
                    fit: BoxFit.fill,
                    width: 180.0,
                    height: 100,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(child: movieInformation),
            ],
          ),
        ),
      ],
    );
  }

  void _launchMapsUrl(double lat, double lon) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
