import 'dart:convert';

import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/shipping_type_model.dart';
import 'package:elherafyeen/pages/auth/authentication_page.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ShippingApi {
  static final _url = Strings.apiLink;

  static Future<List<ShippingTypeModel>> fetchShippingTypes() async {
    final response = await http.get(
        Uri.parse(_url + "getShippingTypes?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<ShippingTypeModel>.from(
          body['result'].map((data) => ShippingTypeModel.fromMap(data)));
    }
  }

  static Future<bool> addShippingCompany({
    BuildContext context,
    bool staff,
    String country_id,
    String country_code,
    String company_name,
    String shipping_type,
    String company_phone,
    String phone2,
    String phone,
    String whatsapp,
    String owner_name,
    String lat,
    String lng,
    String company_address,
    String company_img,
  }) async {
    String url = "";

    if (staff)
      url = "staff/add_shipping_company";
    else
      url = "addShippingCompany";

    final response = await http.post(
        Uri.parse(_url + "$url?lang=${RegisterModel.shared.lang}"),
        body: {
          'country_id': country_id,
          //'country_code': country_code,
          'name': company_name,
          'company_name': company_name,
          'shipping_type': shipping_type,
          'shipping_type_id': shipping_type,
          'company_phone': company_phone,
          'phone2': phone2,
          'phone': phone,
          'whatsapp': whatsapp,
          "owner_name": owner_name,
          "lat": lat,
          "lng": lng,
          "company_address": company_address,
          "company_img": "data:image/jpeg;base64," + company_img,
        },
        headers: {
          "Authorization": "Bearer " + RegisterModel.shared.token,
          "Accept": "application/json"
        });
    final body = json.decode(response.body);
    print(body.toString());
    if (body['status'] == "failed" &&
        response.body.toString().contains("Expired")) {
      Fluttertoast.showToast(msg: "login".trim());
      Navigator.push(
          context, CupertinoPageRoute(builder: (_) => AuthenticationPage()));
      return null;
    } else if (body['status'] == "failed") {
      print(body['errors']);
      throw body['errors'];
    } else {
      print(body.toString());
      return true;
    }
  }

  static Future<bool> addShippingCompanyIndividuals({
    BuildContext context,
    bool staff,
    String payment_type,
    String image,
    String lat,
    String lng,
    String governorate,
    String vehicle_type,
    String maximum_load_limit,
    String zone,
    String description,
    String id_card_image_f,
    String id_card_image_b,
    String address,
    // String criminal_record_certificate_image,
  }) async {
    String url = "";

    if (staff)
      url = "staff/add_shipping_rep";
    else
      url = "addShippingRep";
    try {
      final response = await http.post(
          Uri.parse(_url + "$url?lang=${RegisterModel.shared.lang}"),
          body: {
            'governorate': governorate,
            'payment_type': payment_type,
            'description': description,
            "lat": lat,
            "lng": lng,
            "vehicle_type": vehicle_type,
            "maximum_load_limit": maximum_load_limit,
            "zone": zone,
            "image": "data:image/jpeg;base64," + image,
            "id_card_image_f": "data:image/jpeg;base64," + id_card_image_f,
            "id_card_image_b": "data:image/jpeg;base64," + id_card_image_b,
            // "criminal_record_certificate_image":
            //     "data:image/jpeg;base64," + criminal_record_certificate_image,
          },
          headers: {
            "Authorization": "Bearer " + RegisterModel.shared.token
          });
      final body = json.decode(response.body);
      print(body.toString());

      if (body['status'] == "failed" &&
          response.body.toString().contains("Expired")) {
        Fluttertoast.showToast(msg: "login".trim());
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => AuthenticationPage()));
        return null;
      } else if (body['status'] == "failed") {
        print("mahmoud" + body['errors']);
        throw body['errors'];
      } else {
        print(body.toString());
        return true;
      }
    } catch (e) {
      print("mahmoud jamal" + e.toString());
    }
  }
}
