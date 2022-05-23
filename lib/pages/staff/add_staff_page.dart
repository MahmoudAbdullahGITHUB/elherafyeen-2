import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/staff_api.dart';
import 'package:elherafyeen/bloc/staff/staff_bloc.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/country_model.dart';
import 'package:elherafyeen/models/role_model.dart';
import 'package:elherafyeen/models/store_type_model.dart';
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
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class AddStaffPage extends StatefulWidget {
  AddStaffPage({Key key}) : super(key: key);

  @override
  _AddStaffPageState createState() => _AddStaffPageState();
}

class _AddStaffPageState extends State<AddStaffPage> {
  var countryId = "0";
  var roleId = "0";
  var nameCtrl = TextEditingController();
  var phoneOneCtrl = TextEditingController();
  var phoneTwoCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var emailCtrl = TextEditingController();

  var idSet = <String>{};

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

  List<CountryModel> listCountries = [];
  List<RoleModel> listRoles = [];
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
          title: Text("addStaff".tr()),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  return StaffBloc()..add(LoadCountriesAndRoles());
                },
              ),
            ],
            child: Builder(builder: (context) {
              _addVehicleButtonPressed() async {
                await getCurrentLocation();

                setState(() => _loading = true);
                try {
                  await StaffApi.addStaff(
                      phone2: phoneTwoCtrl.text,
                      phone: phoneOneCtrl.text,
                      whatsapp: phoneOneCtrl.text,
                      lat: latitude.toString(),
                      lng: longitude.toString(),
                      name: nameCtrl.text,
                      country_id: countryId,
                      role_id: roleId,
                      pass: passCtrl.text,
                      email: '',
                      image: imageString);

                  errorSnackBar("تم الإضافة بنجاح...", context, success: true);
                  setState(() => _loading = false);
                  Navigator.pop(context);

                  Navigator.pop(context);
                } catch (e) {
                  setState(() => _loading = false);

                  errorSnackBar(e.toString(), context);
                }
              }

              return BlocListener<StaffBloc, StaffState>(
                listener: (context, state) async {
                  // if (state is ErrorVendor) {
                  //   print('there is error');
                  //
                  //   ///Function that show snackBar
                  //   ///required [error] content of error and [context]
                  //   errorSnackBar(state.error, context);
                  // }
                  // if (state is VendorAdded) {
                  //   if (state.result)
                  //     errorSnackBar("تم الإضافة بنجاح...", context,
                  //         success: true);
                  // }
                },
                child: BlocBuilder<StaffBloc, StaffState>(
                    builder: (context, state) {
                  if (state is LoaddedData) {
                    if (countryId == "0") {
                      listCountries = state.countries;
                      listCountries.insert(
                          0,
                          new CountryModel(
                              id: "-1",
                              code: "-1",
                              key_name: "choose country".tr(),
                              country_name: "choose country".tr()));
                      if (countryId == "0") countryId = listCountries[0].id;
                    }
                    if (roleId == "0") {
                      listRoles = state.roles;
                      listRoles.insert(
                          0,
                          new RoleModel(
                              id: "-1", role_name: "chooseStaffType".tr()));
                      if (roleId == "0") roleId = listRoles[0].id;
                    }
                  }

                  if (state is StaffLoading) {
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
                                    title: "StaffImage".tr(),
                                    onTap: () {
                                      ImagePickerWidget(
                                          context: context,
                                          onTap: (value) {
                                            getImage(value);
                                          });
                                    }),
                            RoundedTextField(
                              labelText: "StaffName".tr(),
                              controller: nameCtrl,
                              onChanged: (text) {},
                              // focusNode: manualFocus,
                              inputType: TextInputType.text,
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
                                    value: countryId.toString(),
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
                                    underline: SizedBox(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        CountryModel model =
                                            listCountries.firstWhere((r) =>
                                                r.id.toString() == newValue);
                                        countryId = model.id;
                                      });
                                    },
                                    items: listCountries
                                        .map<DropdownMenuItem<String>>(
                                            (CountryModel value) {
                                      return DropdownMenuItem<String>(
                                        value: value.id.toString(),
                                        child: Text(value.country_name),
                                        onTap: () {
                                          countryId = value.id;
                                          print(countryId);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )),
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
                                    value: roleId.toString(),
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
                                    underline: SizedBox(),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        RoleModel model = listRoles.firstWhere(
                                            (r) => r.id.toString() == newValue);
                                        roleId = model.id;
                                      });
                                    },
                                    items: listRoles
                                        .map<DropdownMenuItem<String>>(
                                            (RoleModel value) {
                                      return DropdownMenuItem<String>(
                                        value: value.id.toString(),
                                        child: Text(value.role_name),
                                        onTap: () {
                                          roleId = value.id;
                                          print(roleId);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                )),
                            // RoundedTextField(
                            //   labelText: "email".tr(),
                            //   controller: emailCtrl,
                            //   onChanged: (text) {},
                            //   isEnabled: true,
                            //   // focusNode: colorFocus,
                            //   inputType: TextInputType.emailAddress,
                            // ),
                            RoundedTextField(
                              labelText: "password".tr(),
                              controller: passCtrl,
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
                                  child: Text(
                                    "ok".tr(),
                                    style:
                                        TextStyle(color: HColors.colorButton),
                                  ),
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
