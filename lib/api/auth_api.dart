import 'dart:convert';

import 'package:elherafyeen/models/country_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static final _url = Strings.apiLink;

  /// Used to log the user in, if successful, user data is cached.
  static Future<bool> login({
    String phone,
    String password,
  }) async {
    final response = await http.post(
        Uri.parse(_url + "login?lang=${RegisterModel.shared.lang}"),
        body: {'phone': phone, 'password': password});
    Map<String, dynamic> body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body.toString());
      throw body['errors'];
    } else {
      if (body['result']['user']['type_id'] == null) {
        await RegisterModel.shared.fromJsonRegister(body["result"]);
        await RegisterModel.shared.saveUserData();
        await RegisterModel.shared.getUserData();
        throw "-1";
      } else {
        await RegisterModel.shared.fromJson(body["result"]);
        await RegisterModel.shared.saveUserData();
        await RegisterModel.shared.getUserData();
        return true;
      }
    }
  }

  static Future<List<CountryModel>> fetchCountries() async {
    final response = await http.get(Uri.parse(
      _url + "getCountries?lang=${RegisterModel.shared.lang}",
    ));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<CountryModel>.from(
          body['result'].map((country) => CountryModel.fromMap(country)));
    }
  }

  /// Used to register the user in, if successful, user data is cached.
  static Future<bool> register({
    String counrtyId,
    String lang,
    String name,
    String phone,
    String whatsapp,
    String password,
  }) async {
    final response = await http.post(
        Uri.parse(_url + "register?lang=${RegisterModel.shared.lang}"),
        body: {
          'lang': lang,
          'country_id': counrtyId,
          'password': password,
          'whatsapp': whatsapp,
          'confirm_password': password,
          "name": name,
          "phone": phone,
        });
    print(Strings.appName + response.body.toString());
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      await RegisterModel.shared.fromJsonRegister(body["result"]);
      await RegisterModel.shared.saveUserData();
      await RegisterModel.shared.getUserData();
      return true;
    }
  }

  static Future<void> logout() async {
    await RegisterModel.shared.deleteUserData();
  }
}
