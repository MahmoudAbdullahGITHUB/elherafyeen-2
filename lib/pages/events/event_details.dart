import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/api/user_api.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/online_store/src/themes/light_color.dart';
import 'package:elherafyeen/pages/chat/messages_page.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/staff/show_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetails extends StatefulWidget {
  int fetchDetails;

  EventDetails({Key key, this.vendor, this.fetchDetails: -1}) : super(key: key);
  VendorModel vendor;

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  VendorModel vendorDetails;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    fetchDetails();
  }

  fetchDetails() async {
    print("MAHMOUD JAMAL${widget.vendor.phone}");
    vendorDetails = await UserApi.getEvent(id: widget.vendor.id);

    if (vendorDetails != null) widget.vendor = vendorDetails;
    setState(() {});

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
              onPressed: () => Navigator.pop(context))),
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
                                  Container(
                                    width: width * .5,
                                    child: AutoSizeText(
                                        widget.vendor.name ?? "",
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            color: HColors.colorPrimaryDark,
                                            fontSize: 20 * factor,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  SizedBox(width: 8),
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
                            Padding(
                                padding: EdgeInsets.all(16.0 * factor),
                                child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        double.tryParse(
                                                    widget.vendor.price_after)
                                                .toStringAsFixed(1) ??
                                            "",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      SizedBox(width: 6),
                                      Text("LE".tr(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: LightColor.red,
                                          )),
                                    ])),
                            Padding(
                              padding: EdgeInsets.all(16.0 * factor),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: Size(width * .28, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      side: BorderSide(
                                          width: 2,
                                          color: HColors.colorPrimaryDark),
                                    ),
                                    onPressed: () {
                                      showPayment(widget.vendor.id);
                                    },
                                    child: Text("buy".tr()),
                                  ),
                                  OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: Size(width * .28, 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      side: BorderSide(
                                          width: 2,
                                          color: HColors.colorPrimaryDark),
                                    ),
                                    onPressed: () {
                                      generateQrCode(widget.vendor.id);
                                    },
                                    child: Text("enter".tr()),
                                  ),
                                  if (RegisterModel.shared.type_id == "1")
                                    OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: Size(width * .28, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        side: BorderSide(
                                            width: 2,
                                            color: HColors.colorPrimaryDark),
                                      ),
                                      onPressed: () {
                                        checkPayment(widget.vendor.id);
                                      },
                                      child: Text("check".tr()),
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
                                                _launchMapsUrl(
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
                                                Navigator.push(
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
                                              _launchUrl(widget.vendor.phone);
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
                                              url(widget.vendor.whatsapp);
                                            }),
                                      ),
                                      Text("whatsapp".tr(), style: textStyle)
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                                            textAlign: TextAlign.start,
                                            style: textStyle,
                                            maxLines: 4,
                                          ),
                                        )
                                      ],
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

  showPayment(eventId) async {
    String phone = await UserApi.getActivePhone();
    var resetController = TextEditingController();
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.white.withOpacity(0),
        builder: (_) => Card(
              margin: EdgeInsets.all(12),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("sendPaymentTo".tr() + phone),
                    SizedBox(height: 10),
                    TextField(
                      controller: resetController,
                      decoration: InputDecoration(hintText: "resetNum".tr()),
                    ),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity - 20, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        side: BorderSide(
                            width: 2, color: HColors.colorPrimaryDark),
                      ),
                      onPressed: () async {
                        try {
                          bool result = await UserApi.addUserToEvent(
                              eventId: eventId,
                              receiptNumber: resetController.text);
                          if (result) {
                            Fluttertoast.showToast(
                                msg:
                                    "تم الدفع بنجاح شكراً لكم لإستخدام تطبيق الحرفيين");
                            Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                    builder: (_) => TabBarPage()),
                                (route) => false);
                          }
                        } catch (e) {
                          Fluttertoast.showToast(msg: e.toString());
                        }
                      },
                      child: Text("buy".tr()),
                    ),
                  ],
                )),
              ),
            ));
  }

  generateQrCode(eventId) async {
    showModalBottomSheet(
        context: context,
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.white.withOpacity(0),
        builder: (_) => Card(
              margin: EdgeInsets.all(12),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SfBarcodeGenerator(
                      value: "${RegisterModel.shared.id}",
                      symbology: QRCode(),
                    ),
                  ],
                )),
              ),
            ));
  }

  checkPayment(eventId) async {
    String barcodeScanRes = "-1";
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    UserApi.getSubscribedUser(eventId: eventId, userId: barcodeScanRes)
        .then((bool checkUser) {
      try {
        if (checkUser) {
          showModalBottomSheet(
              context: context,
              barrierColor: Colors.white.withOpacity(0),
              backgroundColor: Colors.white.withOpacity(0),
              builder: (_) => Card(
                    margin: EdgeInsets.all(12),
                    color: Colors.white,
                    child: Container(
                      child:
                          Center(child: Image.asset("assets/order_sent.png")),
                    ),
                  ));
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    });
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
}
