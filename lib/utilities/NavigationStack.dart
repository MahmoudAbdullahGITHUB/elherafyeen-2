import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InheritedDataModel extends InheritedWidget {
  AnimationController controller;
  final Widget child;
  InheritedDataModel({this.child});

  static InheritedDataModel of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
