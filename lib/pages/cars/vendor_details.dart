import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/api/user_api.dart';
import 'package:elherafyeen/models/phone_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/chat/messages_page.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/offer_item.dart';
import 'package:elherafyeen/widgets/staff/show_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorDetails extends StatefulWidget {
  int fetchDetails;

  VendorDetails({Key key, this.vendor, this.fetchDetails: -1})
      : super(key: key);
  VendorModel vendor;

  @override
  _VendorDetailsState createState() => _VendorDetailsState();
}

class _VendorDetailsState extends State<VendorDetails>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  VendorModel vendorDetails;
  List<VendorModel> offers = [];
  List<VendorModel> products = [];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    if (widget.fetchDetails != -1) fetchDetails();
  }

  fetchDetails() async {
    print("MAHMOUD JAMAL ${widget.vendor.phone}");
    // print('vendorDetails4453 ${widget.vendor.phone}');
    print('token ${RegisterModel.shared.token}');
    vendorDetails = await UserApi.getUserByPhone(phone: widget.vendor.phone);
    phones = await HomeApi.get_user_numbers_list_by_id(userId: widget.vendor.userId);

    // if (vendorDetails != null) widget.vendor = vendorDetails;
    /// beso
    if (vendorDetails != null) widget.vendor = vendorDetails;

    print('vendorDetails445 $vendorDetails');

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
        TextStyle(color: HColors.colorPrimaryDark, fontSize: 15 * factor);
    var titleTextStyle = TextStyle(
        color: Colors.black,
        fontSize: 18 * factor,
        fontWeight: FontWeight.w600);

    RoundedWidget({Widget child}) {
      return Card(
        elevation: 4 * factor,
        margin:
            EdgeInsets.symmetric(vertical: 4 * factor, horizontal: 8 * factor),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(width * .05))),
        color: Colors.white,
        child: Container(
            margin: EdgeInsets.symmetric(
                vertical: 6 * factor, horizontal: 16 * factor),
            child: child),
      );
    }

    circleIcon({Widget child}) {
      animationController.forward();
      return ScaleTransition(
        alignment: Alignment.center,
        scale: CurvedAnimation(
            parent: animationController, curve: Curves.fastOutSlowIn),
        child: ClipOval(
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
                ))),
      );
    }

    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                print('widget.fetchDetails = ${widget.fetchDetails} $vendorDetails');
                Navigator.pop(context);})),
      body: widget.fetchDetails != -1 && vendorDetails == null
          ? Container(
              child: Center(
                  child: LoadingIndicator(
                color: HColors.colorPrimaryDark,
              )),
            )
          : Container(
              color: Colors.grey,
              child: SingleChildScrollView(
                child: Stack(
                  // mainAxisAlignment: MainAxisAlignment.start,
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
                      padding: EdgeInsets.only(top: height * .32),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32.0),
                              topRight: Radius.circular(32.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 10.0),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(16.0 * factor),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(widget.vendor.name ?? "",
                                      style: TextStyle(
                                          color: HColors.colorPrimaryDark,
                                          fontSize: 20 * factor,
                                          fontWeight: FontWeight.bold)),
                                  InkWell(
                                    onTap: () {
                                      FlutterMessage().review(
                                          context: context,
                                          onReviewed: (progress) async {
                                            var result =
                                                await HomeApi.addReview(
                                                    rev_user_id:
                                                        widget.vendor.userId,
                                                    review: " ",
                                                    stars: progress.toString());
                                            if (result) {
                                              Fluttertoast.showToast(
                                                  msg: "review".tr(),
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.green,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                            }
                                          });
                                    },
                                    child: RatingBar.builder(
                                      initialRating: getReview() ?? 0.0,
                                      itemSize: 16,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      ignoreGestures: true,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Colors.amberAccent,
                                      ),
                                      onRatingUpdate: (ratingValue) async {},
                                    ),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      circleIcon(
                                          child: IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.mapMarkerAlt,
                                                size: 30 * factor,
                                                color:
                                                    Colors.deepOrange.shade400,
                                              ),
                                              onPressed: () {
                                                widget.vendor.color.contains(
                                                            Strings.red) &&
                                                        RegisterModel.shared
                                                                .type_id !=
                                                            "1"
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
                                                widget.vendor.color.contains(
                                                            Strings.red) &&
                                                        RegisterModel.shared
                                                                .type_id !=
                                                            "1"
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

                                              showModalBottomSheet(
                                                  context: context,
                                                  barrierColor: Colors.white.withOpacity(0),
                                                  backgroundColor: Colors.white.withOpacity(0),
                                                  builder: (_) => Card(
                                                    margin: EdgeInsets.all(12),
                                                    color: Colors.grey.shade100,
                                                    child: Container(
                                                      height: height*.45,
                                                      padding: EdgeInsets.all(8),
                                                      child: Center(
                                                          child: ListView(
                                                            children: getPhones()
                                                          )),
                                                    ),
                                                  ));

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
                                              FontAwesomeIcons.telegram,
                                              color: HColors.colorPrimaryDark,
                                            ),
                                            onPressed: () {
                                              widget.vendor.color.contains(
                                                          Strings.red) &&
                                                      RegisterModel
                                                              .shared.type_id !=
                                                          "1"
                                                  ? showMessage("")
                                                  : _launchTelegram(
                                                      widget.vendor.phone);
                                            }),
                                      ),
                                      Text("telegram".tr(), style: textStyle)
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
                                              widget.vendor.color.contains(
                                                          Strings.red) &&
                                                      RegisterModel
                                                              .shared.type_id !=
                                                          "1"
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
                            widget.vendor.owner_name.isNotEmpty
                                ? RoundedWidget(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "owner_name".tr() + ":",
                                          textAlign: TextAlign.start,
                                          style: titleTextStyle,
                                        ),
                                        SizedBox(width: 12 * factor),
                                        AutoSizeText(
                                          widget.vendor.owner_name ?? "",
                                          style: textStyle,
                                          maxLines: 4,
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            widget.vendor.maximum_load_limit.isNotEmpty
                                ? RoundedWidget(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "maximumship".tr() + ":",
                                          textAlign: TextAlign.start,
                                          style: titleTextStyle,
                                        ),
                                        SizedBox(width: 12 * factor),
                                        AutoSizeText(
                                          widget.vendor.maximum_load_limit ??
                                              "",
                                          style: textStyle,
                                          maxLines: 4,
                                        )
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            widget.vendor.shipping_type_name.isNotEmpty
                                ? RoundedWidget(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "shippingType".tr() + ":",
                                          textAlign: TextAlign.start,
                                          style: titleTextStyle,
                                        ),
                                        SizedBox(width: 12 * factor),
                                        AutoSizeText(
                                          widget.vendor.shipping_type_name ??
                                              "",
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "address".tr() + ":",
                                          style: titleTextStyle,
                                        ),
                                        SizedBox(width: 12 * factor),
                                        AutoSizeText(
                                          widget.vendor.color
                                                      .contains(Strings.red) &&
                                                  RegisterModel
                                                          .shared.type_id !=
                                                      "1"
                                              ? ""
                                              : widget.vendor.address
                                                      .replaceAll(
                                                          new RegExp('&rlm;'),
                                                          ' ') ??
                                                  "",
                                          textAlign: TextAlign.end,
                                          style: textStyle,
                                          maxLines: 4,
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
                                          style: titleTextStyle,
                                        ),
                                        SizedBox(width: 12 * factor),
                                        AutoSizeText(
                                          widget.vendor.classification_name
                                                  .replaceAll(
                                                      new RegExp('&rlm;'),
                                                      ' ') ??
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
                                          style: titleTextStyle,
                                        ),
                                        SizedBox(width: 12 * factor),
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
                                          style: titleTextStyle,
                                        ),
                                        SizedBox(width: 12 * factor),
                                        AutoSizeText(
                                          widget.vendor.working_hours_name
                                                  .replaceAll(
                                                      new RegExp('&rlm;'),
                                                      ' ') ??
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
                                          style: titleTextStyle,
                                        ),
                                        SizedBox(width: 12 * factor),
                                        Expanded(
                                          child: AutoSizeText(
                                            widget.vendor.description
                                                    .replaceAll(
                                                        new RegExp('&rlm;'),
                                                        ' ') ??
                                                "",
                                            style: textStyle,
                                            textAlign: TextAlign.end,
                                            maxLines: 4,
                                          ),
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
                                          style: titleTextStyle,
                                        ),
                                        SizedBox(width: 12 * factor),
                                        Expanded(
                                          child: AutoSizeText(
                                            widget.vendor.description
                                                    .replaceAll(
                                                        new RegExp('&rlm;'),
                                                        ' ') ??
                                                "",
                                            style: textStyle,
                                            textAlign: TextAlign.end,
                                            maxLines: 4,
                                          ),
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
                                              _launchWeb(
                                                  widget.vendor.media.fb);
                                            }),
                                        InkWell(
                                            child: Image.asset(
                                              'assets/twitter.webp',
                                              width: 45 * factor,
                                              height: 45 * factor,
                                            ),
                                            onTap: () {
                                              _launchWeb(
                                                  widget.vendor.media.twitter);
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
                                              _launchWeb(
                                                  widget.vendor.media.insta);
                                            }),
                                        InkWell(
                                            child: Image.asset(
                                              'assets/youtub.webp',
                                              width: 45 * factor,
                                              height: 45 * factor,
                                            ),
                                            onTap: () {
                                              _launchWeb(
                                                  widget.vendor.media.yt);
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Text(
                                            widget.vendor.fields[index].name);
                                      },
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
                                    childAspectRatio: MediaQuery.of(context)
                                            .size
                                            .aspectRatio *
                                        3 /
                                        2,
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    physics: NeverScrollableScrollPhysics(),
                                    children: List.generate(
                                        products.length,
                                        (index) => OfferItem(
                                            offer: products[index])).toList())
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
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        Future<String> _getImage(
                                            String videoPathUrl) async {
                                          print(videoPathUrl);
                                          if (videoPathUrl.contains("embed")) {
                                            final a = Uri.parse(videoPathUrl);
                                            print(a.pathSegments.last);
                                            return 'https://img.youtube.com/vi/${a.pathSegments.last}/0.jpg';
                                          } else {
                                            final Uri uri =
                                                Uri.parse(videoPathUrl);
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
                                                        videos.video_link_2 ??
                                                            "")
                                                    : index == 2
                                                        ? _launchWeb(videos
                                                                .video_link_3 ??
                                                            "")
                                                        : _launchWeb(videos
                                                                .video_link_4 ??
                                                            "");
                                          },
                                          child: Stack(
                                            children: [
                                              FutureBuilder<String>(
                                                future: index == 0
                                                    ? _getImage(widget.vendor
                                                        .videos.video_link_1)
                                                    : index == 1
                                                        ? _getImage(widget
                                                            .vendor
                                                            .videos
                                                            .video_link_2)
                                                        : index == 2
                                                            ? _getImage(widget
                                                                .vendor
                                                                .videos
                                                                .video_link_3)
                                                            : _getImage(widget
                                                                .vendor
                                                                .videos
                                                                .video_link_4),
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
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (_) => ShowImage(
                                                        image: widget.vendor
                                                            .gallery[index],
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
                                  itemBuilder:
                                      (BuildContext context, int index) {
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
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void _launchUrl(String phone) async {
    var url = "tel:$phone";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchTelegram(String phone) async {
    var whatsappURl_android = "telegram://send?phone=" + phone + "&text= ";
    var whatappURL_ios = "https://wa.me/$phone?text=${Uri.parse(" ")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("telegram no installed")));
      }
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
    var whatsappURl_android = "whatsapp://send?phone=" + phone + "&text= ";
    var whatappURL_ios = "https://wa.me/$phone?text=${Uri.parse(" ")}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunch(whatappURL_ios)) {
        await launch(whatappURL_ios, forceSafariVC: false);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    } else {
      // android , web
      if (await canLaunch(whatsappURl_android)) {
        await launch(whatsappURl_android);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
      }
    }
  }

  showMessage(String tr) async {
    await http.post(Uri.parse(Strings.apiLink + "notify_un_paid_user"), body: {
      "user_id": widget.vendor.userId ?? widget.vendor.id ?? "",
    }, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token
    });

    Fluttertoast.showToast(
        msg: "Denied".tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  PhoneModel phones;

  List<Widget> getPhones()  {

    List<Widget> widgets = [];
    widgets.add(tileOfPhone(widget.vendor.owner_name,widget.vendor.phone,widget.vendor.phone));
    if(phones!=null){
     if(phones.phone1!=null){
       widgets.add(Divider(thickness: 2));
       widgets.add(tileOfPhone(phones.name1,phones.phone1,phones.phone1));
     }
     if(phones.phone2!=null){
       widgets.add(Divider(thickness: 2));
       widgets.add(tileOfPhone(phones.name2,phones.phone2,phones.phone2));
     }
     if(phones.phone3!=null){
       widgets.add(Divider(thickness: 2));
       widgets.add(tileOfPhone(phones.name3,phones.phone3,phones.phone3));
     }
    }
    return widgets;
  }

  Widget tileOfPhone(title,subtitle,phone){
   return SizedBox(
     width:double.infinity,
     height: 100,
     child: ListTile(
        onTap: (){
          widget.vendor.color.contains(
              Strings.red) &&
              RegisterModel
                  .shared.type_id !=
                  "1"
              ? showMessage("")
              : _launchUrl(
              phone);
        },
        title: Text(title??""),
        subtitle: Text(subtitle??""),
        leading: Icon(Icons.phone),
      ),
   );
  }
}
