import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/routes.dart';
import 'package:elherafyeen/widgets/main_ui_widget.dart';
import 'package:elherafyeen/widgets/next_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// phelo

// class LanguagePage extends StatefulWidget {
//   LanguagePage({Key key}) : super(key: key);
//
//   @override
//   _LanguagePageState createState() => _LanguagePageState();
// }
//
// class _LanguagePageState extends State<LanguagePage> {
//   var languages = ["ChooseLang".tr(), "عربي", "English", "francais"];
//   var valueLang = "";
//
//   @override
//   @override
//   void initState() {
//     super.initState();
//     valueLang = languages[0];
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     final _padding = const EdgeInsets.only(right: 16, left: 16);
//
//     final orientation = MediaQuery.of(context).orientation;
//     bool colorChange = false;
//     double factor = 1;
//     //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
//     // if (height > 2040) factor = 3.0;
//
//     return Scaffold(
//       backgroundColor: HColors.colorPrimary,
//       body: Padding(
//         padding: _padding,
//         child: CustomScrollView(
//           slivers: <Widget>[
//             SliverFixedExtentList(
//               itemExtent: height * .15,
//               delegate: SliverChildListDelegate([
//                 Column(
//                   children: [
//                     SizedBox(height: height * .15),
//                     Image.asset(
//                       "assets/Group 2751.png",
//                       height: height * .15,
//                       width: width * .4,
//                     ),
//                     Text(
//                       "welcome".tr(),
//                       style: Theme.of(context)
//                           .textTheme
//                           .headline1
//                           .copyWith(fontSize: 30 * factor, color: Colors.white),
//                     ),
//                     //Spacer(flex: 1),
//                     SizedBox(
//                       height: height * 0.2,
//                     ),
//                     Row(
//                       children: [
//                         SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: InputDecorator(
//                             decoration: const InputDecoration(
//                                 // filled: true,
//                                 // fillColor: Colors.white,
//                                 border: OutlineInputBorder(
//                               borderSide:
//                                   BorderSide(width: 0.5, color: Colors.white),
//                             )),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton(
//                                 //dropdownColor: Colors.amber,
//                                 borderRadius: BorderRadius.circular(25),
//                                 value: valueLang,
//                                 itemHeight: height * 0.08,
//                                 // underline: SizedBox(),
//                                 icon: Icon(
//                                   Icons.keyboard_arrow_down_sharp,
//                                   color: Colors.white,
//                                   size: 19 * factor,
//                                 ),
//                                 items: languages.map((String specialist) {
//                                   colorChange = !colorChange;
//                                   return new DropdownMenuItem(
//                                     value: specialist,
//                                     child: Container(
//                                       //height: height * 0.08,
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(6),
//                                         color: HColors.colorPrimary,
//                                       ),
//                                       child: Column(
//                                         //mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           Container(
//                                               // decoration: BoxDecoration(
//                                               //     borderRadius: BorderRadius.circular(5)),
//                                               alignment: Alignment.center,
//                                               height: height * 0.078,
//                                               width: width * 0.7,
//                                               child: new Text(
//                                                 specialist,
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .headline1
//                                                     .copyWith(
//                                                         fontSize: 20 * factor,
//                                                         color: Colors.white),
//                                               )),
//                                           Divider(
//                                             height: 1,
//                                             thickness: 0.5,
//                                             color: specialist.compareTo(
//                                                         "ChooseLang".tr()) ==
//                                                     0
//                                                 ? Colors.grey
//                                                 : Colors.white,
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 }).toList(),
//                                 onChanged: (String spcial) async {
//                                   print(spcial);
//                                   var local;
//                                   if (spcial == "عربي") {
//                                     context.locale = Locale('ar', 'EG');
//                                     context.setLocale(Locale('ar', 'EG'));
//                                     // local = Locale('ar', 'EG');
//                                     await RegisterModel.shared.saveLang("ar");
//                                     valueLang = languages[1];
//                                   } else if (spcial == "francais") {
//                                     context.locale = Locale('fr', 'FR');
//                                     context.setLocale(Locale('fr', 'FR'));
//                                     local = Locale('fr', 'FR');
//                                     await RegisterModel.shared.saveLang("fr");
//                                     valueLang = languages[3];
//                                   } else {
//                                     context.locale = Locale('en', 'US');
//                                     context.setLocale(Locale('en', 'US'));
//                                     await RegisterModel.shared.saveLang("en");
//                                     valueLang = languages[2];
//                                   }
//                                   await RegisterModel.shared.getLang();
//                                   await RegisterModel.shared.getUserData();
//                                   setState(() {});
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           width: 10,
//                         ),
//                       ],
//                     ),
//                     //Spacer(flex: 4),
//                     NextTextWidget(
//                       onTap: () {
//                         Navigator.pushNamed(
//                             context, Routes.AuthenticationRoute);
//                       },
//                       text: "save".tr(),
//                     ),
//                   ],
//                 ),
//
//                 // Spacer(flex: 1),
//               ]),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

/// basic



import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/routes.dart';
import 'package:elherafyeen/utilities/shared_preferences.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:elherafyeen/widgets/main_ui_widget.dart';
import 'package:elherafyeen/widgets/next_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LanguagePage extends StatefulWidget {
  LanguagePage({Key key}) : super(key: key);

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  var languages = ["ChooseLang".tr(), "عربي", "English", "francais"];
  var valueLang = "";

  @override
  @override
  void initState() {
    super.initState();

    ///ToDo
    // valueLang = PreferenceUtils.getString('${Strings.SPAppLanguage}');
    // print('valueLang = $valueLang');

    valueLang = languages[0];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final _padding = const EdgeInsets.only(right: 16, left: 16);

    final orientation = MediaQuery.of(context).orientation;
    bool colorChange = false;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return Scaffold(
      backgroundColor: HColors.colorPrimary,
      body: Padding(
        padding: _padding,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * .15),
              Image.asset(
                "assets/Group 2751.png",
                height: height * .25,
                width: width * .4,
              ),
              Text(
                "welcome".tr(),
                style: Theme.of(context)
                    .textTheme
                    .headline1
                    .copyWith(fontSize: 28 * factor, color: Colors.white),
              ),
              Spacer(flex: 2),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        // filled: true,
                        // fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide:
                            BorderSide(width: 0.5, color: Colors.white),
                          )),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          elevation: 5,
                          //dropdownColor: Colors.amber,
                          borderRadius: BorderRadius.circular(6),
                          value: valueLang,
                          itemHeight: height * 0.08,
                          // underline: SizedBox(),
                          icon: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.white,
                            size: 19 * factor,
                          ),
                          items: languages.map((String specialist) {
                            colorChange = !colorChange;
                            return new DropdownMenuItem(
                              value: specialist,
                              child: Container(

                                //height: height * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: HColors.colorPrimary,
                                ),
                                child: Column(
                                  //mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      // color: Colors.red,
                                      // decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(5)),
                                        alignment: Alignment.center,
                                        height: height * 0.078,
                                        width: width * 0.7,
                                        child: new Text(
                                          specialist,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              .copyWith(
                                              fontSize: 20 * factor,
                                              color: Colors.white),
                                        )),
                                    Divider(
                                      height: 1,
                                      thickness: 0.5,
                                      color: specialist.compareTo(
                                          "ChooseLang".tr()) ==
                                          0
                                          ? Colors.white54
                                          : Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                            onChanged: (String spcial) async {
                              print(spcial);
                              print('working is ');
                              var local;
                              if (spcial == "عربي") {
                                context.locale = Locale('ar', 'EG');
                                context.setLocale(Locale('ar', 'EG'));
                                // local = Locale('ar', 'EG');
                                await RegisterModel.shared.saveLang("ar");
                                /// beso
                                await RegisterModel.shared.saveLaunchLang("ar");
                                valueLang = languages[1];
                                // ///ToDo
                                // PreferenceUtils.setString('${Strings.SPAppLanguage}','$valueLang');

                                // var show =  PreferenceUtils.getString('${Strings.SPAppLanguage}');
                                // print('mylanguage is $show');

                              } else if (spcial == "francais") {
                                context.locale = Locale('fr', 'FR');
                                context.setLocale(Locale('fr', 'FR'));
                                local = Locale('fr', 'FR');
                                await RegisterModel.shared.saveLang("fr");
                                /// beso
                                await RegisterModel.shared.saveLaunchLang("fr");
                                valueLang = languages[3];
                                ///ToDo

                                // await PreferenceUtils.setString('${Strings.SPAppLanguage}','$valueLang');

                              } else {
                                context.locale = Locale('en', 'US');
                                context.setLocale(Locale('en', 'US'));
                                await RegisterModel.shared.saveLang("en");
                                /// beso
                                await RegisterModel.shared.saveLaunchLang("en");
                                valueLang = languages[2];
                                ///ToDo
                                // PreferenceUtils.setString('${Strings.SPAppLanguage}','$valueLang');

                              }
                              await RegisterModel.shared.getLang();
                              await RegisterModel.shared.getUserData();
                              setState(() {});
                            },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              // MainUiWidget(
              //   width: width,
              //   height: height * .25,
              //   child: DropdownButton(
              //     value: valueLang,
              //     itemHeight: height * 0.08,
              //     underline: SizedBox(),
              //     icon: Icon(
              //       Icons.keyboard_arrow_down_sharp,
              //       color: Colors.grey,
              //       size: 19 * factor,
              //     ),
              //     items: languages.map((String specialist) {
              //       colorChange = !colorChange;
              //       return new DropdownMenuItem(
              //         value: specialist,
              //         child: Container(
              //           height: height * 0.08,
              //           color: Colors.transparent,
              //           child: Column(
              //             mainAxisSize: MainAxisSize.min,
              //             children: [
              //               Container(
              //                   alignment: Alignment.center,
              //                   height: height * 0.078,
              //                   width: width * 0.7,
              //                   child: new Text(
              //                     specialist,
              //                     style: Theme.of(context)
              //                         .textTheme
              //                         .headline1
              //                         .copyWith(
              //                             fontSize: 20 * factor,
              //                             color: Colors.grey),
              //                   )),
              //               Divider(
              //                 height: 1,
              //                 thickness: 0.5,
              //               )
              //             ],
              //           ),
              //         ),
              //       );
              //     }).toList(),
              //     onChanged: (String spcial) async {
              //       print(spcial);
              //       print('working is ');
              //       var local;
              //       if (spcial == "عربي") {
              //         context.locale = Locale('ar', 'EG');
              //         context.setLocale(Locale('ar', 'EG'));
              //         // local = Locale('ar', 'EG');
              //         await RegisterModel.shared.saveLang("ar");
              //         /// beso
              //         await RegisterModel.shared.saveLaunchLang("ar");
              //         valueLang = languages[1];
              //         // ///ToDo
              //         // PreferenceUtils.setString('${Strings.SPAppLanguage}','$valueLang');
              //
              //         // var show =  PreferenceUtils.getString('${Strings.SPAppLanguage}');
              //         // print('mylanguage is $show');
              //
              //       } else if (spcial == "francais") {
              //         context.locale = Locale('fr', 'FR');
              //         context.setLocale(Locale('fr', 'FR'));
              //         local = Locale('fr', 'FR');
              //         await RegisterModel.shared.saveLang("fr");
              //         /// beso
              //         await RegisterModel.shared.saveLaunchLang("fr");
              //         valueLang = languages[3];
              //         ///ToDo
              //
              //         // await PreferenceUtils.setString('${Strings.SPAppLanguage}','$valueLang');
              //
              //       } else {
              //         context.locale = Locale('en', 'US');
              //         context.setLocale(Locale('en', 'US'));
              //         await RegisterModel.shared.saveLang("en");
              //         /// beso
              //         await RegisterModel.shared.saveLaunchLang("en");
              //         valueLang = languages[2];
              //         ///ToDo
              //         // PreferenceUtils.setString('${Strings.SPAppLanguage}','$valueLang');
              //
              //       }
              //       await RegisterModel.shared.getLang();
              //       await RegisterModel.shared.getUserData();
              //       setState(() {});
              //     },
              //   ),
              // ),
              Spacer(flex: 4),
              NextTextWidget(
                onTap: () async{
                  Navigator.pushNamed(context, Routes.AuthenticationRoute);
                },
                text: "save".tr(),
              ),
              Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}

