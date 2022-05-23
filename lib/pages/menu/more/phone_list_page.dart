import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/api/home_api.dart';
import 'package:elherafyeen/models/phone_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:elherafyeen/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class PhoneListPage extends StatefulWidget {
  const PhoneListPage({Key key}) : super(key: key);

  @override
  _PhoneListPageState createState() => _PhoneListPageState();
}

class _PhoneListPageState extends State<PhoneListPage> {
  PhoneModel phones;
  bool _create = true;
  var phone1 = TextEditingController();
  var phone2 = TextEditingController();
  var phone3 = TextEditingController();
  var name1 = TextEditingController();
  var name2 = TextEditingController();
  var name3 = TextEditingController();

  var _loading = false;

  @override
  void initState() {
    super.initState();
    loadPhones();
  }

  loadPhones() async {
    phones = await HomeApi.get_user_numbers_list();
    if (phones.phone1.isNotEmpty) {
      phone1.text = phones.phone1;
      name1.text = phones.name1;
      _create = false;
    }
    if (phones.phone2.isNotEmpty) {
      phone2.text = phones.phone2;
      name2.text = phones.name2;
      _create = false;
    }
    if (phones.phone3.isNotEmpty) {
      phone3.text = phones.phone3;
      name3.text = phones.name3;
      _create = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var space = SizedBox(height: 10);
    return Scaffold(
      appBar: AppBar(
        title: Text("numList".tr()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              CustomTextField(
                controller: name1,
                labelText: "name1".tr(),
                onChanged: (text) {
                  phones.name1 = text;
                  setState(() {});
                },
              ),
              space,
              CustomTextField(
                controller: phone1,
                labelText: "phone1".tr(),
                inputType: TextInputType.phone,
                onChanged: (text) {
                  phones.phone1 = text;
                  setState(() {});
                },
              ),
              space,
              CustomTextField(
                controller: name2,
                labelText: "name2".tr(),
                onChanged: (text) {
                  phones.name2 = text;
                  setState(() {});
                },
              ),
              space,
              CustomTextField(
                controller: phone2,
                labelText: "phone2m".tr(),
                inputType: TextInputType.phone,
                onChanged: (text) {
                  phones.phone2 = text;
                  setState(() {});
                },
              ),
              space,
              CustomTextField(
                controller: name3,
                labelText: "name3".tr(),
                onChanged: (text) {
                  phones.name3 = text;
                  setState(() {});
                },
              ),
              space,
              CustomTextField(
                controller: phone3,
                labelText: "phone3".tr(),
                inputType: TextInputType.phone,
                onChanged: (text) {
                  phones.phone3 = text;
                  setState(() {});
                },
              ),
              space,
              space,
              TextButton(
                onPressed: () async {
                  try {
                    await updateNumberList();
                    setState(() {
                      _loading = false;
                    });
                    Fluttertoast.showToast(msg: "success".tr());
                  } catch (e) {
                    Fluttertoast.showToast(msg: e.toString());
                  }
                },
                child: Text("ok".tr()),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> updateNumberList() async {
    setState(() {
      _loading = true;
    });
    var url = "";
    if (_create) {
      url = "create_user_numbers_list";
    } else
      url = "update_user_numbers_list_by_user_id";

    final response = await http.post(Uri.parse(Strings.apiLink + url), body: {
      "phone1": phone1.text,
      "name1": name1.text,
      "name2": name2.text,
      "phone2": phone2.text,
      "name3": name3.text,
      "phone3": phone3.text,
    }, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
      "Accept": "application/json"
    });
    final body = json.decode(response.body);
    print("MAHMOUD   " + body.toString());
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      print(body.toString());
      return true;
    }
  }
}
