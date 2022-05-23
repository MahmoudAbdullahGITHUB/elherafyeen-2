import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/auth_api.dart';
import 'package:elherafyeen/api/employee_api.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/country_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/crop_image.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/widgets/add_image_widget.dart';
import 'package:elherafyeen/widgets/image_picker_widget.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/rounded_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../authentication_page.dart';

class EmployeePage extends StatefulWidget {
  bool isSpecial;

  EmployeePage({Key key, this.isSpecial: false}) : super(key: key);

  @override
  _EmployeePageState createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  var cityCtrl = TextEditingController();
  var YearsCtrl = TextEditingController();
  var ageCtrl = TextEditingController();
  var descCtrl = TextEditingController();
  var disabilityType = TextEditingController();

  String place = "";
  String gender = "";
  List<String> genders = [];
  var fieldd;
  double latitude;
  double longitude;
  var currentLocation;
  String fieldId = "jobField".tr();
  String fieldIdInt = "-1";
  List<String> places = [];
  List<CategoryModel> jobFields = [];
  var countryId = "0";
  var countryCode = "0";

  File _image;
  var imageString = "";
  final picker = ImagePicker();

  var _loading = false;

  List<CountryModel> countries = [];

  @override
  void initState() {
    super.initState();
    countries.insert(
        0,
        new CountryModel(
            id: "-1",
            code: "-1",
            key_name: "choose country".tr(),
            country_name: "choose country".tr()));
    getData();
  }

  getData() async {
    countries = await AuthApi.fetchCountries();

    if (countryId == "0") countryId = countries[0].id;
    countryCode = countries[0].code;

    String chooseGender = "gender".tr();
    String male = "male".tr();
    String female = "female".tr();

    genders.add(chooseGender);
    genders.add(male);
    genders.add(female);

    jobFields = await EmployeeApi.getApplicantJobFields();
    places = await EmployeeApi.getApplicantJobPlace();

    jobFields.insert(
        0, CategoryModel(id: "-1", name: "jobField".tr(), logo: ""));
    places.insert(0, "place".tr());
    place = places[0];
    fieldId = jobFields[0].id;
    fieldd = jobFields[0];
    gender = genders[0];

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
      // appBar: AppBar(
      //   title: Text("Employee".tr()),
      //   centerTitle: true,
      //   leading: IconButton(
      //       icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
      //       onPressed: () => Navigator.pop(context)),
      // ),
      body: Builder(builder: (context) {
        _addVehicleButtonPressed() async {
          setState(() => _loading = true);
          await getCurrentLocation();
          try {
            String valueOfPlace = place;
            try {
              for (int i = 0; i < places.length; i++) {
                if (places[i] == place) {
                  valueOfPlace = EmployeeApi.placeValue[i];
                }
              }
            } catch (e) {}
            await EmployeeApi.addEmployee(
                isSpecial: widget.isSpecial,
                disability: disabilityType.text ?? "",
                city_name: cityCtrl.text,
                country_id: countryId,
                country_code: countryCode,
                lat: latitude.toString(),
                lng: longitude.toString(),
                image: imageString.toString(),
                job_place: valueOfPlace.toString(),
                experience_years: YearsCtrl.text,
                age: ageCtrl.text,
                gender: gender == "ذكر"
                    ? "male"
                    : gender == "انثي"
                        ? "female"
                        : gender,
                service_desc: descCtrl.text,
                job_field: fieldIdInt);
            setState(() => _loading = false);
            Fluttertoast.showToast(
                msg: "success_login".tr(),
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 17,
                toastLength: Toast.LENGTH_LONG);

            Navigator.of(context).pushAndRemoveUntil(
                CupertinoPageRoute(builder: (_) => AuthenticationPage()),
                (route) => false);
          } catch (e) {
            setState(() => _loading = false);

            errorSnackBar(e.toString(), context);
          }
        }

        return jobFields != null && jobFields.length != 0
            ? ModalProgressHUD(
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
                                    width: width * .2, height: height * .15),
                              )
                            : AddImageWidget(
                                title: "EmployeeImage".tr(),
                                onTap: () {
                                  ImagePickerWidget(
                                      context: context,
                                      onTap: (value) {
                                        getImage(value);
                                      });
                                }),
                        Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(height * .04)),
                              side:
                                  new BorderSide(color: Colors.grey, width: 1),
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
                                    CountryModel model = countries.firstWhere(
                                        (r) => r.id.toString() == newValue);
                                    countryId = model.id;
                                    countryCode = model.code;
                                  });
                                },
                                items: countries.map<DropdownMenuItem<String>>(
                                    (CountryModel value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Text(value.country_name),
                                    onTap: () {
                                      countryId = value.id;
                                      countryCode = value.code;
                                      print(countryId);
                                    },
                                  );
                                }).toList(),
                              ),
                            )),
                        RoundedTextField(
                          labelText: "city".tr(),
                          controller: cityCtrl,
                          onChanged: (text) {},
                          inputType: TextInputType.text,
                        ),
                        if (widget.isSpecial)
                          RoundedTextField(
                            labelText: "disabilityType".tr(),
                            controller: disabilityType,
                            onChanged: (text) {},
                            inputType: TextInputType.text,
                          ),
                        Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(height * .04)),
                              side:
                                  new BorderSide(color: Colors.grey, width: 1),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: DropdownButton<String>(
                                value: fieldId.toString(),
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
                                    CategoryModel model = jobFields.firstWhere(
                                        (r) => r.id.toString() == newValue);
                                    fieldId = model.id;
                                    fieldIdInt = model.id;
                                    fieldd = model;
                                  });
                                },
                                items: jobFields.map<DropdownMenuItem<String>>(
                                    (CategoryModel value) {
                                  return DropdownMenuItem<String>(
                                    value: value.id.toString(),
                                    child: Text(value.name),
                                    onTap: () {
                                      fieldIdInt = value.id;
                                      fieldId = value.id;
                                      fieldd = value;
                                    },
                                  );
                                }).toList(),
                              ),
                            )),
                        RoundedTextField(
                          labelText: "job_desc".tr(),
                          controller: descCtrl,
                          onChanged: (text) {},
                          isEnabled: true,
                          // focusNode: dateFocus,
                          inputType: TextInputType.text,
                        ),
                        Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(height * .04)),
                              side:
                                  new BorderSide(color: Colors.grey, width: 1),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: DropdownButton<String>(
                                value: place.toString(),
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
                                    String model = places.firstWhere(
                                        (r) => r.toString() == newValue);
                                    place = model;
                                  });
                                },
                                items: places.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value.toString(),
                                    child: Text(value),
                                    onTap: () {
                                      place = value;
                                    },
                                  );
                                }).toList(),
                              ),
                            )),
                        Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(height * .04)),
                              side:
                                  new BorderSide(color: Colors.grey, width: 1),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: DropdownButton<String>(
                                value: gender.toString(),
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
                                    String model = genders.firstWhere(
                                        (r) => r.toString() == newValue);
                                    gender = model;
                                  });
                                },
                                items: genders.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value.toString(),
                                    child: Text(value),
                                    onTap: () {
                                      gender = value;
                                    },
                                  );
                                }).toList(),
                              ),
                            )),
                        RoundedTextField(
                          labelText: "experience_years".tr(),
                          controller: YearsCtrl,
                          onChanged: (text) {},
                          inputType: TextInputType.number,
                        ),
                        RoundedTextField(
                          labelText: "age".tr(),
                          controller: ageCtrl,
                          onChanged: (text) {},
                          isEnabled: true,
                          // focusNode: dateFocus,
                          inputType: TextInputType.number,
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
                    )),
              )
            : Container(
                child: Center(
                    child: LoadingIndicator(
                  color: HColors.colorPrimaryDark,
                )),
              );
      }),
    );
  }
}
