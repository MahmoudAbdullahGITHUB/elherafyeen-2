import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/bloc/auth/auth_bloc.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/pages/auth/more_auth/account_type.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/constants.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/main_ui_widget.dart';
import 'package:elherafyeen/widgets/regular_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.filteredPhone = ''}) : super(key: key);
  String filteredPhone;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();

  final String initialCountry = 'EG';
  PhoneNumber number = PhoneNumber(isoCode: 'EG');
  // String _phone = '';
  bool visConf = false;

  String address = 'search';
  String countryName = 'search';
  String countryDialCode = '20';
  String countryIsoCode = 'EG';
  double latitude;
  double longitude;
  var currentLocation;

  var passSecured = true;
  // setUserPhone(phone) async {
  //   print("widget phone ${widget.filteredPhone}  ");
  //   // print("phone : $_phone");
  //   // final prefs = await SharedPreferences.getInstance();
  //   // prefs.setString('phone', phone);
  //   CacheHelper.saveUserPhone(phone);
  // }
  // setUserPhone(phoneController.text);

  @override
  void initState() {
    super.initState();

    getCurrentLocation();
    // _phone = widget.filteredPhone;
    // print('fucking phone ooo $_phone');
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
      countryIsoCode =  place.isoCountryCode;
      // number.isoCode = countryIsoCode;
      print('local  $address oooo $countryIsoCode');

      countryDialCode = await getCountryDialCode();

      print('countryDialCode $countryDialCode');

      result = {
        "latitude": currentLocation.latitude,
        "longitude": currentLocation.longitude
      };
      print('here we are again login ${result['latitude']} ${result['longitude']}');

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
      body: BlocProvider(
        create: (_) => AuthBloc(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ///Function that show snackBar
              ///required [error] content of error and [context]
              if (state.error == "-1") {
                errorSnackBar(state.error, context);
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (_) => AccountType()),
                        (route) => false);
              } else
                errorSnackBar(state.error, context);
            }
            if (state is RegisterDone) {
              if (state.result) {
                Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(
                        builder: (_) => TabBarPage(currentIndex: 0)),
                        (route) => false);
                if (!Platform.isWindows) {
                  OneSignal.shared.setExternalUserId(RegisterModel.shared.id);
                }
              } else {
                errorSnackBar("Error....", context, success: true);
              }
            }
          },
          child: Builder(builder: (context) {
            // print('fff');
            // print("phone******${phoneController.text}");
            // setUserPhone(phoneController.text);
            _loginButtonPressed() {
              // print('login button pressed ${phoneController.text}');
              BlocProvider.of<AuthBloc>(context).add(
                LoginButtonPressed(
                    phone: phoneController.text,
                    password: passwordController.text),
              );
            }

            return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              return SingleChildScrollView(
                child: Container(
                  // color: HColors.colorPrimary,
                  padding: EdgeInsets.all(16),

                  child: Column(
                    children: [
                      Container(
                      // width: width * .3,
                      // height: height * .2,
                      // padding: EdgeInsets.all(3),
                      // decoration: BoxDecoration(
                      //   // border: Border.all(
                      //   //   color: Colors.white,
                      //   // ),
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
                      Divider(height: height*.05,color: Colors.transparent,),
                      Card(
                        elevation: 5,
                        // shadowColor: Colors.blueAccent,
                        // color: HColors.colorPrimary,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 25 * factor,
                            ),
                            Container(
                              // color: Colors.red,
                              decoration: BoxDecoration(
                                // color: Colors.red,
                                  border: Border.all(color: Colors.grey),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                // child: InternationalPhoneNumberInput(
                                //
                                //   onInputChanged: (PhoneNumber number) {
                                //     print('isoCodeisoCode = ${number.isoCode}');
                                //       },
                                //   onInputValidated: (bool value) {
                                //     print(value);
                                //   },
                                //   selectorConfig: const SelectorConfig(
                                //     selectorType: PhoneInputSelectorType.DIALOG,
                                //   ),
                                //   ignoreBlank: false,
                                //   autoValidateMode: AutovalidateMode.disabled,
                                //   inputDecoration: InputDecoration(
                                //     prefixIcon: Icon(
                                //       Icons.phone,
                                //       color: Colors.grey,
                                //     ),
                                //     labelText: "phone".tr(),
                                //     prefixIconConstraints:
                                //     BoxConstraints(minWidth: 30 * factor),
                                //     labelStyle: Theme.of(context)
                                //         .textTheme
                                //         .headline2
                                //         .copyWith(fontSize: 14 * factor),
                                //     // border: OutlineInputBorder(
                                //     //   borderSide: BorderSide(
                                //     //     width: 0.5,
                                //     //   ),
                                //     //   borderRadius: const BorderRadius.all(
                                //     //       Radius.circular(5)
                                //     //   ),
                                //     // ),
                                //     // focusedBorder: OutlineInputBorder(
                                //     //   borderSide: BorderSide(
                                //     //     width: 0.1,
                                //     //   ),
                                //     //   borderRadius: const BorderRadius.all(
                                //     //     Radius.circular(5),
                                //     //   ),
                                //     // ),
                                //   ),
                                //   textStyle: Theme.of(context)
                                //       .textTheme
                                //       .headline3
                                //       .copyWith(fontSize: 16 * factor),
                                //   selectorTextStyle: Theme.of(context)
                                //       .textTheme
                                //       .headline3
                                //       .copyWith(fontSize: 16 * factor),
                                //   initialValue: number,
                                //   textFieldController: phoneController,
                                //   formatInput: false,
                                //   keyboardType:
                                //   const TextInputType.numberWithOptions(
                                //       signed: true, decimal: true),
                                //   //inputBorder: const OutlineInputBorder(),
                                //   onSaved: (PhoneNumber number) {
                                //     print('On Saved: $number');
                                //   },
                                // ),
                                child: InternationalPhoneNumberInput(
                                  //hintText: "phone".tr(),
                                  onInputChanged: (PhoneNumber number) {

                                    if (phoneController.text.isEmpty) {
                                      setState(() {
                                        visConf = false;
                                      });
                                    }
                                    if (widget.filteredPhone
                                        .contains(phoneController.text)) {
                                      setState(() {
                                        visConf = true;
                                      });
                                    } else {
                                      setState(() {
                                        visConf = false;
                                      });
                                    }
                                  },
                                  onInputValidated: (bool value) {
                                    print(value);
                                  },

                                  selectorConfig: const SelectorConfig(
                                    selectorType: PhoneInputSelectorType.DIALOG,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,

                                  inputDecoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Colors.grey,
                                    ),
                                    labelText: "phone".tr(),
                                    prefixIconConstraints:
                                    BoxConstraints(minWidth: 30 * factor),
                                    labelStyle: Theme.of(context)
                                        .textTheme
                                        .headline2
                                        .copyWith(fontSize: 14 * factor),
                                    border: InputBorder.none,
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
                                    // focusedBorder: OutlineInputBorder(
                                    //   borderSide: BorderSide(
                                    //     width: 0.1,
                                    //   ),
                                    //   borderRadius: const BorderRadius.all(
                                    //     Radius.circular(5),
                                    //   ),
                                    // ),
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
                            SizedBox(
                              height: 10,
                            ),


                            SizedBox(
                              height: 10 * factor,
                            ),
                            Visibility(
                              visible: visConf,
                              child: InkWell(
                                onTap: () {
                                  phoneController.text = widget.filteredPhone;
                                  visConf = false;
                                  setState(() {});
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6),
                                  margin: EdgeInsets.all(6),
                                  color: Colors.white.withOpacity(0.5),
                                  child: Text(
                                    "${widget.filteredPhone}",
                                    style: TextStyle(
                                        color:
                                        Color.fromRGBO(195, 201, 201, 1)),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              // color: Colors.red,
                              child: RegularTextField(
                                labelText: "pass".tr(),
                                controller: passwordController,
                                onChanged: (text) {},
                                isEnabled: true,
                                focusNode: passFocusNode,
                                inputType: TextInputType.text,
                                obscureText: passSecured,
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
                                    color: Colors.grey,
                                    size: 15 * factor,
                                  ),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25 * factor,
                            ),
                            // NextTextWidget(
                            //   onTap: () {
                            //     Navigator.pushNamed(context, Routes.HomeRoute);
                            //   },
                            //   text: "goHome".tr(),
                            // ),
                          ],
                        )),
                      ),
                      Divider(height: height*.05,color: Colors.transparent,),
                      ElevatedButton(
                        // color: HColors.colorPrimaryDark,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.all(
                        //         Radius.circular(height * .05))),
                        onPressed: () {
                          print('fff');
                          print("phone******${phoneController.text}");
                          RegisterModel.shared
                              .saveSuggestionPhone(phoneController.text);
                          _loginButtonPressed();
                        },
                        child: state is AuthLoading
                            ? LoadingIndicator(
                          color: HColors.colorPrimaryDark,
                        )
                            : Text(
                          "login".tr(),
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: HColors.colorPrimaryDark,
                            fixedSize: Size(width * 0.5, width * 0.12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                barrierColor: Colors.white.withOpacity(0),
                                backgroundColor: Colors.white.withOpacity(0),
                                builder: (_) => Card(
                                  margin: EdgeInsets.all(12),
                                  color: Colors.white,
                                  child: Container(
                                    padding: EdgeInsets.all(30),
                                    child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text("forgetPassPmt".tr()),
                                            Text("01010084222"),
                                          ],
                                        )),
                                  ),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("forgetPass".tr()),
                          )),
                    ],
                  ),
                ),
              );
            });
          }),
        ),
      ),
    );
  }
}


/// basic
// import 'dart:io';
//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:elherafyeen/bloc/auth/auth_bloc.dart';
// import 'package:elherafyeen/models/register_model.dart';
// import 'package:elherafyeen/pages/auth/more_auth/account_type.dart';
// import 'package:elherafyeen/pages/home/tab_bar_page.dart';
// import 'package:elherafyeen/utilities/colors.dart';
// import 'package:elherafyeen/utilities/error_bar.dart';
// import 'package:elherafyeen/widgets/loading_indicator.dart';
// import 'package:elherafyeen/widgets/main_ui_widget.dart';
// import 'package:elherafyeen/widgets/regular_text_field.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';
//
// class LoginPage extends StatefulWidget {
//   LoginPage({Key key}) : super(key: key);
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   var phoneController = TextEditingController();
//   var passwordController = TextEditingController();
//   FocusNode phoneFocusNode = FocusNode();
//   FocusNode passFocusNode = FocusNode();
//
//   var passSecured = true;
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
//       body: BlocProvider(
//         create: (_) => AuthBloc(),
//         child: BlocListener<AuthBloc, AuthState>(
//           listener: (context, state) {
//             if (state is AuthError) {
//               ///Function that show snackBar
//               ///required [error] content of error and [context]
//               if (state.error == "-1") {
//                 errorSnackBar(state.error, context);
//                 Navigator.pushAndRemoveUntil(
//                     context,
//                     CupertinoPageRoute(builder: (_) => AccountType()),
//                     (route) => false);
//               } else
//                 errorSnackBar(state.error, context);
//             }
//             if (state is RegisterDone) {
//               if (state.result) {
//                 Navigator.of(context).pushAndRemoveUntil(
//                     CupertinoPageRoute(
//                         builder: (_) => TabBarPage(currentIndex: 0)),
//                     (route) => false);
//                 if (!Platform.isWindows) {
//                   OneSignal.shared.setExternalUserId(RegisterModel.shared.id);
//                 }
//               } else {
//                 errorSnackBar("Error....", context, success: true);
//               }
//             }
//           },
//           child: Builder(builder: (context) {
//             _loginButtonPressed() {
//               BlocProvider.of<AuthBloc>(context).add(
//                 /// TODO
//                 LoginButtonPressed(
//                   // phone: phoneController.text,
//                   // password: passwordController.text
//                   phone: '01099890392',
//                   password: '123456',
//                 ),
//               );
//             }
//
//             return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
//               return SingleChildScrollView(
//                 child: Container(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         "assets/Group 2751.png",
//                         width: width * .2,
//                         height: height * .1,
//                         fit: BoxFit.fill,
//                       ),
//                       SizedBox(
//                         height: 20 * factor,
//                       ),
//                       MainUiWidget(
//                         // height: height * .3,
//                         width: width,
//                         child: Column(
//                           children: [
//                             RegularTextField(
//                               labelText: "phone".tr(),
//                               controller: phoneController,
//                               onChanged: (text) {},
//                               isEnabled: true,
//                               focusNode: phoneFocusNode,
//                               inputType: TextInputType.number,
//                               prefixIcon: Icon(
//                                 Icons.phone,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             RegularTextField(
//                               labelText: "pass".tr(),
//                               controller: passwordController,
//                               onChanged: (text) {},
//                               isEnabled: true,
//                               focusNode: passFocusNode,
//                               inputType: TextInputType.text,
//                               obscureText: passSecured,
//                               suffixIcon: IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     passSecured = !passSecured;
//                                   });
//                                 },
//                                 icon: Icon(
//                                   !passSecured
//                                       ? FontAwesomeIcons.eyeSlash
//                                       : FontAwesomeIcons.eye,
//                                   color: Colors.grey,
//                                   size: 15 * factor,
//                                 ),
//                               ),
//                               prefixIcon: Icon(
//                                 Icons.lock,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             SizedBox(
//                               height: 25 * factor,
//                             )
//                           ],
//                         ),
//                       ),
//                       ButtonTheme(
//                         minWidth: width,
//                         child: RaisedButton(
//                           color: Colors.white,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.all(
//                                   Radius.circular(height * .05))),
//                           onPressed: () {
//                             _loginButtonPressed();
//                           },
//                           child: state is AuthLoading
//                               ? LoadingIndicator(
//                                   color: HColors.colorPrimaryDark,
//                                 )
//                               : Text(
//                                   "login".tr(),
//                                   style: TextStyle(color: HColors.colorPrimary),
//                                 ),
//                         ),
//                       ),
//                       InkWell(
//                           onTap: () {
//                             showModalBottomSheet(
//                                 context: context,
//                                 barrierColor: Colors.white.withOpacity(0),
//                                 backgroundColor: Colors.white.withOpacity(0),
//                                 builder: (_) => Card(
//                                       margin: EdgeInsets.all(12),
//                                       color: Colors.white,
//                                       child: Container(
//                                         padding: EdgeInsets.all(30),
//                                         child: Center(
//                                             child: Column(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Text("forgetPassPmt".tr()),
//                                             Text("01010084222"),
//                                           ],
//                                         )),
//                                       ),
//                                     ));
//                           },
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text("forgetPass".tr()),
//                           )),
//                       // NextTextWidget(
//                       //   onTap: () {
//                       //     Navigator.pushNamed(context, Routes.HomeRoute);
//                       //   },
//                       //   text: "goHome".tr(),
//                       // ),
//                     ],
//                   ),
//                 ),
//               );
//             });
//           }),
//         ),
//       ),
//     );
//   }
// }
