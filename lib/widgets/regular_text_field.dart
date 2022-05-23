import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegularTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String errorText;
  final String labelText;
  final TextInputType inputType;
  final bool obscureText;
  final bool isEnabled;
  final void Function(String val) onSubmitted;
  final void Function(String val) onChanged;
  final Widget prefixIcon;
  final Widget suffixIcon;

  RegularTextField(
      {Key key,
      this.controller,
      this.prefixIcon,
      this.onSubmitted,
      this.onChanged,
      this.focusNode,
      this.errorText,
      this.obscureText,
      this.isEnabled = true,
      this.labelText,
      this.suffixIcon,
      this.inputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final orientation = MediaQuery.of(context).orientation;

    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onSubmitted: onSubmitted,
      keyboardType: inputType,
      onChanged: onChanged,
      enabled: isEnabled,
      obscureText: obscureText ?? false,
      style:
          Theme.of(context).textTheme.headline3.copyWith(fontSize: 16 * factor),
      decoration: InputDecoration(
        errorText: errorText,
        prefixIcon: prefixIcon,
        labelText: labelText,
        prefixIconConstraints: BoxConstraints(minWidth: 30 * factor),
        suffixIcon: suffixIcon,
        labelStyle: Theme.of(context)
            .textTheme
            .headline2
            .copyWith(fontSize: 14 * factor),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 0.5, color: Colors.grey),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
    );
  }
}
