import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:elherafyeen/utilities/colors.dart';
import 'package:elherafyeen/utilities/error_bar.dart';
import 'package:elherafyeen/widgets/loading_indicator.dart';
import 'package:elherafyeen/widgets/rounded_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChangePassword extends StatefulWidget {
  ChangePassword({Key key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var oldPassCtrl = TextEditingController();
  var newPassCtrl = new TextEditingController();
  var conPassCtrl = new TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final orientation = MediaQuery.of(context).orientation;
    double factor = 1;
    //if (height > 1080 || orientation == Orientation.landscape) factor = 2.0;
    // if (height > 2040) factor = 3.0;

    return Scaffold(
        appBar: AppBar(
          title: Text("change_password".tr()),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () => Navigator.pop(context)),
        ),
        backgroundColor: Colors.white,
        body: Builder(builder: (context) {
          _addWinshButtonPressed() async {
            setState(() => _loading = true);

            try {
              final response = await http.post(
                  Uri.parse(Strings.apiLink +
                      "change_password?lang=${RegisterModel.shared.lang}"),
                  body: {
                    "current_password": oldPassCtrl.text,
                    "new_password": newPassCtrl.text,
                    "confirm_password": conPassCtrl.text,
                  },
                  headers: {
                    "Authorization": "Bearer " + RegisterModel.shared.token
                  });
              final body = json.decode(response.body);
              print("mahmoud" + body.toString());

              if (body['status'] == "failed") {
                print(body['errors']);
                setState(() => _loading = false);
                Fluttertoast.showToast(
                    msg: body["errors"].toString(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                setState(() => _loading = false);
                Fluttertoast.showToast(
                    msg: "pass_changed".tr(),
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                print(body.toString());
              }
            } catch (e) {
              setState(() => _loading = false);
              errorSnackBar(e.toString(), context);
              Fluttertoast.showToast(
                  msg: e.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
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
                        RoundedTextField(
                          labelText: "current_pass".tr(),
                          controller: oldPassCtrl,
                          onChanged: (text) {},
                          isEnabled: true,
                          obscureText: true,
                          // focusNode: capacityFocus,
                          inputType: TextInputType.text,
                        ),
                        RoundedTextField(
                          labelText: "new_pass".tr(),
                          controller: newPassCtrl,
                          onChanged: (text) {},
                          isEnabled: true,
                          obscureText: true,
                          // focusNode: dateFocus,
                          inputType: TextInputType.text,
                        ),
                        RoundedTextField(
                          labelText: "con_pass".tr(),
                          controller: conPassCtrl,
                          obscureText: true,
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
                              child: Text(
                                "ok".tr(),
                                style: TextStyle(color: HColors.colorButton),
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
        }));
  }
}
