import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/pages/home/tab_bar_page.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/widgets/main_ui_widget.dart';
import 'package:elherafyeen/widgets/next_text_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var languages = ["ChooseLang".tr(), "عربي", "English", "francais"];
  var valueLang = "";

  @override
  @override
  void initState() {
    super.initState();
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
            MainUiWidget(
              width: width,
              height: height * .25,
              child: DropdownButton(
                value: valueLang,
                itemHeight: height * 0.08,
                underline: SizedBox(),
                icon: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: Colors.grey,
                  size: 19 * factor,
                ),
                items: languages.map((String specialist) {
                  colorChange = !colorChange;
                  return new DropdownMenuItem(
                    value: specialist,
                    child: Container(
                      height: height * 0.08,
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
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
                                        color: Colors.grey),
                              )),
                          Divider(
                            height: 1,
                            thickness: 0.5,
                          )
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String spcial) {
                  print(spcial);
                  if (spcial == "عربي") {
                    context.locale = Locale('ar', 'EG');
                    RegisterModel.shared.saveLang("ar");
                    RegisterModel.shared.saveLaunchLang("ar");
                    valueLang = languages[1];
                    RegisterModel.shared.getUserData();
                    RegisterModel.shared.getLang();
                  } else if (spcial == "francais") {
                    context.locale = Locale('en', 'US');
                    RegisterModel.shared.saveLang("fr");
                    RegisterModel.shared.saveLaunchLang("fr");
                    valueLang = languages[3];
                    RegisterModel.shared.getUserData();
                    RegisterModel.shared.getLang();
                  } else {
                    context.locale = Locale('en', 'US');
                    RegisterModel.shared.saveLang("en");
                    RegisterModel.shared.saveLaunchLang("en");
                    valueLang = languages[2];
                    RegisterModel.shared.getUserData();
                    RegisterModel.shared.getLang();
                  }
                  setState(() {
                    RegisterModel.shared.getLang();
                  });
                },
              ),
            ),
            Spacer(flex: 4),
            NextTextWidget(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                        builder: (_) => TabBarPage(
                              currentIndex: 0,
                            )),
                    (route) => false);
              },
              text: "save".tr(),
            ),
            Spacer(flex: 1),
          ],
        ),
      ),
    );
  }
}
