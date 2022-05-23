import 'dart:convert';

import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/utilities/strings.dart';
import 'package:http/http.dart' as http;

class EmployeeApi {
  static final _url = Strings.apiLink;

  static Future<List<CategoryModel>> getApplicantJobFields() async {
    final response = await http.get(Uri.parse(
        _url + "getApplicantJobFields?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<CategoryModel>.from(body['result']['job_fields']
          .map((data) => CategoryModel.fromMap(data)));
    }
  }

  static List<String> placeValue = [];

  static Future<List<String>> getApplicantJobPlace() async {
    final response = await http.get(Uri.parse(
        _url + "getApplicantJobPlace?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      List<String> list = [];
      placeValue.add("inside_governorate");
      placeValue.add("inside_and_outside_governorate");
      list.add(body['result']['job_place']['inside_governorate'].toString());
      list.add(body['result']['job_place']['inside_and_outside_governorate']
          .toString());
      return list;
    }
  }

  /// Used to log the user in, if successful, user data is cached.
  static Future<bool> addEmployee({
    bool isSpecial,
    String disability,
    String age,
    String gender,
    String country_id,
    String country_code,
    String lat,
    String lng,
    String job_field,
    String service_desc,
    String experience_years,
    String city_name,
    String job_place,
    String image,
  }) async {
    var sub_url = "";
    if (isSpecial)
      sub_url = "addDisableApplicant";
    else
      sub_url = "addApplicant";

    var map = {
      'birthday': age,
      'age': age,
      'gender': gender,
      'job_field': job_field,
      'service_desc': service_desc,
      'experience_years': experience_years,
      'city_name': city_name,
      'job_place': job_place,
      'image': "data:image/jpeg;base64," + image,
      'country_id': country_id,
      // 'country_code': country_code,
      "lat": lat,
      "lng": lng,
    };

    if (isSpecial) map.addAll({"disability_type": disability});

    final response = await http.post(Uri.parse(_url + sub_url),
        body: map,
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    Map<String, dynamic> body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body.toString());
      throw body['errors'];
    } else {
      return true;
    }
  }
}
