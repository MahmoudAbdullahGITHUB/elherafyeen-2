import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/vendor_api.dart';
import 'package:elherafyeen/bloc/vehicle/vehicle_bloc.dart';
import 'package:elherafyeen/bloc/vendor/vendor_bloc.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/store_type_model.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/crop_image.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/widgets/add_image_widget.dart';
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

import '../authentication_page.dart';

class AddStorePage extends StatefulWidget {
  bool staff;

  AddStorePage({Key key, this.staff}) : super(key: key);

  @override
  _AddStorePageState createState() => _AddStorePageState();
}

class _AddStorePageState extends State<AddStorePage> {
  var typeCategory = "0";
  var typeStore = "0";

  var storeController = TextEditingController();
  var phoneOneCtrl = TextEditingController();
  var phoneTwoCtrl = TextEditingController();
  var ownerNameController = TextEditingController();
  var addressCtrl = TextEditingController();
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

  @override
  void initState() {
    super.initState();
  }

  Future getImage(bool gallery) async {
    final pickedFile = await picker.getImage(
        source: gallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      List<int> imageBytes = _image.readAsBytesSync();
      print(imageBytes);
      final bytes = await _image.readAsBytes();
      imageString = base64Encode(bytes);
      _image = await CropImageMethod(image: _image);
      setState(() async {
        List<int> imageBytes = _image.readAsBytesSync();
        print(imageBytes);
        final bytes = await _image.readAsBytes();
        imageString = base64Encode(bytes);
        print(imageString);
      });
      print(imageString);
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

    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return Scaffold(
        appBar: AppBar(
          title: Text("storeBorrow".tr()),
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
                await getCurrentLocation();
                List<String> provied = [];
                for (var d in idSet) {
                  provied.add(d);
                }
                setState(() => _loading = true);
                try {
                  await VendorApi.addStore(
                      context: context,
                      staff: widget.staff,
                      owner_name: ownerNameController.text,
                      name: storeController.text,
                      phone: phoneOneCtrl.text,
                      phone2: phoneTwoCtrl.text,
                      lat: latitude.toString(),
                      lng: longitude.toString(),
                      providedServices: provied,
                      address: addressCtrl.text,
                      logo: imageString);

                  if (widget.staff) {
                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (_) => TabBarPage(currentIndex: 0)),
                        (route) => false);
                  } else {
                    Fluttertoast.showToast(
                        msg: "success_login".tr(),
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 17,
                        toastLength: Toast.LENGTH_LONG);

                    Navigator.of(context).pushAndRemoveUntil(
                        CupertinoPageRoute(
                            builder: (_) => AuthenticationPage()),
                        (route) => false);
                  }
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
                                    title: "StorePhoto".tr(),
                                    onTap: () {
                                      ImagePickerWidget(
                                          context: context,
                                          onTap: (value) {
                                            getImage(value);
                                          });
                                    }),
                            RoundedTextField(
                              labelText: "storeName".tr(),
                              controller: storeController,
                              onChanged: (text) {},
                              // focusNode: manualFocus,
                              inputType: TextInputType.text,
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: storeTypes.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CheckboxListTile(
                                  title: Text(storeTypes[index].tool_type_name,
                                      style: TextStyle(
                                          color: HColors.colorPrimaryDark,
                                          fontSize: 16 * factor)),
                                  value: storeTypeValues[index],
                                  onChanged: (newValue) {
                                    setState(() {
                                      storeTypeValues[index] = newValue;
                                      if (!idSet.add(storeTypes[index].id)) {
                                        idSet.add(storeTypes[index].id);
                                      }
                                    });
                                  },
                                  controlAffinity: ListTileControlAffinity
                                      .leading, //  <-- leading Checkbox
                                );
                              },
                            ),
                            RoundedTextField(
                              labelText: "directorName".tr(),
                              controller: ownerNameController,
                              onChanged: (text) {},
                              focusNode: manualFocus,
                              inputType: TextInputType.text,
                            ),
                            RoundedTextField(
                              labelText: "phone_or_whtsapp".tr(),
                              controller: phoneOneCtrl,
                              onChanged: (text) {},
                              isEnabled: true,
                              // focusNode: dateFocus,
                              inputType: TextInputType.number,
                            ),
                            RoundedTextField(
                              labelText: "phone2".tr(),
                              controller: phoneTwoCtrl,
                              onChanged: (text) {},
                              isEnabled: true,
                              // focusNode: colorFocus,
                              inputType: TextInputType.number,
                            ),
                            RoundedTextField(
                              labelText: "addressName".tr(),
                              controller: addressCtrl,
                              onChanged: (text) {},
                              isEnabled: true,
                              // focusNode: colorFocus,
                              inputType: TextInputType.text,
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
