import 'dart:convert';

import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/role_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:http/http.dart' as http;

class StaffApi {
  static final _url = Strings.apiLink;

  static var totalVendors = -1;
  static var totalStaffVendors = -1;
  static var totalunHandeldVendors = -1;

  static Future<List<RoleModel>> fetchRolesApi() async {
    final response = await http.get(
        Uri.parse(
            _url + "staff/get_roles_under?lang=${RegisterModel.shared.lang}"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<RoleModel>.from(
          body['result']['roles'].map((data) => RoleModel.fromMap(data)));
    }
  }

  static Future<Map<String, dynamic>> fetchEmployeesbyAdmin() async {
    final response = await http.get(
        Uri.parse(
            _url + "staff/get_staff_under?lang=${RegisterModel.shared.lang}"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    Map<String, dynamic> body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return body;
    }
  }

  static Future<Map<String, dynamic>> getStaffUnderById(id) async {
    final response = await http.get(
        Uri.parse(_url +
            "staff/get_staff_under_by_user_id?user_id=$id&lang=${RegisterModel.shared.lang}"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    Map<String, dynamic> body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return body;
    }
  }

  static List<VendorModel> staffVendors = [];

  static Future<List<VendorModel>> getVendorsUnderById(id,
      {int page: 1}) async {
    if (page == 1) staffVendors.clear();
    final response = await http.get(
        Uri.parse(_url +
            "staff/vendors_by_user_id?staff_user_id=$id&lang=${RegisterModel.shared.lang}"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    Map<String, dynamic> body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      try {
        if (int.tryParse(body['result']['vendors']['totalPages'].toString()) >
            page) {
          staffVendors.addAll(List<VendorModel>.from(body['result']['vendors']
                  ['vendors']
              .map((data) => VendorModel.fromMap(data))));

          await getVendorsUnderById(id, page: ++page);
          return staffVendors;
        } else {
          staffVendors.addAll(List<VendorModel>.from(body['result']['vendors']
                  ['vendors']
              .map((data) => VendorModel.fromMap(data))));
          return staffVendors;
        }
      } catch (e) {
        totalStaffVendors =
            int.tryParse(body['result']['vendors']['vendorsCount'].toString());
        return List<VendorModel>.from(body['result']['vendors']['vendors']
            .map((data) => VendorModel.fromMap(data)));
      }
    }
  }

  static List<VendorModel> vendors = [];
  static List<VendorModel> unHandledVendors = [];

  static Future<List<VendorModel>> fetchEmployeesbyTeamLeader(
      {int page: 1}) async {
    if (page == 1) vendors.clear();
    final response = await http.get(
        Uri.parse(
            _url + "staff/users?page=$page&lang=${RegisterModel.shared.lang}"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);

    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      try {
        if (int.tryParse(body['result']['users']['totalPages'].toString()) >
            page) {
          vendors.addAll(List<VendorModel>.from(body['result']['users']['users']
              .map((data) => VendorModel.fromMap(data))));

          await fetchEmployeesbyTeamLeader(page: ++page);
          return vendors;
        } else {
          vendors.addAll(List<VendorModel>.from(body['result']['users']['users']
              .map((data) => VendorModel.fromMap(data))));
          return vendors;
        }
      } catch (e) {
        totalVendors =
            int.tryParse(body['result']['users']['vendorsCount'].toString());
        return List<VendorModel>.from(body['result']['users']['users']
            .map((data) => VendorModel.fromMap(data)));
      }
    }
  }

  static Future<List<VendorModel>> fetchUnhandledVendors({int page: 1}) async {
    if (page == 1) unHandledVendors.clear();
    final response = await http.get(
        Uri.parse(_url +
            "staff/unhandled_vendors?page=$page&lang=${RegisterModel.shared.lang}"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      try {
        if (int.tryParse(body['result']['vendors']['totalPages'].toString()) >
            page) {
          unHandledVendors.addAll(List<VendorModel>.from(body['result']
                  ['vendors']['vendors']
              .map((data) => VendorModel.fromMap(data))));

          await fetchUnhandledVendors(page: ++page);
          return unHandledVendors;
        } else {
          unHandledVendors.addAll(List<VendorModel>.from(body['result']
                  ['vendors']['vendors']
              .map((data) => VendorModel.fromMap(data))));
          return unHandledVendors;
        }
      } catch (e) {
        totalunHandeldVendors =
            int.tryParse(body['result']['vendors']['vendorsCount'].toString());
        return List<VendorModel>.from(body['result']['vendors']['vendors']
            .map((data) => VendorModel.fromMap(data)));
      }
    }
    // return List<VendorModel>.from(body['result']['vendors']['vendors']
    //     .map((data) => VendorModel.fromMap(data)));
  }

  static Future<bool> addStaff({
    String country_id,
    String name,
    String phone,
    String whatsapp,
    String phone2,
    String email,
    String lat,
    String lng,
    String pass,
    String image,
    String role_id,
  }) async {
    final response = await http.post(
        Uri.parse(_url + "staff/add_staff?lang=${RegisterModel.shared.lang}"),
        body: {
          'country_id': country_id,
          'email': email + "",
          'phone2': phone2,
          'role_id': role_id,
          'phone': phone,
          'geolocation': lat + "," + lng,
          'whatsapp': whatsapp,
          'name': name,
          'password': pass,
          "image": "data:image/jpeg;base64," + image,
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
}
