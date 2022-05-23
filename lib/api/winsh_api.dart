import 'dart:convert';

import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class WinshApi {
  static final _url = Strings.apiLink;

  static Future<bool> addWinsh({
    BuildContext context,
    bool staff_id: false,
    String country_id,
    String country_code,
    String company_name,
    String whatsapp,
    String phone2,
    String driver_name,
    String lat,
    String lng,
    String company_img,
    String winsh_img,
  }) async {
    String url = "";

    if (staff_id)
      url = "add_winches_company";
    else
      url = "addWinsh";
    final response = await http.post(
        Uri.parse(_url + "$url?lang=${RegisterModel.shared.lang}"),
        body: {
          'country_id': country_id,
          'country_code': country_code,
          'company_name': company_name,
          'whatsapp': whatsapp,
          'phone2': phone2,
          "driver_name": driver_name,
          "lat": lat,
          "lng": lng,
          "company_img": "data:image/jpeg;base64," + company_img,
          "winsh_img": "data:image/jpeg;base64," + winsh_img,
        },
        headers: {
          "Authorization": "Bearer " + RegisterModel.shared.token,
          "Accept": "application/json"
        });
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print(body['errors']);
      throw body['errors'];
    } else {
      print(body.toString());
      return true;
    }
  }

  static Future<bool> addWinchCompany({
    BuildContext context,
    bool staff: false,
    String country_id,
    String country_code,
    String company_name,
    String whatsapp,
    String phone2,
    String driver_name,
    String lat,
    String lng,
    String company_img,
    String winsh_img,
  }) async {
    String url = "";

    if (staff)
      url = "staff/add_winches_company";
    else
      url = "addWinchesCompany";
    final response = await http.post(
        Uri.parse(_url + "$url?lang=${RegisterModel.shared.lang}"),
        body: {
          'country_id': country_id,
          // 'country_code': country_code,
          'company_name': company_name,
          'whatsapp': whatsapp,
          'phone': whatsapp,
          'phone2': phone2,
          'whatsapp': whatsapp,
          "owner_name": driver_name,
          "lat": lat,
          "lng": lng,
          "company_img": "data:image/jpeg;base64," + company_img,
          // "winsh_img": "data:image/jpeg;base64," + winsh_img,
        },
        headers: {
          "Authorization": "Bearer " + RegisterModel.shared.token,
          "Accept": "application/json"
        });
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print(body['errors']);
      throw body['errors'];
    } else {
      print(body.toString());
      return true;
    }
  }

  static Future<bool> addWinchIndividual({
    BuildContext context,
    bool staff: false,
    String country_id,
    String country_code,
    String whatsapp,
    String phone2,
    String driver_image,
    String driver_name,
    String lat,
    String lng,
    String winsh_img,
    String drivingLicenceFront,
    String drivingLicenceBack,
    String winchLicenceFront,
    String winchLicenceBack,
  }) async {
    String url = "";

    if (staff)
      url = "staff/add_individual_winch";
    else
      url = "addIndividualWinch";

    final response = await http.post(
        Uri.parse(_url + "$url?lang=${RegisterModel.shared.lang}"),
        body: {
          'country_id': country_id,
          // 'country_code': country_code,
          // 'company_name': company_name,
          'whatsapp': whatsapp,
          'phone': phone2,
          // "driver_name": driver_name,
          "lat": lat,
          "lng": lng,
          "driver_name": driver_name,
          "driver_image": "data:image/jpeg;base64," + driver_image,
          "winch_image": "data:image/jpeg;base64," + winsh_img,

          "drivingLicenceFront":
              "data:image/jpeg;base64," + drivingLicenceFront,
          "drivingLicenceBack": "data:image/jpeg;base64," + drivingLicenceBack,
          "winchLicenceFront": "data:image/jpeg;base64," + winchLicenceFront,
          "winchLicenceBack": "data:image/jpeg;base64," + winchLicenceBack,
        },
        headers: {
          "Authorization": "Bearer " + RegisterModel.shared.token,
          "Accept": "application/json"
        });
    final body = json.decode(response.body);
    print("mahmoud" + body.toString());

    if (body['status'] == "failed") {
      print(body['errors']);
      throw body['errors'];
    } else {
      print(body.toString());
      return true;
    }
  }

  static String winchesNum = null;

  static Future<List<VendorModel>> fetchWinchesForIndividuals(
      {String lat, String lng, int page}) async {
    final response = await http.get(Uri.parse(_url +
        "getNearbyIndividualWinches?page=$page&lang=${RegisterModel.shared.lang}&"
            "current_lat=$lat&current_lng=$lng&page=$page"));

    print("current_lat=$lat&current_lng=$lng&page=$page");
    final body = json.decode(response.body);
    print(body.toString());
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      try {
        if (body['result']['count'].toString() != "null") {
          winchesNum = body['result']['count'].toString();
        }
      } catch (e) {}

      return List<VendorModel>.from(
          body['result']['winches'].map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> fetchWinchesForCompany(
      {String lat, String lng, int page}) async {
    print(lat + lng + page.toString());
    final response = await http.get(Uri.parse(_url +
        "getNearbyWinchesCompanies?lang=${RegisterModel.shared.lang}&"
            "current_lat=$lat&current_lng=$lng&page=$page"));
    final body = json.decode(response.body);
    print(response.body.toString());
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(
          body['result']['winches'].map((data) => VendorModel.fromMap(data)));
    }
  }
}
