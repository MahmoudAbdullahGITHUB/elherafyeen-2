import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/user_api.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/auth/change_password.dart';
import 'package:elherafyeen/pages/auth/more_auth/add_vehicle_page.dart';
import 'package:elherafyeen/pages/user/add_product.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/crop_image.dart';
import 'package:elherafyeen/widgets/image_picker_widget.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/regular_text_field.dart';
import 'package:elherafyeen/widgets/rounded_text_field.dart';
import 'package:elherafyeen/widgets/staff/show_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../main.dart';

class UpdateCompany extends StatefulWidget {
  UpdateCompany({Key key}) : super(key: key);

  @override
  _UpdateCompanyState createState() => _UpdateCompanyState();
}

class _UpdateCompanyState extends State<UpdateCompany> {
  var image;
  var nameController = new TextEditingController();
  var phoneController = new TextEditingController();
  var passwordController = new TextEditingController();
  var whatsappCtrl = new TextEditingController();
  var ownerCtrl = new TextEditingController();
  var addressCtrl = new TextEditingController();
  var descCtrl = new TextEditingController();
  var phone2Ctrl = new TextEditingController();
  List<String> galleryImagesBase64 = [];
  var imageString = "";

  String fb = "";
  String insta = "";
  String twitter = "";
  String telegram = "";
  String youtube = "";
  String linkedIn = "";
  String video1;
  String video2;
  String video3;
  String video4;
  var idSet = <String>{};
  var idSetServices = <String>{};
  var idSetBrands = <String>{};
  VendorModel user = null;
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  List<String> galleryImages = [];
  double latitude;
  double longitude;
  var currentLocation;

  var _loading = false;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<Map<String, double>> getCurrentLocation() async {
    Map<String, double> result = {"latitude": 0.0, "longitude": 0.0};
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      result = {
        "latitude": currentLocation.latitude,
        "longitude": currentLocation.longitude
      };
      setState(() {
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
      });
    } catch (e) {
      currentLocation = null;
    }

    return result;
  }

  loadData() async {
    user = await UserApi.getUserData();
    print("mahmoud user" + user.toString());
    await RegisterModel.shared.getUserData();

    if (user != null) {
      phoneController.text = user.phone ?? "";
      nameController.text = user.name ?? "";
      whatsappCtrl.text = user.whatsapp ?? "";
      ownerCtrl.text = user.owner_name ?? "";
      addressCtrl.text = user.address ?? "";
      // maxShippingCtrl.text = user.maximum_load_limit ?? "";
      // shippingType.text = user.shipping_type_name ?? "";
      phone2Ctrl.text = user.phone2 ?? "";
      descCtrl.text = user.description ?? "";
    }
    // if (user.image!=null &&
    //   user != "") {
    //   image = base64Decode(RegisterModel.shared.image);
    // }

    setState(() {});
  }

  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final orientation = MediaQuery.of(context).orientation;

    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 1.5;
//    if (height > 2040) factor = 3.0;
    var textStyle =
        TextStyle(color: HColors.colorPrimaryDark, fontSize: 17 * factor);

    var style = TextStyle(fontSize: 16 * factor, color: HColors.colorPrimary);

    updateData(context) async {
      List<String> provied = [];
      for (var d in idSetServices) {
        provied.add(d);
      }

      List<String> fields = [];
      for (var d in idSet) {
        fields.add(d);
      }
      List<String> brands = [];
      for (var d in idSetBrands) {
        brands.add(d);
      }
      setState(() {
        _loading = true;
      });
      try {
        await UserApi.updateCompany(
          name: nameController.text ?? "",
          phone: phoneController.text ?? "",
          password: passwordController.text ?? "",
          email: "",
          galleryImages: galleryImagesBase64,
          phone2: phone2Ctrl.text ?? "",
          whatsapp: whatsappCtrl.text ?? "",
          address: addressCtrl.text ?? "",
          maxShipping: "",
          desc: descCtrl.text ?? "",
          type_id: user.typeId ?? "",
          yt: youtube ?? "",
          fb: fb ?? "",
          insta: insta ?? "",
          twitter: twitter ?? "",
          linkedIn: linkedIn ?? "",
          telegram: telegram ?? "",
          video1: video1 ?? "",
          video2: video2 ?? "",
          video3: video3 ?? "",
          video4: video4 ?? "",
        );
        setState(() => _loading = false);
        Fluttertoast.showToast(
            msg: "edited".tr(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } catch (e) {
        setState(() => _loading = false);
        Fluttertoast.showToast(
            msg: e.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }

    void _launchWeb(String url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    showSocialDialog(var link, String change) {
      var textCtrl = new TextEditingController();
      showModalBottomSheet(
          context: context,
          barrierColor: Colors.white.withOpacity(0),
          backgroundColor: Colors.white.withOpacity(0),
          builder: (_) => SingleChildScrollView(
                child: Card(
                    margin: EdgeInsets.all(12),
                    color: Colors.white,
                    elevation: 10 * factor,
                    child: Container(
                        height: MediaQuery.of(context).size.height * .8,
                        margin: EdgeInsets.all(12),
                        child: Column(children: [
                          RaisedButton(
                              color: HColors.colorPrimaryDark,
                              onPressed: () {
                                _launchWeb(link);
                              },
                              child: Text(
                                "go".tr(),
                                style: TextStyle(color: Colors.white),
                              )),
                          RegularTextField(
                            controller: textCtrl,
                            labelText: "editLink".tr(),
                            onChanged: (text) {},
                            isEnabled: true,
                            inputType: TextInputType.text,
                            onSubmitted: (text2) {
                              textCtrl.text = text2;
                            },
                            prefixIcon: Icon(
                              FontAwesomeIcons.globeAfrica,
                              color: Colors.grey,
                            ),
                          ),
                          RaisedButton(
                              color: HColors.colorPrimaryDark,
                              onPressed: () {
                                var text = textCtrl.text;
                                if (change == "facebook") {
                                  fb = text;
                                }
                                if (change == "yt") {
                                  youtube = text;
                                }
                                if (change == "linkedin") {
                                  linkedIn = text;
                                }
                                if (change == "twitter") {
                                  twitter = text;
                                }
                                if (change == "insta") {
                                  insta = text;
                                }
                                if (change == "telegram") {
                                  telegram = text;
                                }
                                if (change == "video1") {
                                  video1 = text;
                                  print("video1" + text);
                                }
                                if (change == "video2") {
                                  video2 = text;
                                  print("video2" + text);
                                }
                                if (change == "video3") {
                                  video3 = text;
                                  print("video3" + text);
                                }
                                if (change == "video4") {
                                  video4 = text;
                                  print("video4" + text);
                                }
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Text(
                                "save".tr(),
                                style: TextStyle(color: Colors.white),
                              )),
                        ]))),
              ));
    }

    Future getImage(bool gallery, {bool list: false}) async {
      final pickedFile = await picker.getImage(
          source: gallery ? ImageSource.gallery : ImageSource.camera);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _image = await CropImageMethod(image: _image);
        if (list) {
          List<int> imageBytes = _image.readAsBytesSync();
          print(imageBytes);
          final bytes = await _image.readAsBytes();
          galleryImagesBase64.add(base64Encode(bytes));
          galleryImages.add(_image.path);
          setState(() {});
        } else {
          List<int> imageBytes = _image.readAsBytesSync();
          print(imageBytes);
          final bytes = await _image.readAsBytes();
          imageString = base64Encode(bytes);
          print(imageString);
          setState(() {});
        }
      } else {
        print('No image selected.');
      }
      setState(() {});
    }

    var listOfCars = ListView.builder(
      itemCount:
          user != null && user.vehicles != null ? user.vehicles.length : 0,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: height * .06,
          child: Row(
            children: [
              user.vehicles[index].image != null &&
                      user.vehicles[index].image != ""
                  ? Image.network(
                      user.vehicles[index].image,
                      width: 22 * factor,
                      height: 22 * factor,
                    )
                  : SizedBox(),
              // Image.asset(
              //   "assets/20180412-Honda-Motorcycle-logo-3000x2500.png",
              //   width: 22 * factor,
              //   height: 22 * factor,
              // ),
              Expanded(
                  child: Text(
                user.vehicles[index].brand_name,
                style: style,
              )),
              Icon(
                Icons.close,
                color: HColors.colorPrimary,
              )
            ],
          ),
        );
      },
    );

    var userInfo = Column(
      children: [
        InkWell(
          onTap: () {
            if (RegisterModel.shared.token != "") {
              ImagePickerWidget(
                  context: context,
                  onTap: (value) {
                    getImage(value);
                  });
            }
          },
          child: ClipOval(
            child: user != null && user.logo != null && user.logo != ""
                ? Image.network(
                    user.logo,
                    width: width * .24,
                    height: height * .167,
                    fit: BoxFit.fill,
                  )
                : Image.asset(
                    "assets/asset-207.png",
                    width: width * .2,
                    height: height * .2,
                  ),
          ),
        ),
        ElevatedButton(
            style: ButtonStyle(
              shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
                new RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(height * .03))),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(HColors.colorPrimaryDark),
            ),
            child: Text(
              "change_password".tr(),
              style: TextStyle(color: HColors.colorButton),
            ),
            onPressed: () {
              Navigator.push(context,
                  CupertinoPageRoute(builder: (_) => ChangePassword()));
            }),
        ElevatedButton(
            style: ButtonStyle(
              shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
                new RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(height * .03))),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(HColors.colorPrimaryDark),
            ),
            child: Text(
              "change_location".tr(),
              style: TextStyle(color: HColors.colorButton),
            ),
            onPressed: () async {
              await getCurrentLocation();
              final response = await http.post(
                  Uri.parse(Strings.apiLink +
                      "update_location?lang=${RegisterModel.shared.lang}"),
                  body: {
                    "lat": latitude.toString(),
                    "lng": longitude.toString(),
                  },
                  headers: {
                    "Authorization": "Bearer " + RegisterModel.shared.token
                  });
              final body = json.decode(response.body);
              print("mahmoud" + body.toString());

              if (body['status'] == "failed") {
                print(body['errors']);
                setState(() => _loading = false);
                Fluttertoast.showToast(
                    msg: body["errors"].toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                setState(() => _loading = false);
                Fluttertoast.showToast(
                    msg: "تم تغيير الموقع بنجاح",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                print(body.toString());
              }
            }),
        if (user.typeId == "9")
          ElevatedButton(
              style: ButtonStyle(
                shape: ButtonStyleButton.allOrNull<OutlinedBorder>(
                  new RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.all(Radius.circular(height * .03))),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(HColors.colorPrimaryDark),
              ),
              child: Text(
                "add_product".tr(),
                style: TextStyle(color: HColors.colorButton),
              ),
              onPressed: () async {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (_) => AddProductPage()));
              }),
        SizedBox(height: 10),
        Text("yourQr".tr()),
        SizedBox(height: 6),
        Container(
          width: width * .2,
          height: height * .15,
          child: SfBarcodeGenerator(
            value: default_qr,
            symbology: QRCode(),
            barColor: Colors.black,
          ),
        ),
        SizedBox(height: 10),
        Container(
          width: width,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RoundedTextField(
                  labelText: "name".tr(),
                  controller: nameController,
                  onChanged: (text) {},
                  isEnabled: true,
                  inputType: TextInputType.text,
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.grey,
                  ),
                ),
                // RoundedTextField(
                //   labelText: "phone".tr(),
                //   controller: phoneController,
                //   onChanged: (text) {},
                //   isEnabled: false,
                //   inputType: TextInputType.number,
                //   prefixIcon: Icon(
                //     Icons.phone,
                //     color: Colors.grey,
                //   ),
                // ),
                RoundedTextField(
                  labelText: "phone2".tr(),
                  controller: phone2Ctrl,
                  onChanged: (text) {},
                  isEnabled: true,
                  inputType: TextInputType.number,
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                ),
                RoundedTextField(
                  labelText: "whatsapp".tr(),
                  controller: whatsappCtrl,
                  onChanged: (text) {},
                  isEnabled: true,
                  inputType: TextInputType.number,
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                ),
                RoundedTextField(
                  labelText: "owner_name".tr(),
                  controller: ownerCtrl,
                  onChanged: (text) {},
                  isEnabled: true,
                  inputType: TextInputType.text,
                  prefixIcon: Icon(
                    Icons.account_box_outlined,
                    color: Colors.grey,
                  ),
                ),
                RoundedTextField(
                  labelText: "description".tr(),
                  controller: descCtrl,
                  onChanged: (text) {},
                  inputType: TextInputType.text,
                  prefixIcon: Icon(
                    Icons.description,
                    color: Colors.grey,
                  ),
                ),
                RoundedTextField(
                  labelText: "address".tr(),
                  controller: addressCtrl,
                  onChanged: (text) {},
                  inputType: TextInputType.text,
                  prefixIcon: Icon(
                    Icons.description,
                    color: Colors.grey,
                  ),
                ),
                // Image.asset(
                //   "assets/noun_QR Code_-84.png",
                //   width: width * .3,
                //   height: height * .2,
                // ),
                listOfCars
              ],
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HColors.colorPrimaryDark,
        title: Text(
          "profile".tr(),
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Builder(builder: (context) {
        return user == null
            ? Container(
                child: Center(
                  child: LoadingIndicator(
                    color: HColors.colorPrimaryDark,
                  ),
                ),
              )
            : ModalProgressHUD(
                progressIndicator: LoadingIndicator(
                  color: HColors.colorPrimaryDark,
                ),
                inAsyncCall: _loading,
                child: Container(
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              userInfo,
                              (user.gallery != null &&
                                      user.gallery.length != 0 &&
                                      user.typeId == "9")
                                  ? GridView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: user.gallery.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (_) => ShowImage(
                                                          image: user
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
                                                  user.gallery[index],
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
                              if (user.typeId == "9")
                                Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(width * .02)),
                                        side: BorderSide(
                                            color: HColors.colorPrimaryDark,
                                            width: 1 * factor)),
                                    color: Colors.white,
                                    child: Container(
                                      margin: EdgeInsets.all(width * .02),
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: galleryImages.length + 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index == 0) {
                                            return RaisedButton(
                                              onPressed: () {
                                                ImagePickerWidget(
                                                    context: context,
                                                    onTap: (value) {
                                                      getImage(value,
                                                          list: true);
                                                    });
                                              },
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              width * .04)),
                                                  side: BorderSide(
                                                      color: Colors.grey)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: HColors
                                                        .colorPrimaryDark,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                          return Container(
                                            width: width * .2,
                                            height: height * .12,
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              width * .02)),
                                                  child: Image.file(
                                                      File(galleryImages[
                                                          index - 1]),
                                                      width: width * .2,
                                                      height: height * .12,
                                                      fit: BoxFit.fill),
                                                ),
                                                Positioned.fill(
                                                    child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: InkWell(
                                                    onTap: () {
                                                      galleryImages
                                                          .removeAt(index - 1);
                                                      galleryImagesBase64
                                                          .removeAt(index - 1);
                                                      setState(() {});
                                                    },
                                                    child: Image.asset(
                                                      'assets/Icon ionic-ios-close-circle.png',
                                                      width: width * .08,
                                                      height: height * .08,
                                                    ),
                                                  ),
                                                ))
                                              ],
                                            ),
                                          );
                                        },
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 5.0,
                                          mainAxisSpacing: 5.0,
                                        ),
                                      ),
                                    )),
                              user.media != null
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
                                                showSocialDialog(
                                                    user.media.fb, "facebook");
                                              }),
                                          InkWell(
                                              child: Image.asset(
                                                'assets/twitter.webp',
                                                width: 45 * factor,
                                                height: 45 * factor,
                                              ),
                                              onTap: () {
                                                showSocialDialog(
                                                    user.media.twitter,
                                                    "twitter");
                                              }),
                                          InkWell(
                                              child: Image.asset(
                                                'assets/linkedin.webp',
                                                width: 45 * factor,
                                                height: 45 * factor,
                                              ),
                                              onTap: () {
                                                showSocialDialog(
                                                    user.media.linkedin,
                                                    "linkedin");
                                              }),
                                          InkWell(
                                              child: Image.asset(
                                                'assets/insta.webp',
                                                width: 45 * factor,
                                                height: 45 * factor,
                                              ),
                                              onTap: () {
                                                showSocialDialog(
                                                    user.media.insta, "insta");
                                              }),
                                          InkWell(
                                              child: Image.asset(
                                                'assets/youtub.webp',
                                                width: 45 * factor,
                                                height: 45 * factor,
                                              ),
                                              onTap: () {
                                                showSocialDialog(
                                                    user.media.yt, "yt");
                                              }),
                                          InkWell(
                                              child: Image.asset(
                                                'assets/telegram.webp',
                                                width: 45 * factor,
                                                height: 45 * factor,
                                              ),
                                              onTap: () {
                                                showSocialDialog(
                                                    user.media.telegram,
                                                    "telegram");
                                              }),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              (user != null && user.videos != null)
                                  ? Text(
                                      "videos".tr(),
                                      style: textStyle,
                                    )
                                  : SizedBox(),
                              (user.videos != null)
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
                                            if (videoPathUrl
                                                .contains("embed")) {
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
                                              var videos = user.videos;
                                              index == 0
                                                  ? showSocialDialog(
                                                      videos.video_link_1 ?? "",
                                                      "video1")
                                                  : index == 1
                                                      ? showSocialDialog(
                                                          videos.video_link_2 ??
                                                              "",
                                                          "video2")
                                                      : index == 2
                                                          ? showSocialDialog(
                                                              videos.video_link_3 ??
                                                                  "",
                                                              "video3")
                                                          : showSocialDialog(
                                                              videos.video_link_4 ??
                                                                  "",
                                                              "video4");
                                            },
                                            child: Stack(
                                              children: [
                                                FutureBuilder<String>(
                                                  future: index == 0
                                                      ? _getImage(user
                                                          .videos.video_link_1)
                                                      : index == 1
                                                          ? _getImage(user
                                                              .videos
                                                              .video_link_2)
                                                          : index == 2
                                                              ? _getImage(user
                                                                  .videos
                                                                  .video_link_3)
                                                              : _getImage(user
                                                                  .videos
                                                                  .video_link_4),
                                                  initialData: "",
                                                  builder: (context, snapshot) {
                                                    return Image.network(
                                                        snapshot.data
                                                            .toString());
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
                              if (user.typeId == "3")
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (_) => AddVehiclePage()));
                                  },
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        "assets/Group 2715.png",
                                        width: width * .3,
                                        height: height * .08,
                                      ),
                                      Container(
                                        width: width * .3,
                                        height: height * .08,
                                        child: Center(
                                            child: Text("إضافة مركبة",
                                                style: style)),
                                      )
                                    ],
                                  ),
                                ),
                              RaisedButton(
                                onPressed: () {
                                  updateData(context);
                                },
                                color: HColors.colorPrimaryDark,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(height * .04))),
                                child: Text(
                                  "update".tr(),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
      }),
    );
  }
}
