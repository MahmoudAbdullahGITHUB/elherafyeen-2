import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/winsh_api.dart';
import 'package:elherafyeen/bloc/winsh/winsh_bloc.dart';
import 'package:elherafyeen/models/country_model.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/crop_image.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/utilities/shared_preferences.dart';
import 'package:elherafyeen/utilities/strings.dart';
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

class AddCompanyWinchPage extends StatefulWidget {
  bool staff;

  AddCompanyWinchPage({Key key, this.staff: false}) : super(key: key);

  @override
  _AddCompanyWinchPageState createState() => _AddCompanyWinchPageState();
}

class _AddCompanyWinchPageState extends State<AddCompanyWinchPage> {
  var countryId = "0";
  var countryDialCode = "20";
  var countryCode = "0";
  var companyNameCtrl = TextEditingController();
  var driverNameCtrl = TextEditingController();
  var phoneOneCtrl = TextEditingController();
  var phoneTwoCtrl = TextEditingController();
  var addressCtrl = TextEditingController();
  double latitude;
  double longitude;
  var currentLocation;
  FocusNode colorFocus = FocusNode();
  bool _loading = false;
  File _image;
  var imageStringCompany = "";
  var imageStringDriver = "";
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    countryDialCode =  PreferenceUtils.getString(Strings.SPCountryDialCode);
    print('countryId in add  $countryId');

  }

  Future getImage({bool company, bool gallery}) async {
    final pickedFile = await picker.getImage(
        source: gallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      if (company) {
        _image = await CropImageMethod(image: _image);
        setState(() async {
          List<int> imageBytes = _image.readAsBytesSync();
          print(imageBytes);
          final bytes = await _image.readAsBytes();
          imageStringCompany = base64Encode(bytes);
          print(imageStringCompany);
        });
      } else {
        _image = await CropImageMethod(image: _image);
        setState(() async {
          List<int> imageBytes = _image.readAsBytesSync();
          print(imageBytes);
          final bytes = await _image.readAsBytes();
          imageStringDriver = base64Encode(bytes);
          print(imageStringDriver);
        });
      }
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  List<CountryModel> listCountries = [];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return Scaffold(
        backgroundColor: Colors.white,
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  return WinshBloc()..add(LoadCountries());
                },
              ),
            ],
            child: Builder(builder: (context) {
              _addWinshButtonPressed() async {
                // BlocProvider.of<WinshBloc>(context).add(AddWinshButtonPressed(
                //     country_id: countryId,
                //     country_code: countryCode,
                //     company_name: companyNameCtrl.text,
                //     whatsapp: phoneOneCtrl.text,
                //     phone2: phoneTwoCtrl.text,
                //     driver_name: driverNameCtrl.text,
                //     lat: "29.111",
                //     lng: "29.111",
                //     company_img: imageStringCompany,
                //     winsh_img: imageStringDriver));

                setState(() => _loading = true);
                await getCurrentLocation();

                try {
                  bool result = await WinshApi.addWinchCompany(
                    staff: widget.staff,
                    country_id: countryId,
                    country_code: countryCode,
                    company_name: companyNameCtrl.text,
                    whatsapp: phoneOneCtrl.text,
                    phone2: phoneTwoCtrl.text,
                    driver_name: driverNameCtrl.text,
                    lat: latitude.toString(),
                    lng: longitude.toString(),
                    winsh_img: imageStringCompany,
                    company_img: imageStringCompany,
                  );
                  setState(() => _loading = false);
                  // errorSnackBar("تم إضافة الونش بنجاح...", context,
                  //     success: true);

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

              return BlocListener<WinshBloc, WinshState>(
                listener: (context, state) async {
                  if (state is WinshError) {
                    print(state.error);
                    errorSnackBar(state.error, context);
                  }
                  if (state is WinshAdded) {
                    if (state.result)
                      errorSnackBar("تم إضافة الونش بنجاح...", context,
                          success: true);
                  }
                },
                child: BlocBuilder<WinshBloc, WinshState>(
                    builder: (context, state) {
                  if (state is CountriesLoadded) {
                    listCountries = state.countries;
                    if (countryId == "0")
                      listCountries.insert(
                          0,
                          new CountryModel(
                              id: "-1",
                              code: "-1",
                              key_name: "choose country",
                              country_name: "اختر البلد"));
                    if (countryId == "0") countryId = listCountries[0].id;
                    final model = state.countries.firstWhere(
                            (countryModel) =>
                        countryModel.code == countryDialCode,
                        orElse: () => null);
                    countryId = model != null ? model.id : '230';
                    countryCode = listCountries[0].code;
                  }

                  if (state is LoadingWinsh) {
                    return Container(
                      child: Center(
                          child: LoadingIndicator(
                        color: HColors.colorPrimaryDark,
                      )),
                    );
                  }
                  return ModalProgressHUD(
                    inAsyncCall: _loading,
                    color: HColors.colorPrimaryDark,
                    progressIndicator: LoadingIndicator(
                      color: HColors.colorPrimaryDark,
                    ),
                    child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _image != null
                                        ? InkWell(
                                            onTap: () {
                                              ImagePickerWidget(
                                                  context: context,
                                                  onTap: (val) {
                                                    getImage(
                                                        company: true,
                                                        gallery: val);
                                                  });
                                            },
                                            child: Image.file(_image,
                                                width: width * .2,
                                                height: height * .15),
                                          )
                                        : AddImageWidget(
                                            title: "company photo".tr(),
                                            onTap: () {
                                              ImagePickerWidget(
                                                  context: context,
                                                  onTap: (val) {
                                                    getImage(
                                                        company: true,
                                                        gallery: val);
                                                  });
                                            }),
                                  ],
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
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
                                                    r.id.toString() ==
                                                    newValue);
                                            countryId = model.id;
                                            countryCode = model.code;
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
                                              countryCode = value.code;
                                              print(countryId);
                                            },
                                          );
                                        }).toList(),
                                      ),
                                    )),
                                RoundedTextField(
                                  labelText: "company_name".tr(),
                                  controller: companyNameCtrl,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  // focusNode: capacityFocus,
                                  inputType: TextInputType.text,
                                ),
                                RoundedTextField(
                                  labelText: "owner_name".tr(),
                                  controller: driverNameCtrl,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  // focusNode: capacityFocus,
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
                                  inputType: TextInputType.number,
                                ),
                                RoundedTextField(
                                  labelText: "company_address".tr(),
                                  controller: addressCtrl,
                                  onChanged: (text) {},
                                  isEnabled: true,
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
                                      child: state is AddWinshLoading
                                          ? LoadingIndicator(
                                              color: HColors.colorButton,
                                            )
                                          : Text(
                                              "ok".tr(),
                                              style: TextStyle(
                                                  color: HColors.colorButton),
                                            ),
                                      onPressed: () {
                                        _addWinshButtonPressed();
                                      }),
                                )
                              ],
                            ),
                          ],
                        )),
                  );
                }),
              );
            })));
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
}
