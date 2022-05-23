import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/user_api.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/chat/messages_page.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/offer_item.dart';
import 'package:elherafyeen/widgets/staff/show_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_rating_bar/flutter_simple_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'api/home_api.dart';
import 'models/register_model.dart';

class VendorDetailsPhone extends StatefulWidget {
  String phone;

  VendorDetailsPhone({Key key, this.phone}) : super(key: key);
  VendorModel vendor;

  @override
  _VendorDetailsState createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetailsPhone> {
  VendorModel vendorDetails;
  List<VendorModel> offers = [];
  List<VendorModel> products = [];

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  fetchDetails() async {
    vendorDetails = await UserApi.getUserByPhone(phone: widget.phone);
    if (vendorDetails != null) widget.vendor = vendorDetails;

    setState(() {});
    products =
    await HomeApi.fetchProductsForUser(user_id: widget.vendor.userId);

    offers = await HomeApi.fetchOffersByUser(user_id: widget.vendor.userId);

    setState(() {});
  }

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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    var textStyle =
        TextStyle(color: HColors.colorPrimaryDark, fontSize: 17 * factor);

    RoundedWidget({Widget child}) {
      return Card(
        elevation: 4 * factor,
        margin:
            EdgeInsets.symmetric(vertical: 4 * factor, horizontal: 16 * factor),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(width * .05))),
        color: Colors.white,
        child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 6 * factor, horizontal: 12 * factor),
            child: child),
      );
    }

    circleIcon({Widget child}) {
      return ClipOval(
          child: Container(
              width: 50 * factor,
              height: 50 * factor,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    width: 1.5 * factor, color: HColors.colorPrimaryDark),
              ),
              child: Center(
                child: child,
              )));
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
              centerTitle: true,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: () => Navigator.pop(context))),
          body: vendorDetails == null
              ? Container(
                  child: Center(
                      child: LoadingIndicator(
                    color: HColors.colorPrimaryDark,
                  )),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      widget.vendor.color.contains(Strings.red)
                          ? Image.asset("assets/red_color.jpg",
                              height: height * .35,
                              width: width,
                              fit: BoxFit.fill)
                          : widget.vendor.logo != ""
                              ? Image.network(widget.vendor.logo,
                                  height: height * .35,
                                  width: width,
                                  fit: BoxFit.fill)
                              : Image.asset("assets/profile_image.png",
                                  height: height * .35,
                                  fit: widget.vendor.logo != ""
                                      ? BoxFit.fill
                                      : BoxFit.cover),
                      Padding(
                        padding: EdgeInsets.all(16.0 * factor),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(widget.vendor.name ?? "",
                                style: TextStyle(
                                    color: HColors.colorPrimaryDark,
                                    fontSize: 20 * factor,
                                    fontWeight: FontWeight.bold)),
                            RatingBar(
                              rating: getReview() ?? 0.0,
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
                              onRatingCallback: (double value,
                                  ValueNotifier<bool> isIndicator) async {
                                isIndicator.value = true;
                                var result = await HomeApi.addReview(
                                    rev_user_id: widget.vendor.userId,
                                    review: " ",
                                    stars: value.toString());
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
                              },
                              allowHalfRating: false,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10 * factor,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                circleIcon(
                                    child: IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.mapMarkerAlt,
                                          size: 30 * factor,
                                          color: Colors.deepOrange.shade400,
                                        ),
                                        onPressed: () {
                                          widget.vendor.color
                                                  .contains(Strings.red) && RegisterModel.shared.type_id !="1"
                                              ? showMessage("")
                                              : _launchMapsUrl(
                                                  double.parse(
                                                      widget.vendor.lat),
                                                  double.parse(
                                                      widget.vendor.lng));
                                        })),
                                Text("map".tr(), style: textStyle)
                              ],
                            ),
                            Column(
                              children: [
                                circleIcon(
                                    child: IconButton(
                                        icon: Icon(
                                          Icons.message,
                                          size: 30 * factor,
                                          color: HColors.colorPrimaryDark,
                                        ),
                                        onPressed: () {
                                          widget.vendor.color
                                                  .contains(Strings.red) && RegisterModel.shared.type_id !="1"
                                              ? showMessage("")
                                              : Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (_) =>
                                                          MessagesPage(
                                                              user: widget
                                                                  .vendor)));
                                        })),
                                Text("chat".tr(), style: textStyle)
                              ],
                            ),
                            Column(
                              children: [
                                circleIcon(
                                  child: IconButton(
                                      icon: Icon(
                                        Icons.call,
                                        color: HColors.colorPrimaryDark,
                                      ),
                                      onPressed: () {
                                        widget.vendor.color
                                                .contains(Strings.red) && RegisterModel.shared.type_id !="1"
                                            ? showMessage("")
                                            : _launchUrl(widget.vendor.phone);
                                      }),
                                ),
                                Text("phoneCall".tr(), style: textStyle)
                              ],
                            ),
                            Column(
                              children: [
                                circleIcon(
                                  child: IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.whatsapp,
                                        color: Colors.green,
                                      ),
                                      onPressed: () {
                                        widget.vendor.color
                                                .contains(Strings.red) && RegisterModel.shared.type_id !="1"
                                            ? showMessage("")
                                            : url(widget.vendor.whatsapp);
                                      }),
                                ),
                                Text("whatsapp".tr(), style: textStyle)
                              ],
                            ),
                          ],
                        ),
                      ),
                      offers.isNotEmpty
                          ? Text(
                        "offers".tr(),
                        style: textStyle,
                      )
                          : SizedBox(),
                      offers.isNotEmpty
                          ? Container(
                        height: 160 * factor,
                        child: new Swiper(
                          itemBuilder:
                              (BuildContext context, int index) {
                            return OfferItem(offer: offers[index]);
                          },
                          itemCount: offers.length,
                          viewportFraction: 0.8,
                          scale: 0.9,
                        ),
                      )
                          : SizedBox(),
                      products.isNotEmpty
                          ? Text(
                        "products".tr(),
                        style: textStyle,
                      )
                          : SizedBox(),
                      products.isNotEmpty
                          ? new GridView.count(
                          childAspectRatio: MediaQuery
                              .of(context)
                              .size
                              .aspectRatio *
                              3 /
                              2,
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          physics: NeverScrollableScrollPhysics(),
                          children: List.generate(
                              products.length,
                                  (index) =>
                                  OfferItem(
                                      offer: products[index]))
                              .toList())
                          : SizedBox(),
                      widget.vendor.owner_name.isNotEmpty
                          ? RoundedWidget(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "owner_name".tr() + ":",
                                    textAlign: TextAlign.start,
                                    style: textStyle,
                                  ),
                                  SizedBox(width: 4 * factor),
                                  AutoSizeText(
                                    widget.vendor.owner_name ?? "",
                                    style: textStyle,
                                    maxLines: 4,
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      widget.vendor.address.isNotEmpty
                          ? RoundedWidget(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "address".tr() + ":",
                                    style: textStyle,
                                  ),
                                  SizedBox(width: 4 * factor),
                                  Expanded(
                                    child: AutoSizeText(
                                      widget.vendor.address.replaceAll(
                                              new RegExp('&rlm;'), ' ') ??
                                          "",
                                      style: textStyle,
                                      maxLines: 4,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      widget.vendor.classification_name.isNotEmpty
                          ? RoundedWidget(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "classification".tr() + ":",
                                    style: textStyle,
                                  ),
                                  SizedBox(width: 4 * factor),
                                  AutoSizeText(
                                    widget.vendor.classification_name
                                            .replaceAll(
                                                new RegExp('&rlm;'), ' ') ??
                                        "",
                                    style: textStyle,
                                    maxLines: 4,
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      widget.vendor.type.isNotEmpty
                          ? RoundedWidget(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "centerSize".tr() + ":",
                                    style: textStyle,
                                  ),
                                  SizedBox(width: 4 * factor),
                                  AutoSizeText(
                                    widget.vendor.type.replaceAll(
                                            new RegExp('&rlm;'), ' ') ??
                                        "",
                                    style: textStyle,
                                    maxLines: 4,
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      widget.vendor.working_hours_name.isNotEmpty
                          ? RoundedWidget(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "workingHours".tr() + ":",
                                    style: textStyle,
                                  ),
                                  SizedBox(width: 4 * factor),
                                  AutoSizeText(
                                    widget.vendor.working_hours_name.replaceAll(
                                            new RegExp('&rlm;'), ' ') ??
                                        "",
                                    style: textStyle,
                                    maxLines: 4,
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      widget.vendor.description.isNotEmpty
                          ? RoundedWidget(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "description".tr() + ":",
                                    style: textStyle,
                                  ),
                                  SizedBox(width: 4 * factor),
                                  AutoSizeText(
                                    widget.vendor.description.replaceAll(
                                            new RegExp('&rlm;'), ' ') ??
                                        "",
                                    style: textStyle,
                                    maxLines: 4,
                                  )
                                ],
                              ),
                            )
                          : SizedBox(),
                      widget.vendor.media != null
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                      child: Image.asset(
                                        'assets/face.webp',
                                        width: 45 * factor,
                                        height: 45 * factor,
                                      ),
                                      onTap: () {
                                        _launchWeb(widget.vendor.media.fb);
                                      }),
                                  InkWell(
                                      child: Image.asset(
                                        'assets/twitter.webp',
                                        width: 45 * factor,
                                        height: 45 * factor,
                                      ),
                                      onTap: () {
                                        _launchWeb(widget.vendor.media.twitter);
                                      }),
                                  InkWell(
                                      child: Image.asset(
                                        'assets/linkedin.webp',
                                        width: 45 * factor,
                                        height: 45 * factor,
                                      ),
                                      onTap: () {
                                        _launchWeb(
                                            widget.vendor.media.linkedin);
                                      }),
                                  InkWell(
                                      child: Image.asset(
                                        'assets/insta.webp',
                                        width: 45 * factor,
                                        height: 45 * factor,
                                      ),
                                      onTap: () {
                                        _launchWeb(widget.vendor.media.insta);
                                      }),
                                  InkWell(
                                      child: Image.asset(
                                        'assets/youtub.webp',
                                        width: 45 * factor,
                                        height: 45 * factor,
                                      ),
                                      onTap: () {
                                        _launchWeb(widget.vendor.media.yt);
                                      }),
                                  InkWell(
                                      child: Image.asset(
                                        'assets/telegram.webp',
                                        width: 45 * factor,
                                        height: 45 * factor,
                                      ),
                                      onTap: () {
                                        _launchWeb(
                                            widget.vendor.media.telegram);
                                      }),
                                ],
                              ),
                            )
                          : SizedBox(),
                      (widget.vendor.services != null)
                          ? Text(
                              "services".tr(),
                              style: textStyle,
                            )
                          : SizedBox(),
                      (widget.vendor.services != null)
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0 * factor),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: widget.vendor.services.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Text(
                                      widget.vendor.services[index].name);
                                },
                              ),
                            )
                          : SizedBox(),
                      (widget.vendor.fields != null)
                          ? Text(
                              "fields".tr(),
                              style: textStyle,
                            )
                          : SizedBox(),
                      (widget.vendor.fields != null)
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0 * factor),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: widget.vendor.fields.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Text(widget.vendor.fields[index].name);
                                },
                              ),
                            )
                          : SizedBox(),
                      (widget.vendor.videos != null)
                          ? Text(
                              "videos".tr(),
                              style: textStyle,
                            )
                          : SizedBox(),
                      (widget.vendor.videos != null)
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.0 * factor),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 4,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5.0,
                                  mainAxisSpacing: 5.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  Future<String> _getImage(
                                      String videoPathUrl) async {
                                    print(videoPathUrl);
                                    if (videoPathUrl.contains("embed")) {
                                      final a = Uri.parse(videoPathUrl);
                                      print(a.pathSegments.last);
                                      return 'https://img.youtube.com/vi/${a.pathSegments.last}/0.jpg';
                                    } else {
                                      final Uri uri = Uri.parse(videoPathUrl);
                                      if (uri == null) {
                                        return null;
                                      }
                                      print(videoPathUrl);
                                      return 'https://img.youtube.com/vi/${uri.queryParameters['v']}/0.jpg';
                                    }
                                  }

                                  return InkWell(
                                    onTap: () {
                                      var videos = widget.vendor.videos;
                                      index == 0
                                          ? _launchWeb(
                                              videos.video_link_1 ?? "")
                                          : index == 1
                                              ? _launchWeb(
                                                  videos.video_link_2 ?? "")
                                              : index == 2
                                                  ? _launchWeb(
                                                      videos.video_link_3 ?? "")
                                                  : _launchWeb(
                                                      videos.video_link_4 ??
                                                          "");
                                    },
                                    child: Stack(
                                      children: [
                                        FutureBuilder<String>(
                                          future: index == 0
                                              ? _getImage(widget
                                                  .vendor.videos.video_link_1)
                                              : index == 1
                                                  ? _getImage(widget.vendor
                                                      .videos.video_link_2)
                                                  : index == 2
                                                      ? _getImage(widget.vendor
                                                          .videos.video_link_3)
                                                      : _getImage(widget.vendor
                                                          .videos.video_link_4),
                                          initialData: "",
                                          builder: (context, snapshot) {
                                            return Image.network(
                                                snapshot.data.toString());
                                          },
                                        ),
                                        Positioned.fill(
                                            child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            FontAwesomeIcons.play,
                                            color: Colors.white,
                                            size: 18 * factor,
                                          ),
                                        ))
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(),
                      (widget.vendor.gallery != null &&
                              widget.vendor.gallery.length != 0)
                          ? GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.vendor.gallery.length,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (_) => ShowImage(
                                                  image: widget
                                                      .vendor.gallery[index],
                                                )));
                                  },
                                  child: Container(
                                    width: width * .2,
                                    height: height * .12,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(width * .02)),
                                      child: Image.network(
                                          widget.vendor.gallery[index],
                                          width: width * .2,
                                          height: height * .12,
                                          fit: BoxFit.fill),
                                    ),
                                  ),
                                );
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5.0,
                              ),
                            )
                          : SizedBox(),
                      if (widget.vendor.brands != null)
                        Text(
                          "listBrands".tr(),
                          style: textStyle,
                        ),
                      SizedBox(
                        height: 0,
                      ),
                      if (widget.vendor.brands != null)
                        Padding(
                          padding: EdgeInsets.all(12.0 * factor),
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    crossAxisSpacing: 5.0,
                                    mainAxisSpacing: 5.0),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: widget.vendor.brands.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(width * .02)),
                                    child: Image.network(
                                        widget.vendor.brands[index].photo,
                                        width: width * .12,
                                        height: height * .09,
                                        fit: BoxFit.fill),
                                  ),
                                  Text(widget.vendor.brands[index].name),
                                ],
                              );
                            },
                          ),
                        )
                    ],
                  ),
                ),
        ));
  }

  void _launchUrl(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchWeb(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchMapsUrl(double lat, double lon) async {
    if (await MapLauncher.isMapAvailable(MapType.google)) {
      await MapLauncher.launchMap(
        mapType: MapType.google,
        coords: Coords(lat, lon),
        title: "app_name".tr(),
        description: "الحرفيين",
      );
    }
  }

  url(String phone) async {
    String url = "";
    if (Platform.isAndroid) {
      // add the [https]
      url = "https://wa.me/2$phone/?text=${Uri.parse(" ")}"; // new line
    } else {
      // add the [https]
      url =
          "https://api.whatsapp.com/send?phone=$phone=${Uri.parse(" ")}"; // new line

    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  showMessage(String tr) {
    Fluttertoast.showToast(
        msg: "Denied".tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<bool> _onWillPop() {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (_) => TabBarPage(currentIndex: 0)),
        (route) => false);
  }
}
