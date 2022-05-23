import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/vendor_api.dart';
import 'package:elherafyeen/bloc/vehicle/vehicle_bloc.dart';
import 'package:elherafyeen/bloc/vendor/vendor_bloc.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/store_type_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/crop_image.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/widgets/add_image_widget.dart';
import 'package:elherafyeen/widgets/date_picker.dart';
import 'package:elherafyeen/widgets/image_picker_widget.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/rounded_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddOfferPage extends StatefulWidget {
  VendorModel user;

  AddOfferPage({Key key, this.user}) : super(key: key);

  @override
  _AddOfferPageState createState() => _AddOfferPageState();
}

class _AddOfferPageState extends State<AddOfferPage> {
  var typeCategory = "0";
  var typeStore = "0";

  var nameController = TextEditingController();
  var phoneOneCtrl = TextEditingController();
  var pricebeforeCtrl = TextEditingController();
  var priceAfterCtrl = TextEditingController();
  var ownerNameController = TextEditingController();
  var startDate = TextEditingController();
  var endDate = TextEditingController();
  var idSet = <String>{};
  FocusNode colorFocus = FocusNode();
  FocusNode modelFocus = FocusNode();
  FocusNode dateFocus = FocusNode();
  FocusNode capacityFocus = FocusNode();
  FocusNode typeFocus = FocusNode();
  FocusNode brandFocus = FocusNode();
  FocusNode shapeFocus = FocusNode();
  FocusNode manualFocus = FocusNode();
  FocusNode fuelFocus = FocusNode();

  File _image;
  var imageString = "";
  final picker = ImagePicker();

  var _loading = false;

  var currentIndex = -1;
  var idOfBrand = "";
  List<String> idsOfBrand = [];

  bool chooseAllBrands = false;

  var idSetBrands = <String>{};

  List<bool> brandValues = [];
  DateTime _dateTime;
  DateFormat dateFormat;

  @override
  void initState() {
    super.initState();
    widget.user.brands.forEach((element) {
      brandValues.add(false);
    });

    _dateTime = DateTime.now();
    dateFormat = DateFormat("yyyy-MM-dd", "en");
    startDate.text = dateFormat.format(_dateTime) ?? "";
    setState(() {});
  }

  Future getImage(bool gallery) async {
    final pickedFile = await picker.getImage(
        source: gallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _image = await CropImageMethod(image: _image);
      setState(() async {
        List<int> imageBytes = _image.readAsBytesSync();
        print(imageBytes);
        final bytes = await _image.readAsBytes();
        imageString = base64Encode(bytes);
        print(imageString);
      });
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  List<CategoryModel> listCategories = [];
  List<StoreTypeModel> storeTypes = [];
  List<bool> storeTypeValues = [];
  List<String> services = [];
  double latitude;
  double longitude;
  var currentLocation;

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

    void showBrands() {
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext builder) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter newMyState) {
              return CupertinoPageScaffold(
                  backgroundColor: Colors.grey.shade100,
                  navigationBar: CupertinoNavigationBar(
                    middle: Text("brands".tr()),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  child: Container(
                    height: height * .5,
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: ListView.builder(
                      itemCount: widget.user.brands.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            onTap: () {
                              currentIndex = index;
                              Navigator.pop(context);
                              setState(() {});
                            },
                            child: Column(
                              children: [
                                CheckboxListTile(
                                  title: Text(widget.user.brands[index].name),
                                  value: brandValues[index],
                                  onChanged: (newValue) {
                                    try {
                                      print("must change");

                                      if (!idSetBrands.contains(
                                          widget.user.brands[index].id)) {
                                        if (idSetBrands.length >= 2) {
                                          print("hered");
                                          idOfBrand =
                                              idSetBrands.first.toString();

                                          Fluttertoast.showToast(
                                              msg: "brand_exceed".tr());
                                        } else {
                                          print("here");
                                          idSetBrands.add(
                                              widget.user.brands[index].id);
                                          setState(() {
                                            if (idSetBrands.isNotEmpty)
                                              idOfBrand =
                                                  idSetBrands.first.toString();
                                          });
                                          brandValues[index] = true;
                                        }
                                      } else {
                                        print("hersed");

                                        for (var brand in widget.user.brands) {
                                          if (idSetBrands.contains(brand.id)) {
                                            idSetBrands.remove(brand.id);
                                          }
                                        }
                                        idOfBrand = "";
                                        brandValues[index] = false;
                                      }
                                      print(idOfBrand.toString());
                                      setState(() {});
                                      newMyState(() {});
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  },
                                  controlAffinity: ListTileControlAffinity
                                      .leading, //  <-- leading Checkbox
                                ),
                                Divider(),
                              ],
                            ));
                      },
                    ),
                  ));
            });
          });
    }

    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return Scaffold(
        appBar: AppBar(
          title: Text("addOffer".tr()),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  return VendorBloc()..add(LoadingEventsForMarket());
                },
              ),
            ],
            child: Builder(builder: (context) {
              _addVehicleButtonPressed() async {
                setState(() => _loading = true);
                await getCurrentLocation();
                try {
                  print("mahmoud " + idOfBrand.toString());
                  await VendorApi.addOffer(
                      context: context,
                      list: idSetBrands,
                      phone: widget.user.phone.toString(),
                      id: widget.user.userId.toString(),
                      brand: idOfBrand,
                      desc: nameController.text,
                      date_from: startDate.text,
                      date_to: endDate.text,
                      price_before: pricebeforeCtrl.text,
                      price_after: priceAfterCtrl.text,
                      logo: imageString);
                  setState(() => _loading = false);
                  errorSnackBar("تم الإضافة بنجاح...", context, success: true);
                  Navigator.pop(context);
                } catch (e) {
                  setState(() => _loading = false);

                  errorSnackBar(e.toString(), context);
                }
              }

              return BlocListener<VendorBloc, VendorState>(
                listener: (context, state) async {
                  if (state is ErrorVendor) {
                    print('there is error');

                    ///Function that show snackBar
                    ///required [error] content of error and [context]
                    errorSnackBar(state.error, context);
                  }
                  if (state is VendorAdded) {
                    if (state.result)
                      errorSnackBar("تم الإضافة بنجاح...", context,
                          success: true);
                  }
                },
                child: BlocBuilder<VendorBloc, VendorState>(
                    builder: (context, state) {
                  if (state is DataLoaddedMarket) {
                    listCategories = state.categories;
                    storeTypes = state.storeTypes;

                    if (typeCategory == "0") {
                      listCategories.insert(
                          0,
                          CategoryModel(
                              id: "-1", name: "choose category".tr()));
                      typeCategory = listCategories[0].id;
                    }
                    if (typeStore == "0") {
                      for (var i in storeTypes) {
                        storeTypeValues.add(false);
                      }
                    }
                  }

                  if (state is LoadingCategories) {
                    return Container(
                      child: Center(
                          child: LoadingIndicator(
                        color: HColors.colorPrimaryDark,
                      )),
                    );
                  }
                  return ModalProgressHUD(
                    inAsyncCall: _loading,
                    progressIndicator: LoadingIndicator(
                      color: HColors.colorPrimaryDark,
                    ),
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _image != null
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
                                    title: "OfferPhoto".tr(),
                                    onTap: () {
                                      ImagePickerWidget(
                                          context: context,
                                          onTap: (value) {
                                            getImage(value);
                                          });
                                    }),
                            RoundedTextField(
                              labelText: "nameOfOffer".tr(),
                              controller: nameController,
                              onChanged: (text) {},
                              // focusNode: manualFocus,
                              inputType: TextInputType.text,
                            ),
                            RoundedTextField(
                              labelText: "price_before".tr(),
                              controller: pricebeforeCtrl,
                              onChanged: (text) {},
                              isEnabled: true,
                              // focusNode: colorFocus,
                              inputType: TextInputType.number,
                            ),
                            RoundedTextField(
                              labelText: "price_after".tr(),
                              controller: priceAfterCtrl,
                              onChanged: (text) {},
                              isEnabled: true,
                              // focusNode: colorFocus,
                              inputType: TextInputType.number,
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
                                padding: EdgeInsets.all(10 * factor),
                                child: Row(children: [
                                  Expanded(
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text("startDate".tr()),
                                        SizedBox(height: 10.0),
                                        DateSelectFormField(
                                          style: TextStyle(
                                              fontSize: 25.0,
                                              locale: Locale("en", ""),
                                              color: HColors.colorPrimaryDark,
                                              fontWeight: FontWeight.bold),
                                          onValidated: (String value) {
                                            print("mmmmmmmmm" + value);
                                            startDate.text = value;
                                          },
                                        )
                                      ]))
                                ]),
                              ),
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
                                padding: EdgeInsets.all(10.0 * factor),
                                child: Row(children: [
                                  Expanded(
                                      child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                        Text("endDate".tr()),
                                        SizedBox(height: 10.0),
                                        DateSelectFormField(
                                          style: TextStyle(
                                              locale: Locale("en", ""),
                                              fontSize: 25.0,
                                              color: HColors.colorPrimaryDark,
                                              fontWeight: FontWeight.bold),
                                          onValidated: (String value) {
                                            print("mmmmmmmmm" + value);

                                            endDate.text = value;
                                          },
                                        )
                                      ]))
                                ]),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showBrands();
                              },
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(height * .04)),
                                  side: new BorderSide(
                                      color: Colors.grey, width: 1),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(10.0 * factor),
                                  child: Row(children: [
                                    Text(idOfBrand != ""
                                        ? widget.user.brands
                                            .firstWhere((element) =>
                                                element.id == idOfBrand)
                                            .name
                                        : "brands".tr())
                                  ]),
                                ),
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
                                  child: state is! LoadingAddVehicle
                                      ? Text(
                                          "ok".tr(),
                                          style: TextStyle(
                                              color: HColors.colorButton),
                                        )
                                      : CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                              HColors.colorButton),
                                          strokeWidth: .6),
                                  onPressed: () {
                                    _addVehicleButtonPressed();
                                  }),
                            )
                          ],
                        )),
                  );
                }),
              );
            })));
  }
}
