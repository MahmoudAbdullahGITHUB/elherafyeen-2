import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

/// Responsible of handling themes.
class CustomThemeMode {
  static var _textTheme = TextTheme(
      headline1: TextStyle(
          color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
      headline2: TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w600),
      headline3: TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w500),
      headline4: TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w400),
      headline5: TextStyle(
          color: Colors.black, fontSize: 22, fontWeight: FontWeight.w300),
      bodyText1: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
      bodyText2: TextStyle(
          color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
      subtitle1: TextStyle(
          color: Color(0xff6A6A6A), fontSize: 14, fontWeight: FontWeight.w500),
      subtitle2: TextStyle(
          color: Color(0xff6A6A6A), fontSize: 14, fontWeight: FontWeight.w400),
      button: TextStyle(
          color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700));

  static light(BuildContext context) {
    return ThemeData(
        primaryColor: HColors.colorPrimary,
        buttonColor: HColors.colorAccent,
        backgroundColor: HColors.colorPrimary,
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        fontFamily: 'Cairo',
        textTheme: _textTheme);
  }
}
