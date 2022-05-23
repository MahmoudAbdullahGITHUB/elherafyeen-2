import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/api/user_api.dart';
import 'package:elherafyeen/api/vehicle_api.dart';
import 'package:elherafyeen/api/vendor_api.dart';
import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/search_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/auth/change_password.dart';
import 'package:elherafyeen/pages/cars/my_products.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/crop_image.dart';
import 'package:elherafyeen/widgets/add_image_widget.dart';
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
import 'add_offer.dart';
import 'add_product.dart';

class UpdateVendor extends StatefulWidget {
  int idOfStaff;

  UpdateVendor({Key key, this.idOfStaff: -1}) : super(key: key);

  @override
  _UpdateVendorState createState() => _UpdateVendorState();
}

class _UpdateVendorState extends State<UpdateVendor> {
  VendorModel user = null;
  var typeCategory = "0";
  var typeStore = "0";
  var classificationId = "0";
  var workingHoursId = "0";
  var placeTypesId = "0";
  var _loading = false;
  var addressController = TextEditingController();
  var phoneCtrl = TextEditingController();
  var whatsCtrl = TextEditingController();
  var descCtrl = TextEditingController();
  var ownerNameController = TextEditingController();
  var nameController = TextEditingController();
  var idSet = <String>{};
  var idSetServices = <String>{};
  var idSetBrands = <String>{};
  File _image;
  var imageString = "";
  List<String> galleryImagesBase64 = [];
  final picker = ImagePicker();
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

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    user = await UserApi.getUserData();
    print("mahmoud user " + user.toString());
    await RegisterModel.shared.getUserData();
    // setState(() {});
    if (user != null && user.typeId == "2") {
      await HomeApi.fetchVendor(vendor_id: user.id);
      print("mahmoud vendro" + user.toString());
      var response = await VendorApi.fetchVendorServices();
      final body = json.decode(response.body);
      if (body != null) {
        vendorFields = List<SearchModel>.from(
            body['result']['fields'].map((data) => SearchModel.fromMap(data)));

        brands = await VehicleApi.fetchBrands(categoryId: user.category_id);
        classifications = List<CategoryModel>.from(body['result']
                ['classifications']
            .map((data) => CategoryModel.fromMap(data)));

        placeTypes = List<CategoryModel>.from(body['result']['placeTypes']
            .map((data) => CategoryModel.fromMap(data)));

        workingHours = List<CategoryModel>.from(body['result']['workingHours']
            .map((data) => CategoryModel.fromMap(data)));
        servicesIntroduced = List<CategoryModel>.from(body['result']['services']
            .map((data) => CategoryModel.fromMap(data)));
      }

      if (typeStore == "0") {
        for (var i in vendorFields) {
          int temp = 0;
          for (var field in user.fields) {
            if (field.id == i.id) {
              storeTypeValues.add(true);
              idSet.add(field.id);
              temp = 1;
            }
          }
          if (temp == 0) storeTypeValues.add(false);
        }
        for (var i in servicesIntroduced) {
          int temp = 0;
          for (var service in user.services) {
            if (service.id == i.id) {
              servicesValues.add(true);
              idSetServices.add(service.id);
              temp = 1;
            }
          }
          if (temp == 0) servicesValues.add(false);
        }
        for (var i in brands) {
          int temp = 0;
          for (var brand in user.brands) {
            if (brand.id == i.id) {
              brandValues.add(true);
              temp = 1;
              idSetBrands.add(brand.id);
            }
          }
          if (temp == 0) brandValues.add(false);
        }
      }

      if (workingHoursId == "0") {
        workingHours.insert(
            0, CategoryModel(id: "-1", name: "workingHours".tr()));
        workingHoursId = workingHours[0].id;
        for (var workH in workingHours) {
          if (user.working_hours_name == workH.name) {
            workingHoursId = workH.id;
          }
        }
      }
      if (classificationId == "0") {
        classifications.insert(
            0, CategoryModel(id: "-1", name: "centerSize".tr()));
        classificationId = classifications[0].id;
        for (var workH in classifications) {
          if (user.classification_id == workH.id) {
            classificationId = workH.id;
          }
        }
      }
      if (placeTypesId == "0") {
        placeTypes.insert(0, CategoryModel(id: "-1", name: "serviceType".tr()));
        placeTypesId = placeTypes[0].id;
        for (var workH in placeTypes) {
          if (user.place_id == workH.id) {
            placeTypesId = workH.id;
          }
        }
      }
    }

    if (user != null) {
      phoneCtrl.text = user.phone ?? "";
      nameController.text = user.name ?? "";
      whatsCtrl.text = user.whatsapp ?? "";
      ownerNameController.text = user.owner_name ?? "";
      addressController.text = user.address ?? "";
      descCtrl.text = user.description ?? "";
    }
    // if (user.image!=null &&
    //   user != "") {
    //   image = base64Decode(RegisterModel.shared.image);
    // }

    setState(() {});
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

  List<CategoryModel> listCategories = [];
  List<SearchModel> vendorFields = [];
  List<CategoryModel> servicesIntroduced = [];
  List<bool> storeTypeValues = [];
  List<bool> servicesValues = [];
  List<bool> brandValues = [];
  bool chooseAllBrands = false;
  bool chooseAllFields = false;
  List<String> servicesValuesStrings = [];
  List<CategoryModel> classifications = [];
  List<CategoryModel> placeTypes = [];
  List<CategoryModel> workingHours = [];
  List<BrandModel> brands = [];
  List<String> galleryImages = [];
  double latitude;
  double longitude;
  var currentLocation;

  void _launchWeb(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;
    var style = TextStyle(fontSize: 16 * factor, color: HColors.colorPrimary);
    var textStyle =
        TextStyle(color: HColors.colorPrimaryDark, fontSize: 17 * factor);

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

    void _showBottomSheet(BuildContext context) {
      TextEditingController controllerText = new TextEditingController();
      List<CategoryModel> _searchResult = [];

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter mystate) {
            onSearchTextChanged(String text) async {
              _searchResult.clear();
              if (text.isEmpty) {
                setState(() {});
                mystate(() {});
                return;
              }

              servicesIntroduced.forEach((userDetail) {
                if (userDetail.name.contains(text))
                  _searchResult.add(userDetail);
              });

              setState(() {});
              mystate(() {});
            }

            return GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: height,
                color: Color.fromRGBO(0, 0, 0, 0.001),
                child: GestureDetector(
                  onTap: () {},
                  child: DraggableScrollableSheet(
                    initialChildSize: .91,
                    minChildSize: 0.9,
                    maxChildSize: 0.95,
                    builder: (_, controller) {
                      return Container(
                        height: height * .75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8 * factor,
                                  horizontal: 16 * factor),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8 * factor),
                                    child: Center(
                                      child: InkWell(
                                          onTap: () => Navigator.pop(context),
                                          child: Text("done".tr())),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                        height: 48 * factor,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              height * 0.04),
                                          color: HColors.colorPrimaryDark,
                                        ),
                                        child: TextField(
                                          controller: controllerText,
                                          style: TextStyle(color: Colors.white),
                                          onChanged: onSearchTextChanged,
                                          decoration: new InputDecoration(
                                            hintText: 'Search',
                                            border: InputBorder.none,
                                            suffixIcon: new IconButton(
                                              icon: new Icon(
                                                Icons.cancel,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                controllerText.clear();
                                                onSearchTextChanged('');
                                              },
                                            ),
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            prefixIcon: new Icon(Icons.search,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            // CheckboxListTile(
                            //   title: Text(
                            //     "chooseAll".tr(),
                            //     style: TextStyle(
                            //         fontSize: 14 * factor,
                            //         color: HColors.colorPrimaryDark),
                            //   ),
                            //   value: chooseAllFields,
                            //   onChanged: (newValue) {
                            //     try {
                            //       chooseAllFields = newValue;
                            //       if (chooseAllFields) {
                            //         for (var service in servicesIntroduced) {
                            //           if (!idSetServices.contains(service.id)) {
                            //             idSetServices.add(service.id);
                            //           }
                            //         }
                            //         for (int i = 0;
                            //             i < servicesValues.length;
                            //             i++) {
                            //           servicesValues[i] = true;
                            //         }
                            //       } else {
                            //         for (var service in servicesIntroduced) {
                            //           if (idSetServices.contains(service.id)) {
                            //             idSetServices.remove(service.id);
                            //           }
                            //         }
                            //         for (int i = 0;
                            //             i < servicesValues.length;
                            //             i++) {
                            //           servicesValues[i] = false;
                            //         }
                            //       }
                            //       mystate(() {});
                            //       setState(() {});
                            //       mystate(() {});
                            //     } catch (e) {
                            //       print(e.toString());
                            //     }
                            //   },
                            //   controlAffinity: ListTileControlAffinity
                            //       .leading, //  <-- leading Checkbox
                            // ),
                            Expanded(
                              child: ListView.builder(
                                controller: controller,
                                itemCount: (_searchResult.length != 0 ||
                                        controllerText.text.isNotEmpty)
                                    ? _searchResult.length
                                    : servicesIntroduced.length,
                                itemBuilder: (_, index) {
                                  var service;
                                  if (_searchResult.length != 0 ||
                                      controllerText.text.isNotEmpty) {
                                    service = _searchResult[index];
                                  } else {
                                    service = servicesIntroduced[index];
                                  }
                                  return CheckboxListTile(
                                    title: Text(
                                      service.name,
                                      style: TextStyle(
                                          fontSize: 14 * factor,
                                          color: HColors.colorPrimaryDark),
                                    ),
                                    value: servicesValues[index],
                                    onChanged: (newValue) {
                                      servicesValues[index] = newValue;
                                      if (!idSetServices.contains(service.id)) {
                                        idSetServices.add(service.id);
                                      } else {
                                        if (newValue == false) {
                                          if (idSetServices
                                              .contains(service.id)) {
                                            idSetServices.remove(service.id);
                                          }
                                        }
                                      }
                                      setState(() {});
                                      mystate(() {});
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          });
        },
      );
    }

    void _showBrands(BuildContext context) {
      TextEditingController controllerText = new TextEditingController();
      List<BrandModel> _searchResult = [];

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter newMyState) {
            onSearchTextChanged(String text) async {
              _searchResult.clear();
              if (text.isEmpty) {
                setState(() {});
                newMyState(() {});
                return;
              }

              brands.forEach((userDetail) {
                if (userDetail.name.contains(text))
                  _searchResult.add(userDetail);
              });

              setState(() {});
              newMyState(() {});
            }

            return GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: height,
                color: Color.fromRGBO(0, 0, 0, 0.001),
                child: GestureDetector(
                  onTap: () {},
                  child: DraggableScrollableSheet(
                    initialChildSize: .91,
                    minChildSize: 0.9,
                    maxChildSize: 0.95,
                    builder: (_, controller) {
                      return Container(
                        height: height * .75,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(25.0),
                            topRight: const Radius.circular(25.0),
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8 * factor,
                                  horizontal: 16 * factor),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8 * factor),
                                    child: Center(
                                      child: InkWell(
                                          onTap: () => Navigator.pop(context),
                                          child: Text("done".tr())),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                        height: 48 * factor,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 4),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              height * 0.04),
                                          color: HColors.colorPrimaryDark,
                                        ),
                                        child: TextField(
                                          controller: controllerText,
                                          style: TextStyle(color: Colors.white),
                                          onChanged: onSearchTextChanged,
                                          decoration: new InputDecoration(
                                            hintText: 'Search',
                                            border: InputBorder.none,
                                            suffixIcon: new IconButton(
                                              icon: new Icon(
                                                Icons.cancel,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                controllerText.clear();
                                                onSearchTextChanged('');
                                              },
                                            ),
                                            hintStyle:
                                                TextStyle(color: Colors.white),
                                            prefixIcon: new Icon(Icons.search,
                                                color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                            CheckboxListTile(
                              title: Text(
                                "chooseAll".tr(),
                                style: TextStyle(
                                    fontSize: 14 * factor,
                                    color: HColors.colorPrimaryDark),
                              ),
                              value: chooseAllBrands,
                              onChanged: (newValue) {
                                try {
                                  print("must change");
                                  chooseAllBrands = newValue;
                                  if (chooseAllBrands) {
                                    for (var brand in brands) {
                                      if (!idSetBrands.contains(brand.id)) {
                                        idSetBrands.add(brand.id);
                                      }
                                    }
                                    for (int i = 0;
                                        i < brandValues.length;
                                        i++) {
                                      brandValues[i] = true;
                                    }
                                  } else {
                                    for (var brand in brands) {
                                      if (idSetBrands.contains(brand.id)) {
                                        idSetBrands.remove(brand.id);
                                      }
                                    }
                                    for (int i = 0;
                                        i < brandValues.length;
                                        i++) {
                                      brandValues[i] = false;
                                    }
                                  }
                                  newMyState(() {});
                                  setState(() {});
                                  newMyState(() {});
                                } catch (e) {
                                  print(e.toString());
                                }
                              },
                              controlAffinity: ListTileControlAffinity
                                  .leading, //  <-- leading Checkbox
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: controller,
                                itemCount: (_searchResult.length != 0 ||
                                        controllerText.text.isNotEmpty)
                                    ? _searchResult.length
                                    : brands.length,
                                itemBuilder: (_, index) {
                                  var brand;
                                  if (_searchResult.length != 0 ||
                                      controllerText.text.isNotEmpty) {
                                    brand = _searchResult[index];
                                  } else {
                                    brand = brands[index];
                                  }
                                  return CheckboxListTile(
                                    title: Row(
                                      children: [
                                        ClipOval(
                                            child: Image.network(
                                          brand.photo,
                                          width: 55 * factor,
                                          height: 55 * factor,
                                        )),
                                        Text(
                                          brand.name,
                                          style: TextStyle(
                                              fontSize: 14 * factor,
                                              color: HColors.colorPrimaryDark),
                                        ),
                                      ],
                                    ),
                                    value: brandValues[index],
                                    onChanged: (newValue) {
                                      try {
                                        print("must change");
                                        brandValues[index] = newValue;
                                        if (!idSetBrands.contains(brand.id)) {
                                          idSetBrands.add(brand.id);
                                        } else {
                                          if (newValue == false) {
                                            if (idSetBrands
                                                .contains(brand.id)) {
                                              idSetBrands.remove(brand.id);
                                            }
                                          }
                                        }
                                        newMyState(() {});
                                        setState(() {});
                                        newMyState(() {});
                                      } catch (e) {
                                        print("mahmoud " + e.toString());
                                      }
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          });
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("profile".tr()),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
        ),
        body: Builder(builder: (context) {
          _addVehicleButtonPressed() async {
            await getCurrentLocation();
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
              await UserApi.updateUserData(
                galleryImages: galleryImages,
                placeId: placeTypesId,
                classificationId: classificationId,
                workingHour: workingHoursId,
                name: nameController.text ?? "",
                phone: whatsCtrl.text ?? "",
                email: "",
                image: imageString,
                phone2: phoneCtrl.text ?? "",
                whatsapp: whatsCtrl.text ?? "",
                address: addressController.text ?? "",
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
                providedServices: provied,
                fields: fields,
                brands: brands,
              );
              setState(() => _loading = false);
              Fluttertoast.showToast(
                  msg: "edited".tr(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
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

          return ModalProgressHUD(
              inAsyncCall: _loading,
              color: Colors.white,
              progressIndicator: LoadingIndicator(
                color: HColors.colorPrimaryDark,
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: user == null
                    ? Center(
                        child: LoadingIndicator(
                          color: Colors.red,
                        ),
                      )
                    : Column(
                        children: [
                          user != null && user.logo != null && user.logo != ""
                              ? InkWell(
                                  onTap: () {
                                    ImagePickerWidget(
                                        context: context,
                                        onTap: (value) {
                                          getImage(value);
                                        });
                                  },
                                  child: Image.network(
                                    user.logo,
                                    width: width * .2,
                                    height: height * .15,
                                    fit: BoxFit.fill,
                                  ))
                              : _image != null
                                  ? InkWell(
                                      onTap: () {
                                        ImagePickerWidget(
                                            context: context,
                                            onTap: (value) {
                                              getImage(value);
                                            });
                                      },
                                      child: Image.file(_image,
                                          width: width * .2,
                                          height: height * .15),
                                    )
                                  : AddImageWidget(
                                      title: "VendorPhoto".tr(),
                                      onTap: () {
                                        ImagePickerWidget(
                                            context: context,
                                            onTap: (value) {
                                              getImage(value);
                                            });
                                      }),
                          ElevatedButton(
                              style: ButtonStyle(
                                shape:
                                    ButtonStyleButton.allOrNull<OutlinedBorder>(
                                  new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(height * .03))),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HColors.colorPrimaryDark),
                              ),
                              child: Text(
                                "change_password".tr(),
                                style: TextStyle(color: HColors.colorButton),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (_) => ChangePassword()));
                              }),
                          ElevatedButton(
                              style: ButtonStyle(
                                shape:
                                    ButtonStyleButton.allOrNull<OutlinedBorder>(
                                  new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(height * .03))),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HColors.colorPrimaryDark),
                              ),
                              child: Text(
                                "add_product".tr(),
                                style: TextStyle(color: HColors.colorButton),
                              ),
                              onPressed: () async {
                                if (user.pos_sub_id == "1") {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => AddProductPage()));
                                } else
                                  Fluttertoast.showToast(
                                      msg: "pay_for_store".tr());
                              }),
                          if (user.pos_sub_id == "1")
                            ElevatedButton(
                                style: ButtonStyle(
                                  shape: ButtonStyleButton.allOrNull<
                                      OutlinedBorder>(
                                    new RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(height * .03))),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          HColors.colorPrimaryDark),
                                ),
                                child: Text(
                                  "myProducts".tr(),
                                  style: TextStyle(color: HColors.colorButton),
                                ),
                                onPressed: () async {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: (_) => MyProductsPage(
                                                userID: user.userId,
                                              )));
                                }),
                          ElevatedButton(
                              style: ButtonStyle(
                                shape:
                                    ButtonStyleButton.allOrNull<OutlinedBorder>(
                                  new RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(height * .03))),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        HColors.colorPrimaryDark),
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
                                      "Authorization":
                                          "Bearer " + RegisterModel.shared.token
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
                          FlatButton(
                            color: HColors.colorSecondary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(height * .03))),
                            child: Text(
                              "addOffer".tr(),
                              style: TextStyle(color: HColors.colorButton),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (_) =>
                                          AddOfferPage(user: user)));
                            },
                          ),
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
                          RoundedTextField(
                            labelText: "centerName".tr(),
                            controller: nameController,
                            onChanged: (text) {},
                            isEnabled: true,
                            // focusNode: dateFocus,
                            inputType: TextInputType.text,
                          ),
                          Container(
                            padding: EdgeInsets.only(right: 16),
                            alignment: Alignment.centerRight,
                            child: Text("brands".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(fontSize: 14 * factor)),
                          ),
                          InkWell(
                              onTap: () => _showBrands(context),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(height * .04)),
                                  side: new BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            idSetBrands.length != 0
                                                ? idSetBrands.length
                                                        .toString() +
                                                    "Choosed".tr()
                                                : "brands".tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3
                                                .copyWith(
                                                    fontSize: 16 * factor)),
                                      ),
                                      Icon(
                                        idSetBrands.length != 0
                                            ? Icons.check
                                            : Icons.keyboard_arrow_down,
                                        color: idSetBrands.length != 0
                                            ? Colors.green
                                            : Colors.grey.shade600,
                                        size: 16 * factor,
                                      )
                                    ],
                                  ),
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.only(right: 16),
                            alignment: Alignment.centerRight,
                            child: Text("centerSize".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(fontSize: 14 * factor)),
                          ),
                          classifications != null
                              ? Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(height * .04)),
                                    side: new BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: DropdownButton<String>(
                                      value: classificationId.toString(),
                                      underline: SizedBox(),
                                      icon: Icon(
                                        Icons.keyboard_arrow_down,
                                      ),
                                      autofocus: true,
                                      iconSize: 16 * factor,
                                      isExpanded: true,
                                      elevation: 16,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .copyWith(fontSize: 16 * factor),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          CategoryModel model =
                                              classifications.firstWhere((r) =>
                                                  r.id.toString() == newValue);
                                          classificationId = model.id;
                                        });
                                      },
                                      items: classifications
                                          .map<DropdownMenuItem<String>>(
                                              (CategoryModel value) {
                                        return DropdownMenuItem<String>(
                                          value: value.id.toString(),
                                          child: Text(value.name),
                                          onTap: () {
                                            classificationId = value.id;
                                            print(classificationId);
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ))
                              : SizedBox(),
                          Container(
                            padding: EdgeInsets.only(right: 16),
                            alignment: Alignment.centerRight,
                            child: Text("serviceType".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(fontSize: 14 * factor)),
                          ),
                          Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(height * .04)),
                                side: new BorderSide(
                                    color: Colors.grey, width: 1),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: DropdownButton<String>(
                                  value: placeTypesId.toString(),
                                  underline: SizedBox(),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  autofocus: true,
                                  iconSize: 16 * factor,
                                  isExpanded: true,
                                  elevation: 16,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(fontSize: 16 * factor),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      CategoryModel model =
                                          placeTypes.firstWhere((r) =>
                                              r.id.toString() == newValue);
                                      placeTypesId = model.id;
                                    });
                                  },
                                  items: placeTypes
                                      .map<DropdownMenuItem<String>>(
                                          (CategoryModel value) {
                                    return DropdownMenuItem<String>(
                                      value: value.id.toString(),
                                      child: Text(value.name),
                                      onTap: () {
                                        placeTypesId = value.id;
                                        print(placeTypesId);
                                      },
                                    );
                                  }).toList(),
                                ),
                              )),
                          Container(
                            padding: EdgeInsets.only(right: 16),
                            alignment: Alignment.centerRight,
                            child: Text("services".tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3
                                    .copyWith(fontSize: 14 * factor)),
                          ),
                          InkWell(
                              onTap: () => _showBottomSheet(context),
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(height * .04)),
                                  side: new BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            idSetServices.length != 0
                                                ? idSetServices.length
                                                        .toString() +
                                                    "Choosed".tr()
                                                : "services".tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline3
                                                .copyWith(
                                                    fontSize: 16 * factor)),
                                      ),
                                      Icon(
                                        idSetServices.length != 0
                                            ? Icons.check
                                            : Icons.keyboard_arrow_down,
                                        color: idSetServices.length != 0
                                            ? Colors.green
                                            : Colors.grey.shade600,
                                        size: 16 * factor,
                                      )
                                    ],
                                  ),
                                ),
                              )),
                          RoundedTextField(
                            labelText: "company_desc".tr(),
                            controller: descCtrl,
                            onChanged: (text) {},
                            isEnabled: true,
                            // focusNode: capacityFocus,
                            inputType: TextInputType.text,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: vendorFields.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CheckboxListTile(
                                title: Text(
                                  vendorFields[index].field_name,
                                  style: TextStyle(
                                      fontSize: 14 * factor,
                                      color: HColors.colorPrimaryDark),
                                ),
                                value: storeTypeValues[index],
                                onChanged: (newValue) {
                                  setState(() {
                                    storeTypeValues[index] = newValue;
                                    if (newValue) {
                                      if (!idSet
                                          .contains(vendorFields[index].id)) {
                                        idSet.add(vendorFields[index].id);
                                      }
                                    } else {
                                      if (idSet
                                          .contains(vendorFields[index].id)) {
                                        idSet.remove(vendorFields[index].id);
                                      }
                                    }
                                  });
                                },
                                controlAffinity: ListTileControlAffinity
                                    .leading, //  <-- leading Checkbox
                              );
                            },
                          ),
                          RoundedTextField(
                            labelText: "owner_name".tr(),
                            controller: ownerNameController,
                            onChanged: (text) {},
                            // focusNode: manualFocus,
                            inputType: TextInputType.text,
                          ),
                          RoundedTextField(
                            labelText: "company_address".tr(),
                            controller: addressController,
                            onChanged: (text) {},
                            isEnabled: true,
                            // focusNode: capacityFocus,
                            inputType: TextInputType.text,
                          ),
                          RoundedTextField(
                            labelText: "company_phone".tr(),
                            controller: phoneCtrl,
                            onChanged: (text) {},
                            isEnabled: true,
                            // focusNode: capacityFocus,
                            inputType: TextInputType.phone,
                          ),
                          RoundedTextField(
                            labelText: "whatsapp".tr(),
                            controller: whatsCtrl,
                            onChanged: (text) {},
                            isEnabled: true,
                            // focusNode: capacityFocus,
                            inputType: TextInputType.phone,
                          ),
                          Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(height * .04)),
                                side: new BorderSide(
                                    color: Colors.grey, width: 1),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: DropdownButton<String>(
                                  value: workingHoursId.toString(),
                                  underline: SizedBox(),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                  ),
                                  autofocus: true,
                                  iconSize: 16 * factor,
                                  isExpanded: true,
                                  elevation: 16,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3
                                      .copyWith(fontSize: 16 * factor),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      CategoryModel model =
                                          workingHours.firstWhere((r) =>
                                              r.id.toString() == newValue);
                                      workingHoursId = model.id;
                                    });
                                  },
                                  items: workingHours
                                      .map<DropdownMenuItem<String>>(
                                          (CategoryModel value) {
                                    return DropdownMenuItem<String>(
                                      value: value.id.toString(),
                                      child: Text(value.name),
                                      onTap: () {
                                        workingHoursId = value.id;
                                        print(workingHoursId);
                                      },
                                    );
                                  }).toList(),
                                ),
                              )),
                          (user.gallery != null && user.gallery.length != 0)
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
                                                      image:
                                                          user.gallery[index],
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
                                                getImage(value, list: true);
                                              });
                                        },
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(width * .04)),
                                            side:
                                                BorderSide(color: Colors.grey)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              color: HColors.colorPrimaryDark,
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
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(width * .02)),
                                            child: Image.file(
                                                File(galleryImages[index - 1]),
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
                          Container(
                            margin: EdgeInsets.all(height * .03),
                            child: Column(
                              children: [
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
                                                      user.media.fb,
                                                      "facebook");
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
                                                      user.media.insta,
                                                      "insta");
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
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: 4,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 5.0,
                                            mainAxisSpacing: 5.0,
                                          ),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            Future<String> _getImage(
                                                String videoPathUrl) async {
                                              print(videoPathUrl);
                                              if (videoPathUrl
                                                  .contains("embed")) {
                                                final a =
                                                    Uri.parse(videoPathUrl);
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
                                                        videos.video_link_1 ??
                                                            "",
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
                                                        ? _getImage(user.videos
                                                            .video_link_1)
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
                                                    builder:
                                                        (context, snapshot) {
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
                              ],
                            ),
                          ),
                          SizedBox(height: 6 * factor),
                          ButtonTheme(
                            minWidth: width * .85,
                            height: height * 0.08,
                            child: RaisedButton(
                                color: HColors.colorSecondary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(height * .03))),
                                child: Text(
                                  "ok".tr(),
                                  style: TextStyle(color: HColors.colorButton),
                                ),
                                onPressed: () {
                                  _addVehicleButtonPressed();
                                }),
                          )
                        ],
                      ),
              ));
        }));
  }
}
