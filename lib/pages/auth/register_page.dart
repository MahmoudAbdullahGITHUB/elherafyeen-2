/// basic
import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/bloc/auth/auth_bloc.dart';
import 'package:elherafyeen/models/country_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/pages/menu/more/rules_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/constants.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/utilities/shared_preferences.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/main_ui_widget.dart';
import 'package:elherafyeen/widgets/regular_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import 'more_auth/account_type.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var confirmPassController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();
  FocusNode conPassFocusNode = FocusNode();
  String countryId = "0";
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
  String _phone = '';

  var passSecured = true;
  var passConSecured = true;

  var _accepted = false;

  /// beso
  List<CountryModel> stateCountries = [];
  String address = 'search';
  String countryName = 'search';
  String countryDialCode = '20';
  double latitude;
  double longitude;
  var currentLocation;

  @override
  void initState() {
    super.initState();

    // PreferenceUtils.init();

    getCurrentLocation();
  }

  Future<Map<String, double>> getCurrentLocation() async {
    Map<String, double> result = {"latitude": 0.0, "longitude": 0.0};
    try {
      currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      print('here we are $currentLocation');
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentLocation.latitude, currentLocation.longitude);
      print(placemarks);
      Placemark place = placemarks[0];
      address =
          'mon address ${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} , ${place.locality}';
      countryName = place.country;

      print('local  $address');

      countryDialCode = await getCountryDialCode();

      print('countryDialCode $countryDialCode');

      result = {
        "latitude": currentLocation.latitude,
        "longitude": currentLocation.longitude
      };
      print('here we are again ${result['latitude']} ${result['longitude']}');

      setState(() {
        latitude = currentLocation.latitude;
        longitude = currentLocation.longitude;
      });
    } catch (e) {
      currentLocation = null;
    }

    return result;
  }

  Future<String> getCountryDialCode() async {
    // final item = countryName != ''
    //     ? MyConstants.COUNTRIES.firstWhere((e) => e['name'] == '$countryName',orElse: )
    //     : MyConstants.COUNTRIES[0];

    final item = MyConstants.COUNTRIES
        .firstWhere((e) => e['name'] == '$countryName', orElse: () => null);

    // await PreferenceUtils.setString(
    //     '${Strings.SPCountryDialCode}', '$countryDialCode');
    //
    // print('my item : $item llll ${countryDialCode}  lll ${PreferenceUtils.getString(Strings.SPCountryDialCode)}');

    return item['dial_code'];
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
      backgroundColor: HColors.colorPrimary,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              return AuthBloc()..add(LoadCountries());
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            bool _validate() {
              if (passwordController.text != confirmPassController.text) {
                errorSnackBar("errorConfirmPassword".tr(), context);
                return false;
              }
              return true;
            }

            _onRegisterButtonPressed() {
              if (_validate())
                BlocProvider.of<AuthBloc>(context).add(
                  RegisterButtonPressed(
                      lang: RegisterModel.shared.token.toString(),
                      whatsapp: phoneController.text,
                      phone: phoneController.text,
                      password: passwordController.text,
                      countryId: countryId,
                      name: nameController.text),
                );
            }

            return BlocListener<AuthBloc, AuthState>(
                listener: (context, state) async {
                  if (state is AuthError) {
                    ///Function that show snackBar
                    ///required [error] content of error and [context]
                    errorSnackBar(state.error, context);
                  }
                  if (state is RegisterDone) {
                    if (state.result)
                      Navigator.of(context).push(
                          CupertinoPageRoute(builder: (_) => AccountType()));
                    else {
                      errorSnackBar("Error....", context, success: true);
                    }
                  }
                },
                child: SingleChildScrollView(
                  child: Container(
                    // color: Colors.red,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          // width: width * .3,
                          // height: height * .2,
                          // padding: EdgeInsets.all(3),
                          // decoration: BoxDecoration(
                          //   border: Border.all(
                          //     color: Colors.white,
                          //   ),
                          //   // shape: BoxShape.rectangle,
                          //   color: HColors.colorPrimary,
                          //
                          // ),
                          child: Image.asset(
                            "assets/Group 2751.png",
                            width: 100,
                            height: 80,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Divider(),
                        Card(
                          elevation: 5,
                          // shadowColor: Colors.blueAccent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 30.0, horizontal: 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RegularTextField(
                                  labelText: "name".tr(),
                                  controller: nameController,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  focusNode: nameFocusNode,
                                  inputType: TextInputType.text,
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    // color: Colors.red,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child: InternationalPhoneNumberInput(
                                      //hintText: "phone".tr(),
                                      onInputChanged: (PhoneNumber number) {
                                        setState(() {
                                          _phone = number.phoneNumber;
                                        });
                                      },
                                      onInputValidated: (bool value) {
                                        print(value);
                                      },
                                      selectorConfig: const SelectorConfig(
                                        selectorType:
                                            PhoneInputSelectorType.DIALOG,
                                      ),

                                      ignoreBlank: false,
                                      autoValidateMode: AutovalidateMode.disabled,
                                      inputDecoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.phone,
                                          color: Colors.grey,
                                        ),
                                        labelText: "phone".tr(),
                                        border: InputBorder.none,
                                        prefixIconConstraints:
                                            BoxConstraints(minWidth: 30 * factor),
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .headline2
                                            .copyWith(fontSize: 14 * factor),
                                        // border: OutlineInputBorder(
                                        //   borderSide: BorderSide(
                                        //     width: 0.5,
                                        //   ),
                                        //   borderRadius: const BorderRadius.only(
                                        //     topLeft: Radius.circular(5),
                                        //     topRight: Radius.circular(5),
                                        //     bottomLeft: Radius.circular(5),
                                        //     bottomRight: Radius.circular(5),
                                        //   ),
                                        // ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 0.1,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(5),
                                          ),
                                        ),
                                      ),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .copyWith(fontSize: 16 * factor),
                                      selectorTextStyle: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .copyWith(fontSize: 16 * factor),
                                      initialValue: number,
                                      textFieldController: phoneController,
                                      formatInput: false,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              signed: true, decimal: true),
                                      //inputBorder: const OutlineInputBorder(),
                                      onSaved: (PhoneNumber number) {
                                        print('On Saved: $number');
                                      },
                                    ),
                                  ),
                                ),

                                // RegularTextField(
                                //   labelText: "phone".tr(),
                                //   controller: phoneController,
                                //   onChanged: (text) {},
                                //   isEnabled: true,
                                //   focusNode: phoneFocusNode,
                                //   inputType: TextInputType.number,
                                //   prefixIcon: Icon(
                                //     Icons.phone,
                                //     color: Colors.grey,
                                //   ),
                                // ),
                                SizedBox(
                                  height: 10,
                                ),
                                RegularTextField(
                                  labelText: "pass".tr(),
                                  obscureText: passSecured,
                                  controller: passwordController,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  focusNode: passFocusNode,
                                  inputType: TextInputType.text,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passSecured = !passSecured;
                                      });
                                    },
                                    icon: Icon(
                                        !passSecured
                                            ? FontAwesomeIcons.eyeSlash
                                            : FontAwesomeIcons.eye,
                                        size: 15 * factor,
                                        color: Colors.grey),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                RegularTextField(
                                  obscureText: passConSecured,
                                  labelText: "conPass".tr(),
                                  controller: confirmPassController,
                                  onChanged: (text) {},
                                  isEnabled: true,
                                  focusNode: conPassFocusNode,
                                  inputType: TextInputType.text,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        passConSecured = !passConSecured;
                                      });
                                    },
                                    icon: Icon(
                                      !passConSecured
                                          ? FontAwesomeIcons.eyeSlash
                                          : FontAwesomeIcons.eye,
                                      size: 15 * factor,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.transparent,
                        ),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            /// beso
                            if (state is CountriesLoaded) {
                              if (countryId == "0")
                                countryId = state.countries[0].id;
                              stateCountries = state.countries;
                              final model = state.countries.firstWhere(
                                  (countryModel) =>
                                      countryModel.key_name == countryName,
                                  orElse: () => null);
                              countryId = model != null ? model.id : '230';
                            }
                            print('empty RR:  ${stateCountries.isEmpty}');
                            return Container(
                              height: height * 0.08,
                              width: width * 0.7,
                              // padding: _padding,
                              color: Colors.transparent,
                              child: RaisedButton(
                                  color: Color(0xffF6F6F6),
                                  onPressed: () {},
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  child: stateCountries.isEmpty
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : DropdownButton<String>(
                                          value: countryId.toString(),
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          autofocus: true,
                                          iconSize: 24 * factor,
                                          isExpanded: true,
                                          elevation: 16,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3
                                              .copyWith(fontSize: 16 * factor),
                                          underline: Container(
                                            height: 1,
                                            color: Colors.grey[400],
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              CountryModel country =
                                                  stateCountries.firstWhere(
                                                      (r) =>
                                                          r.id.toString() ==
                                                          newValue);
                                              countryId = country.id;
                                            });
                                          },
                                          items: stateCountries
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
                                        )),
                            );
                            // return Container(
                            //   height: height * 0.08,
                            //   width: width * 0.7,
                            //   // padding: _padding,
                            //   color: Colors.transparent,
                            //   child: RaisedButton(
                            //     color: Color(0xffF6F6F6),
                            //     // color: Colors.red,
                            //     onPressed: () {},
                            //     shape: RoundedRectangleBorder(
                            //         borderRadius:
                            //         BorderRadius.circular(height * 0.02)),
                            //     child: Row(
                            //       mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //       children: [
                            //         Text(
                            //           "country".tr(),
                            //           style: Theme
                            //               .of(context)
                            //               .textTheme
                            //               .headline3
                            //               .copyWith(fontSize: 16 * factor),
                            //         ),
                            //         Icon(
                            //           Icons.keyboard_arrow_down,
                            //           color: Theme
                            //               .of(context)
                            //               .primaryColor,
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                        SizedBox(height: 20 * factor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (_) => RulesPage(
                                              title:
                                                  "user_agreament_title".tr(),
                                              text: "service_agreement".tr(),
                                            )));
                              },
                              child: Text(
                                "click_to_read".tr(),
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                checkColor: Colors.white,
                                title: Text(
                                  "user_agreament".tr(),
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                selected: _accepted,
                                value: _accepted,
                                onChanged: (value) {
                                  setState(() {
                                    _accepted = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20 * factor),
                        BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                          return ButtonTheme(
                            minWidth: width * .5,
                            height: height * 0.08,
                            child: RaisedButton(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              onPressed: () {
                                _onRegisterButtonPressed();
                              },
                              child: state is AuthLoading
                                  ? LoadingIndicator(
                                      color: HColors.colorPrimaryDark,
                                    )
                                  : Text(
                                      "register".tr(),
                                      style: TextStyle(
                                          color: HColors.colorPrimary),
                                    ),
                            ),
                          );
                        }),
                        // NextTextWidget(
                        //   onTap: () {
                        //     Navigator.push(
                        //         context,
                        //         CupertinoPageRoute(
                        //             builder: (context) => HomePage()));
                        //   },
                        //   text: "goHome".tr(),
                        // ),
                      ],
                    ),
                  ),
                ));
          },
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

/// basic
// import 'package:easy_localization/easy_localization.dart';
// import 'package:elherafyeen/bloc/auth/auth_bloc.dart';
// import 'package:elherafyeen/models/country_model.dart';
// import 'package:elherafyeen/models/register_model.dart';
// import 'package:elherafyeen/pages/menu/more/rules_page.dart';
// import 'package:elherafyeen/utilities/colors.dart';
// import 'package:elherafyeen/utilities/constants.dart';
// import 'package:elherafyeen/utilities/error_bar.dart';
// import 'package:elherafyeen/utilities/shared_preferences.dart';
// import 'package:elherafyeen/utilities/strings.dart';
// import 'package:elherafyeen/widgets/loading_indicator.dart';
// import 'package:elherafyeen/widgets/main_ui_widget.dart';
// import 'package:elherafyeen/widgets/regular_text_field.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
//
// import 'more_auth/account_type.dart';
//
// class RegisterPage extends StatefulWidget {
//   RegisterPage({Key key}) : super(key: key);
//
//   @override
//   _RegisterPageState createState() => _RegisterPageState();
// }
//
// class _RegisterPageState extends State<RegisterPage> {
//   var phoneController = TextEditingController();
//   var passwordController = TextEditingController();
//   var nameController = TextEditingController();
//   var confirmPassController = TextEditingController();
//   FocusNode phoneFocusNode = FocusNode();
//   FocusNode passFocusNode = FocusNode();
//   FocusNode nameFocusNode = FocusNode();
//   FocusNode conPassFocusNode = FocusNode();
//   String countryId = "0";
//
//   var passSecured = true;
//   var passConSecured = true;
//
//   var _accepted = false;
//
//   /// beso
//   List<CountryModel> stateCountries = [];
//   String address = 'search';
//   String countryName = 'search';
//   String countryDialCode = '20';
//   double latitude;
//   double longitude;
//   var currentLocation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // PreferenceUtils.init();
//
//     getCurrentLocation();
//   }
//
//   Future<Map<String, double>> getCurrentLocation() async {
//     Map<String, double> result = {"latitude": 0.0, "longitude": 0.0};
//     try {
//       currentLocation = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//       );
//
//       print('here we are $currentLocation');
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           currentLocation.latitude, currentLocation.longitude);
//       print(placemarks);
//       Placemark place = placemarks[0];
//       address =
//           'mon address ${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country} , ${place.locality}';
//       countryName = place.country;
//
//       print('local  $address');
//
//       countryDialCode = await getCountryDialCode();
//
//       print('countryDialCode $countryDialCode');
//
//       result = {
//         "latitude": currentLocation.latitude,
//         "longitude": currentLocation.longitude
//       };
//       print('here we are again ${result['latitude']} ${result['longitude']}');
//
//       setState(() {
//         latitude = currentLocation.latitude;
//         longitude = currentLocation.longitude;
//       });
//     } catch (e) {
//       currentLocation = null;
//     }
//
//     return result;
//   }
//
//   Future<String> getCountryDialCode() async {
//     // final item = countryName != ''
//     //     ? MyConstants.COUNTRIES.firstWhere((e) => e['name'] == '$countryName',orElse: )
//     //     : MyConstants.COUNTRIES[0];
//
//     final item = MyConstants.COUNTRIES
//         .firstWhere((e) => e['name'] == '$countryName', orElse: () => null);
//
//     // await PreferenceUtils.setString(
//     //     '${Strings.SPCountryDialCode}', '$countryDialCode');
//     //
//     // print('my item : $item llll ${countryDialCode}  lll ${PreferenceUtils.getString(Strings.SPCountryDialCode)}');
//
//     return item['dial_code'];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//
//     final orientation = MediaQuery.of(context).orientation;
//     double factor = 1;
//     //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
//     // if (height > 2040) factor = 3.0;
//     return Scaffold(
//       backgroundColor: HColors.colorPrimary,
//       body: MultiBlocProvider(
//         providers: [
//           BlocProvider(
//             create: (context) {
//               return AuthBloc()..add(LoadCountries());
//             },
//           ),
//         ],
//         child: Builder(
//           builder: (context) {
//             bool _validate() {
//               if (passwordController.text != confirmPassController.text) {
//                 errorSnackBar("errorConfirmPassword".tr(), context);
//                 return false;
//               }
//               return true;
//             }
//
//             _onRegisterButtonPressed() {
//               if (_validate())
//                 BlocProvider.of<AuthBloc>(context).add(
//                   RegisterButtonPressed(
//                       lang: RegisterModel.shared.token.toString(),
//                       whatsapp: phoneController.text,
//                       phone: phoneController.text,
//                       password: passwordController.text,
//                       countryId: countryId,
//                       name: nameController.text),
//                 );
//             }
//
//             return BlocListener<AuthBloc, AuthState>(
//                 listener: (context, state) async {
//                   if (state is AuthError) {
//                     ///Function that show snackBar
//                     ///required [error] content of error and [context]
//                     errorSnackBar(state.error, context);
//                   }
//                   if (state is RegisterDone) {
//                     if (state.result)
//                       Navigator.of(context).push(
//                           CupertinoPageRoute(builder: (_) => AccountType()));
//                     else {
//                       errorSnackBar("Error....", context, success: true);
//                     }
//                   }
//                 },
//                 child: SingleChildScrollView(
//                   child: Container(
//                     // color: Colors.red,
//                     padding: EdgeInsets.all(16),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           "assets/Group 2751.png",
//                           width: width * .2,
//                           height: height * .1,
//                           fit: BoxFit.fill,
//                         ),
//                         SizedBox(height: 20 * factor),
//                         MainUiWidget(
//                           height: height * .55,
//                           width: width,
//                           child: Column(
//                             children: [
//                               RegularTextField(
//                                 labelText: "name".tr(),
//                                 controller: nameController,
//                                 onChanged: (text) {},
//                                 isEnabled: true,
//                                 focusNode: nameFocusNode,
//                                 inputType: TextInputType.text,
//                                 prefixIcon: Icon(
//                                   Icons.person,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               RegularTextField(
//                                 labelText: "phone".tr(),
//                                 controller: phoneController,
//                                 onChanged: (text) {},
//                                 isEnabled: true,
//                                 focusNode: phoneFocusNode,
//                                 inputType: TextInputType.number,
//                                 prefixIcon: Icon(
//                                   Icons.phone,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               RegularTextField(
//                                 labelText: "pass".tr(),
//                                 obscureText: passSecured,
//                                 controller: passwordController,
//                                 onChanged: (text) {},
//                                 isEnabled: true,
//                                 focusNode: passFocusNode,
//                                 inputType: TextInputType.text,
//                                 suffixIcon: IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       passSecured = !passSecured;
//                                     });
//                                   },
//                                   icon: Icon(
//                                       !passSecured
//                                           ? FontAwesomeIcons.eyeSlash
//                                           : FontAwesomeIcons.eye,
//                                       size: 15 * factor,
//                                       color: Colors.grey),
//                                 ),
//                                 prefixIcon: Icon(
//                                   Icons.lock,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               RegularTextField(
//                                 obscureText: passConSecured,
//                                 labelText: "conPass".tr(),
//                                 controller: confirmPassController,
//                                 onChanged: (text) {},
//                                 isEnabled: true,
//                                 focusNode: conPassFocusNode,
//                                 inputType: TextInputType.text,
//                                 suffixIcon: IconButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       passConSecured = !passConSecured;
//                                     });
//                                   },
//                                   icon: Icon(
//                                     !passConSecured
//                                         ? FontAwesomeIcons.eyeSlash
//                                         : FontAwesomeIcons.eye,
//                                     size: 15 * factor,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                                 prefixIcon: Icon(
//                                   Icons.lock,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               SizedBox(
//                                 height: 25 * factor,
//                               )
//                             ],
//                           ),
//                         ),
//                         BlocBuilder<AuthBloc, AuthState>(
//                           builder: (context, state) {
//                             /// beso
//                             if (state is CountriesLoaded) {
//                               if (countryId == "0")
//                                 countryId = state.countries[0].id;
//                               stateCountries = state.countries;
//                               final model = state.countries.firstWhere(
//                                   (countryModel) =>
//                                       countryModel.key_name == countryName,
//                                   orElse: () => null);
//                               countryId = model != null ? model.id : '230';
//                             }
//                             print('empty RR:  ${stateCountries.isEmpty}');
//                             return Container(
//                               height: height * 0.08,
//                               width: width * 0.7,
//                               // padding: _padding,
//                               color: Colors.transparent,
//                               child: RaisedButton(
//                                   color: Color(0xffF6F6F6),
//                                   onPressed: () {},
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius:
//                                           BorderRadius.circular(height * 0.02)),
//                                   child: stateCountries.isEmpty
//                                       ? Center(
//                                           child: CircularProgressIndicator(),
//                                         )
//                                       : DropdownButton<String>(
//                                           value: countryId.toString(),
//                                           icon: Icon(
//                                             Icons.arrow_drop_down,
//                                             color:
//                                                 Theme.of(context).primaryColor,
//                                           ),
//                                           autofocus: true,
//                                           iconSize: 24 * factor,
//                                           isExpanded: true,
//                                           elevation: 16,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headline3
//                                               .copyWith(fontSize: 16 * factor),
//                                           underline: Container(
//                                             height: 1,
//                                             color: Colors.grey[400],
//                                           ),
//                                           onChanged: (String newValue) {
//                                             setState(() {
//                                               CountryModel country =
//                                                   stateCountries.firstWhere(
//                                                       (r) =>
//                                                           r.id.toString() ==
//                                                           newValue);
//                                               countryId = country.id;
//                                             });
//                                           },
//                                           items: stateCountries
//                                               .map<DropdownMenuItem<String>>(
//                                                   (CountryModel value) {
//                                             return DropdownMenuItem<String>(
//                                               value: value.id.toString(),
//                                               child: Text(value.country_name),
//                                               onTap: () {
//                                                 countryId = value.id;
//                                                 print(countryId);
//                                               },
//                                             );
//                                           }).toList(),
//                                         )),
//                             );
//                             // return Container(
//                             //   height: height * 0.08,
//                             //   width: width * 0.7,
//                             //   // padding: _padding,
//                             //   color: Colors.transparent,
//                             //   child: RaisedButton(
//                             //     color: Color(0xffF6F6F6),
//                             //     // color: Colors.red,
//                             //     onPressed: () {},
//                             //     shape: RoundedRectangleBorder(
//                             //         borderRadius:
//                             //         BorderRadius.circular(height * 0.02)),
//                             //     child: Row(
//                             //       mainAxisAlignment:
//                             //       MainAxisAlignment.spaceBetween,
//                             //       children: [
//                             //         Text(
//                             //           "country".tr(),
//                             //           style: Theme
//                             //               .of(context)
//                             //               .textTheme
//                             //               .headline3
//                             //               .copyWith(fontSize: 16 * factor),
//                             //         ),
//                             //         Icon(
//                             //           Icons.keyboard_arrow_down,
//                             //           color: Theme
//                             //               .of(context)
//                             //               .primaryColor,
//                             //         ),
//                             //       ],
//                             //     ),
//                             //   ),
//                             // );
//                           },
//                         ),
//                         SizedBox(height: 20 * factor),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     CupertinoPageRoute(
//                                         builder: (_) => RulesPage(
//                                               title:
//                                                   "user_agreament_title".tr(),
//                                               text: "service_agreement".tr(),
//                                             )));
//                               },
//                               child: Text(
//                                 "click_to_read".tr(),
//                                 style: TextStyle(
//                                   fontStyle: FontStyle.italic,
//                                   color: Colors.white,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                               ),
//                             ),
//                             Expanded(
//                               child: CheckboxListTile(
//                                 checkColor: Colors.white,
//                                 title: Text(
//                                   "user_agreament".tr(),
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                                 selected: _accepted,
//                                 value: _accepted,
//                                 onChanged: (value) {
//                                   setState(() {
//                                     _accepted = value;
//                                   });
//                                 },
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 20 * factor),
//                         BlocBuilder<AuthBloc, AuthState>(
//                             builder: (context, state) {
//                           return ButtonTheme(
//                             minWidth: width,
//                             height: height * 0.08,
//                             child: RaisedButton(
//                               color: Colors.white,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.all(
//                                       Radius.circular(height * .05))),
//                               onPressed: () {
//                                 _onRegisterButtonPressed();
//                               },
//                               child: state is AuthLoading
//                                   ? LoadingIndicator(
//                                       color: HColors.colorPrimaryDark,
//                                     )
//                                   : Text(
//                                       "register".tr(),
//                                       style: TextStyle(
//                                           color: HColors.colorPrimary),
//                                     ),
//                             ),
//                           );
//                         }),
//                         // NextTextWidget(
//                         //   onTap: () {
//                         //     Navigator.push(
//                         //         context,
//                         //         CupertinoPageRoute(
//                         //             builder: (context) => HomePage()));
//                         //   },
//                         //   text: "goHome".tr(),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ));
//           },
//         ),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
