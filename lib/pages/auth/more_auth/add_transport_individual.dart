import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/shpping_api.dart';
import 'package:elherafyeen/bloc/ship/ship_bloc.dart';
import 'package:elherafyeen/models/country_model.dart';
import 'package:elherafyeen/models/shipping_type_model.dart';
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

class AddTransportIndividuals extends StatefulWidget {
  bool staff;

  AddTransportIndividuals({Key key, this.staff}) : super(key: key);

  @override
  _AddTransportIndividualsState createState() =>
      _AddTransportIndividualsState();
}

class _AddTransportIndividualsState extends State<AddTransportIndividuals> {
  var countryId = "0";
  var countryDialCode = "20";
  var shippingId = "0";
  var countryCode = "0";
  var IndividualsNameCtrl = TextEditingController();
  var phoneOneCtrl = TextEditingController();
  var addressCtrl = TextEditingController();

  FocusNode colorFocus = FocusNode();

  File _image;
  var imageStringIndividuals = "";
  final picker = ImagePicker();
  var imageStringLicenceFront = "";
  var imageStringLicenceBack = "";
  var imageStringUserFront = "";
  var imageStringUserBack = "";

  var _loading = false;

  var cardNumberCtrl = TextEditingController();

  var zoneCtrl = TextEditingController();

  var governateCtrl = TextEditingController();

  var descriptionCtrl = TextEditingController();

  var maximumshipCtrl = TextEditingController();

  var carTypeCtrl = TextEditingController();

  var paymentTypeCtrl = TextEditingController();




  Future getImage(
      {bool gallery,
      bool driver: false,
      bool image: false,
      bool licenceBack: false,
      bool licenceFront: false,
      bool userFront: false,
      bool userBack: false,
      bool feesh: false}) async {
    final pickedFile = await picker.getImage(
        source: gallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _image = await CropImageMethod(image: _image);

      final bytes = await _image.readAsBytes();
      if (image) imageStringIndividuals = base64Encode(bytes);
      if (userFront) imageStringUserFront = base64Encode(bytes);
      if (userBack) imageStringUserBack = base64Encode(bytes);
    } else {
      print('No image selected.');
    }
    setState(() {});
  }

  String base64Encode(List<int> bytes) => base64.encode(bytes);
  List<CountryModel> listCountries = [];
  List<ShippingTypeModel> listShippingTypes = [];

  double latitude;
  double longitude;
  var currentLocation;


  @override
  void initState() {
    super.initState();

    countryDialCode =  PreferenceUtils.getString(Strings.SPCountryDialCode);
    print('countryId in add  $countryId');

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
        backgroundColor: Colors.white,
        body: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) {
                  return ShipBloc()..add(LoadCountries());
                },
              ),
            ],
            child: Builder(builder: (context) {
              _addShipButtonPressed() async {
                setState(() => _loading = true);
                try {
                  await getCurrentLocation();
                  var result = await ShippingApi.addShippingCompanyIndividuals(
                    context: context,
                    staff: widget.staff,
                    lat: latitude.toString(),
                    lng: longitude.toString(),
                    description: descriptionCtrl.text,
                    id_card_image_b: imageStringUserFront,
                    maximum_load_limit: maximumshipCtrl.text,
                    vehicle_type: carTypeCtrl.text,
                    zone: zoneCtrl.text,
                    governorate: governateCtrl.text,
                    address: addressCtrl.text,
                    image: imageStringIndividuals,
                    id_card_image_f: imageStringUserBack,
                    payment_type: paymentTypeCtrl.text,
                    // criminal_record_certificate_image: imageStringLicenceFront,
                  );
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

              return BlocListener<ShipBloc, ShipState>(
                listener: (context, state) async {
                  if (state is ShipError) {
                    print(state.error);
                    errorSnackBar(state.error, context);
                  }
                  if (state is ShipAdded) {
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
                },
                child:
                    BlocBuilder<ShipBloc, ShipState>(builder: (context, state) {
                  if (state is CountriesAndShippingTypesLoadded) {
                    listCountries = state.countries;
                    final model = state.countries.firstWhere(
                            (countryModel) =>
                        countryModel.code == countryDialCode,
                        orElse: () => null);
                    countryId = model != null ? model.id : '230';
                    listShippingTypes = state.shippingTypes;
                    print('countryId beso $countryId');
                    if (countryId == "0")
                      listCountries.insert(
                          0,
                          new CountryModel(
                              id: "-1",
                              code: "-1",
                              key_name: "choose country",
                              country_name: "اختر البلد"));
                    if (countryId == "0") countryId = listCountries[0].id;
                    countryCode = listCountries[0].code;
                    if (shippingId == "0") {
                      listShippingTypes.insert(
                          0,
                          new ShippingTypeModel(
                              id: "-1", shipping_type: "اختر نوع الشحن"));
                      shippingId = listShippingTypes[0].id;
                    }
                  }

                  if (state is LoadingShip) {
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
                            Column(
                              children: [
                                _image != null
                                    ? InkWell(
                                        onTap: () {
                                          ImagePickerWidget(
                                              context: context,
                                              onTap: (value) {
                                                getImage(
                                                    gallery: value,
                                                    image: true);
                                              });
                                        },
                                        child: Image.file(_image,
                                            width: width * .2,
                                            height: height * .15),
                                      )
                                    : AddImageWidget(
                                        title: "image".tr(),
                                        onTap: () {
                                          ImagePickerWidget(
                                              context: context,
                                              onTap: (value) {
                                                getImage(
                                                    gallery: value,
                                                    image: true);
                                              });
                                        }),
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
                                  labelText: "name".tr(),
                                  controller: IndividualsNameCtrl,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  // focusNode: capacityFocus,
                                  inputType: TextInputType.text,
                                ),
                                RoundedTextField(
                                  labelText: "description".tr(),
                                  controller: descriptionCtrl,
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
                                  labelText: "carType".tr(),
                                  controller: carTypeCtrl,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  // focusNode: colorFocus,
                                  inputType: TextInputType.text,
                                ),
                                RoundedTextField(
                                  labelText: "maximumship".tr(),
                                  controller: maximumshipCtrl,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  // focusNode: colorFocus,
                                  inputType: TextInputType.number,
                                ),
                                RoundedTextField(
                                  labelText: "governate".tr(),
                                  controller: governateCtrl,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  // focusNode: colorFocus,
                                  inputType: TextInputType.text,
                                ),
                                RoundedTextField(
                                  labelText: "zone".tr(),
                                  controller: zoneCtrl,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  // focusNode: colorFocus,
                                  inputType: TextInputType.text,
                                ),
                                RoundedTextField(
                                  labelText: "cardNumber".tr(),
                                  controller: cardNumberCtrl,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  // focusNode: colorFocus,
                                  inputType: TextInputType.number,
                                ),
                                RoundedTextField(
                                  labelText: "paymentMethod".tr(),
                                  controller: paymentTypeCtrl,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  // focusNode: colorFocus,
                                  inputType: TextInputType.text,
                                ),
                                // Card(
                                //     elevation: 5,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.all(
                                //           Radius.circular(height * .04)),
                                //       side: new BorderSide(
                                //           color: Colors.grey, width: 1),
                                //     ),
                                //     child: Padding(
                                //       padding: const EdgeInsets.symmetric(
                                //           horizontal: 8),
                                //       child: Row(
                                //         children: [
                                //           Text("feesh".tr(),
                                //               style: Theme.of(context)
                                //                   .textTheme
                                //                   .headline3
                                //                   .copyWith(
                                //                       fontSize: 16 * factor)),
                                //           SizedBox(
                                //             width: 12 * factor,
                                //           ),
                                //           InkWell(
                                //             onTap: () {
                                //               ImagePickerWidget(
                                //                   context: context,
                                //                   onTap: (val) {
                                //                     getImage(
                                //                         feesh: true,
                                //                         gallery: val);
                                //                   });
                                //             },
                                //             child: Card(
                                //               color: Colors.white,
                                //               shape: RoundedRectangleBorder(
                                //                   borderRadius:
                                //                       BorderRadius.all(
                                //                           Radius.circular(
                                //                               width * .01)),
                                //                   side: BorderSide(
                                //                       color: Colors.grey)),
                                //               child: Padding(
                                //                 padding:
                                //                     const EdgeInsets.all(6.0),
                                //                 child: Icon(
                                //                   Icons.add,
                                //                   color:
                                //                       HColors.colorPrimaryDark,
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         ],
                                //       ),
                                //     )),
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
                                      child: Row(
                                        children: [
                                          Text("cardphoto".tr(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline3
                                                  .copyWith(
                                                      fontSize: 16 * factor)),
                                          SizedBox(
                                            width: 12 * factor,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              ImagePickerWidget(
                                                  context: context,
                                                  onTap: (val) {
                                                    getImage(
                                                        userFront: true,
                                                        gallery: val);
                                                  });
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              width * .01)),
                                                  side: BorderSide(
                                                      color: Colors.grey)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Icon(
                                                  Icons.add,
                                                  color:
                                                      HColors.colorPrimaryDark,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(flex: 1, child: SizedBox()),
                                          InkWell(
                                            onTap: () {
                                              ImagePickerWidget(
                                                  context: context,
                                                  onTap: (val) {
                                                    getImage(
                                                        userBack: true,
                                                        gallery: val);
                                                  });
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              width * .01)),
                                                  side: BorderSide(
                                                      color: Colors.grey)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(6.0),
                                                child: Icon(
                                                  Icons.add,
                                                  color:
                                                      HColors.colorPrimaryDark,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8 * factor,
                                          ),
                                          imageStringUserFront != "" &&
                                                  imageStringUserBack != ""
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                    )),
                                RoundedTextField(
                                  labelText: "address".tr(),
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
                                      child: state is AddShipLoading
                                          ? LoadingIndicator()
                                          : Text(
                                              "ok".tr(),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                      onPressed: () {
                                        _addShipButtonPressed();
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
}
