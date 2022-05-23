import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/store_type_model.dart';
import 'package:elherafyeen/pages/auth/authentication_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class VendorApi {
  // static final _url = "https://elherafyeen.net/api/";
  static const String _url = "http://elherafyeen.dsm-solution.com/api/";
  static Future<List<StoreTypeModel>> fetchStoreToolsTypes() async {
    final response = await http.get(Uri.parse(
        _url + "getStoreToolsTypes?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<StoreTypeModel>.from(
          body['result'].map((data) => StoreTypeModel.fromMap(data)));
    }
  }

  static Future<List<CategoryModel>> fetchMerchantActivities(
      {bool isMedical: false}) async {
    final response = await http.get(Uri.parse(_url +
        (isMedical
            ? "getMedicalAndEduActivities?lang=${RegisterModel.shared.lang}"
            : "getActivities?for_medical_and_edu=0&lang=${RegisterModel.shared.lang}")));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<CategoryModel>.from(
          body['result'].map((data) => CategoryModel.fromMap(data)));
    }
  }

  static Future<http.Response> fetchVendorServices() async {
    final response = await http.get(
        Uri.parse(_url + "getNormalVendorPageServices"),
        headers: {'Accept': "*/*"}).timeout(Duration(seconds: 100));
    final body = json.decode(response.body);

    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return response;
    }
  }

  static Future<bool> addToVendorGallery(List<String> images) async {
    print("mahmoud Gallery");
    var map = {};
    for (int i = 0; i < images.length; i++) {
      print("mahmoud Gallery");
      var body = {'images[$i]': "data:image/jpeg;base64," + images[i]};
      map.addAll(body);
    }
    final response = await http
        .post(Uri.parse(_url + "addToVendorGallery"), body: map, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
      "Accept": "application/json"
    }).timeout(Duration(seconds: 100));
    final body = json.decode(response.body);
    print("mahmoud Gallery" + body.toString());
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<bool> addToMerchantGallery(List<String> images) async {
    var map = {};
    for (int i = 0; i < images.length; i++) {
      var body = {'images[$i]': "data:image/jpeg;base64," + images[i]};
      map.addAll(body);
    }
    final response = await http
        .post(Uri.parse(_url + "addToMerchantGallery"), body: map, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
      "Accept": "application/json"
    }).timeout(Duration(seconds: 100));
    final body = json.decode(response.body);

    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<bool> addToMerchantGalleryByID(List<String> images, id) async {
    var map = {};
    for (int i = 0; i < images.length; i++) {
      var body = {'images[$i]': "data:image/jpeg;base64," + images[i]};
      map.addAll(body);
    }
    final response = await http.post(
        Uri.parse(_url + "addToMerchantGalleryByMerchantId?merchant_id=$id"),
        body: map,
        headers: {
          "Authorization": "Bearer " + RegisterModel.shared.token,
          "Accept": "application/json"
        }).timeout(Duration(seconds: 100));
    final body = json.decode(response.body);

    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<bool> addToProductById(List<String> images, id) async {
    var map = {};
    for (int i = 0; i < images.length; i++) {
      var body = {'images[$i]': "data:image/jpeg;base64," + images[i]};
      map.addAll(body);
    }
    final response = await http.post(
        Uri.parse(_url + "addImageToProductGallery?product_id=$id"),
        body: map,
        headers: {
          "Authorization": "Bearer " + RegisterModel.shared.token,
          "Accept": "application/json"
        }).timeout(Duration(seconds: 100));
    final body = json.decode(response.body);

    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<bool> addToVendorGalleryById(
      List<String> images, String id) async {
    var map = {"vendor_id": id.toString()};
    for (int i = 0; i < images.length; i++) {
      var body = {'images[$i]': "data:image/jpeg;base64," + images[i]};
      map.addAll(body);
    }

    final response = await http.post(
        Uri.parse(_url + "addToVendorGalleryByVendorId"),
        body: map,
        headers: {
          "Authorization": "Bearer " + RegisterModel.shared.token,
          "Accept": "application/json"
        }).timeout(Duration(seconds: 100));
    final body = json.decode(response.body);

    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<bool> addStaffToVendor(String idOfStaff) async {
    final response = await http
        .post(Uri.parse(_url + "staff/add_staff_to_vendor"), body: {
      "vendor_id": idOfStaff.toString()
    }, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token
    }).timeout(Duration(seconds: 100));
    final body = json.decode(response.body);

    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<bool> payStaff(
      String userId, String subId, String method_id) async {
    final response =
        await http.post(Uri.parse(_url + "staff/create_payment"), body: {
      "user_id": userId.toString(),
      "sub_id": subId.toString(),
      "method_id": method_id.toString()
    }, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token
    }).timeout(Duration(seconds: 100));
    final body = json.decode(response.body);
    print("ELHERAFYEEN <<<< payment " + body.toString());
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<bool> addVendor({
    BuildContext context,
    String categoryId,
    int idOfStaff,
    String classification_id,
    String place_type_id,
    String working_hours,
    String owner_name,
    String whats,
    String lat,
    String lng,
    String name,
    String phone,
    List<String> providedServices,
    List<String> brands,
    List<String> fields,
    List<String> galleryImagesBase64,
    String logo,
    String address,
    String desc,
  }) async {
    try {
      print("mahmouddddd");
      var map = {
        'country_id': '1',
        'category_id': categoryId,
        'classification_id': classification_id,
        'place_type_id': place_type_id,
        'working_hours': working_hours,
        'owner_name': owner_name,
        "lat": lat,
        "lng": lng,
        "logo": "data:image/jpeg;base64," + logo,
        "address": address,
        "name": desc
      };

      if (idOfStaff != -1) {
        var obMap = {
          "desc": name,
          "phone": phone,
          "whatsapp": whats,
        };

        map.addAll(obMap);
      }

      for (int i = 0; i < providedServices.length; i++) {
        var list = {"provided_services[$i]": providedServices[i]};
        map.addAll(list);
      }
      for (int i = 0; i < brands.length; i++) {
        var list = {"vechile_brands[$i]": brands[i]};
        map.addAll(list);
      }
      for (int i = 0; i < fields.length; i++) {
        var list = {"vendor_fields[$i]": fields[i]};
        map.addAll(list);
      }

      String url = "";
      if (idOfStaff != -1)
        url = "staff/add_vendor";
      else
        url = "addNormalVendor";

      final response = await http.post(
          Uri.parse(_url + "$url?lang=${RegisterModel.shared.lang}"),
          body: map,
          headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
      final body = json.decode(response.body);
      if (body['status'] == "failed" &&
          response.body.toString().contains("Expired")) {
        Fluttertoast.showToast(msg: "login".tr());
        Navigator.push(
            context, CupertinoPageRoute(builder: (_) => AuthenticationPage()));
        return null;
      } else if (body['status'] == "failed") {
        throw body['errors'];
      } else {
        try {
          print(body.toString());
          var reslt = true;
          if (galleryImagesBase64 != null && galleryImagesBase64.length != 0) {
            if (idOfStaff == -1)
              reslt = await addToVendorGallery(galleryImagesBase64);
            else
              reslt = await addToVendorGalleryById(
                  galleryImagesBase64, body['result']['vendor_id'].toString());
          }

          if (idOfStaff != -1) {
            print("mahmoud" + body['result']['vendor_id']);
            // reslt =
            // await addStaffToVendor(body['result']['vendor_id'].toString());
          }

          if (reslt) return true;
        } catch (e) {
          throw e.toString();
        }
      }
    } catch (e) {
      print("mahmoud jjjjj " + e.toString());
    }
  }

  static Future<bool> addStore({
    BuildContext context,
    bool staff,
    String owner_name,
    String name,
    String phone,
    String phone2,
    String lat,
    String lng,
    String address,
    List<String> providedServices,
    String logo,
  }) async {
    String url = "";
//country_id, name, phone, whatsapp
    if (staff)
      url = "staff/add_tools_store";
    else
      url = "addToolsStore";

    var map = {
      'owner_name': owner_name,
      "lat": lat,
      "name": name,
      "lng": lng,
      "addr": address,
      "image": "data:image/jpeg;base64," + logo,
    };

    if (staff) {
      map.addAll({"phone": phone, "country_id": "1", "whatsapp": phone2});
    }
    for (int i = 0; i < providedServices.length; i++) {
      var list = {"tools_types[$i]": providedServices[i]};
      map.addAll(list);
    }
    final response = await http.post(
        Uri.parse(_url + "$url?lang=${RegisterModel.shared.lang}"),
        body: map,
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    print(body);
    if (body['status'] == "failed" &&
        response.body.toString().contains("Expired")) {
      Fluttertoast.showToast(msg: "login".tr());
      Navigator.push(
          context, CupertinoPageRoute(builder: (_) => AuthenticationPage()));
      return null;
    } else if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<bool> addMarket({
    BuildContext context,
    bool staff: false,
    String owner_name,
    String name,
    String whatsapp,
    String phone,
    String lat,
    String lng,
    String address,
    String logo,
  }) async {
    String url = "";
    if (staff)
      url = "staff/add_showroom";
    else
      url = "addShowRoom";

    var map = {
      'owner_name': owner_name,
      "lat": lat,
      "lng": lng,
      "addr": address,
      "image": "data:image/jpeg;base64," + logo,
    };

    if (staff) {
      map.addAll({
        "phone": phone,
        "name": name,
        "whatsapp": whatsapp,
        "country_id": "1"
      });
    }
    print(RegisterModel.shared.token);

    http.Response response =
        await http.post(Uri.parse(_url + url), body: map, headers: {
      // "Accept":"application/json",
      "authorization": "Bearer " + RegisterModel.shared.token
    });

    final body = json.decode(response.body);
    print("mahmoud" + response.body.toString());
    print(body);
    if (body['status'] == "failed" &&
        response.body.toString().contains("Expired")) {
      Fluttertoast.showToast(msg: "login".tr());
      Navigator.push(
          context, CupertinoPageRoute(builder: (_) => AuthenticationPage()));
      return null;
    } else if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<bool> addOffer({
    String brand,
    BuildContext context,
    String phone,
    String id,
    String desc,
    String date_from,
    String date_to,
    String discount_percentage,
    String logo,
    Set<String> list,
    String price_before,
    String price_after,
  }) async {
    var map = {
      'desc': desc,
      "date_from": date_from,
      "date_to": date_to,
      "brand_id": brand.toString(),
      "discount_percentage": discount_percentage ?? "1",
      "price_before": price_before,
      "price_after": price_after,
      "image": "data:image/jpeg;base64," + logo,
    };

    final response = await http.post(
        Uri.parse(_url + "add_offer?lang=${RegisterModel.shared.lang}"),
        body: map,
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    print("mahmoud zzz" + response.body.toString());
    print(body);
    if (body['status'] == "failed" &&
        response.body.toString().contains("Expired")) {
      Fluttertoast.showToast(msg: "login".tr());
      Navigator.push(
          context, CupertinoPageRoute(builder: (_) => AuthenticationPage()));
      return null;
    } else if (body['status'] == "failed") {
      print(body['errors'].toString());
      throw body['errors'];
    } else {
      addOfferFirebase(
          phone: RegisterModel.shared.phone ?? "",
          title: desc ?? "",
          id: brand,
          logo: logo);

      return true;
    }
  }

  static var offers = FirebaseDatabase.instance.reference().child("offers");

  static addOfferFirebase(
      {String title, String id, String phone, String logo}) async {
    offers = FirebaseDatabase.instance.reference().child("offers");
    int i = 0;

    offers.push().set(<String, String>{
      "id": id,
      "phone": phone,
      "title": title.toString(),
      "image": logo,
      "time": DateFormat.jm().format(DateTime.now()).toString(),
      "date": DateFormat.yMd().format(DateTime.now()).toString()
    });
  }

  static Future<bool> addMarchant(
      {BuildContext context,
      bool staff,
      name,
      desc,
      governate,
      whatsapp,
      phone,
      ownerName,
      String lat,
      String lng,
      List<String> galleryImagesBase64,
      List<String> providedServices,
      String address,
      String logo}) async {
    String url = "";
    if (staff)
      url = "staff/add_merchant";
    else
      url = "addMerchant";

    var map = {
      'name': name,
      "description": desc,
      "lat": lat,
      "lng": lng,
      "whatsapp": whatsapp,
      "owner_name": ownerName,
      "address": address,
      "activity_id": providedServices[0].toString(),
      "governorate": governate,
      "image": "data:image/jpeg;base64," + logo,
    };
    providedServices.forEach((element) {
      var mmm = {"activities[]": element};
      map.addAll(mmm);
    });

    if (staff) {
      map.addAll({"phone": phone, "country_id": "1"});
    }
    print(RegisterModel.shared.token);

    http.Response response =
        await http.post(Uri.parse(_url + url), body: map, headers: {
      "Accept": "application/json",
      "authorization": "Bearer " + RegisterModel.shared.token
    });
    print("mahmoud" + response.statusCode.toString());

    final body = json.decode(response.body);
    print("mahmoud" + response.body.toString());
    print(body);
    if (body['status'] == "failed" &&
        response.body.toString().contains("Expired")) {
      Fluttertoast.showToast(msg: "login".tr());
      Navigator.push(
          context, CupertinoPageRoute(builder: (_) => AuthenticationPage()));
      return true;
    } else if (body['status'] == "failed") {
      print(body['errors'].toString());
      throw body['errors'];
    } else {
      try {
        print(body.toString());
        var reslt = true;
        if (galleryImagesBase64 != null && galleryImagesBase64.length != 0) {
          if (!staff)
            reslt = await addToMerchantGallery(galleryImagesBase64);
          else
            reslt = await addToMerchantGalleryByID(
                galleryImagesBase64,
                (body['result']['merchant_id'] ?? body['result']['user_id'])
                    .toString());
        }

        if (reslt) return true;
      } catch (e) {
        throw e.toString();
      }
    }
  }

  static Future<bool> addProduct(
      {BuildContext context,
      name,
      notes,
      before_price,
      String after_price,
      String stock,
      String status,
      List<String> galleryImagesBase64,
      String brand_id: "",
      String model_id: "",
      String position: "",
      String direction: "",
      String year: "",
      String logo}) async {
    var map = {
      'name': name,
      'country_id': "1",
      "purchasing_price": before_price,
      "sale_price": after_price,
      "status": status,
      "product_status": status,
      "stock": stock,
      "notes": notes,
      // "model_id": brand_id,
      // "brand_id": brand_id,
      "image": "data:image/jpeg;base64," + logo,
      "product_image": "data:image/jpeg;base64," + logo,
      "logo": "data:image/jpeg;base64," + logo,
    };

    if (model_id.isNotEmpty) {
      map.addAll({"model_id": model_id});
    }
    if (brand_id.isNotEmpty) {
      map.addAll({"brand_id": brand_id});
    }
    if (position.isNotEmpty) {
      map.addAll({"product_position": position});
    }
    if (direction.isNotEmpty) {
      map.addAll({"product_direction": direction});
    }
    if (year.isNotEmpty) {
      map.addAll({"model_year": year});
    }

    print("logo Elherafyeen" + logo.toString());
    print(RegisterModel.shared.token);

    http.Response response =
        await http.post(Uri.parse(_url + "addProduct"), body: map, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
      "Accept": "application/json"
    });
    print("mahmoud" + response.statusCode.toString());

    final body = json.decode(response.body);
    print("mahmoud" + response.body.toString());
    print(body);
    if (body['status'] == "failed" &&
        response.body.toString().contains("Expired")) {
      Fluttertoast.showToast(msg: "login".tr());
      Navigator.push(
          context, CupertinoPageRoute(builder: (_) => AuthenticationPage()));
      return true;
    } else if (body['status'] == "failed") {
      print(body['errors'].toString());
      throw body['errors'];
    } else {
      try {
        print(body.toString());
        var reslt = true;
        if (galleryImagesBase64 != null && galleryImagesBase64.isNotEmpty) {
          reslt = await addToProductById(galleryImagesBase64,
              body['result']['product_id'] ?? body['result']['id'].toString());
        }
        if (reslt) return true;
      } catch (e) {
        throw e.toString();
      }
    }
  }

  static Future<bool> updateProduct(
      {BuildContext context,
      name,
      notes,
      product_id,
      before_price,
      String after_price,
      String stock,
      String status,
      List<String> galleryImagesBase64,
      String brand_id,
      String logo}) async {
    var map = {
      'product_id': product_id,
      'name': name,
      'country_id': "1",
      "purchasing_price": before_price,
      "sale_price": after_price,
      "status": status,
      "stock": stock,
      "notes": notes,
      // "model_id": brand_id,
      // "brand_id": brand_id,
      "image": "data:image/jpeg;base64," + logo,
      "product_image": "data:image/jpeg;base64," + logo,
      "logo": "data:image/jpeg;base64," + logo,
    };
    print("logo Elherafyeen" + logo.toString());
    print(RegisterModel.shared.token);

    http.Response response =
        await http.post(Uri.parse(_url + "updateProduct"), body: map, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
      "Accept": "application/json"
    });
    print("mahmoud" + response.statusCode.toString());

    final body = json.decode(response.body);
    print("mahmoud" + response.body.toString());
    print(body);
    if (body['status'] == "failed" &&
        response.body.toString().contains("Expired")) {
      Fluttertoast.showToast(msg: "login".tr());
      Navigator.push(
          context, CupertinoPageRoute(builder: (_) => AuthenticationPage()));
      return true;
    } else if (body['status'] == "failed") {
      print(body['errors'].toString());
      throw body['errors'];
    } else {
      try {
        print(body.toString());
        var reslt = true;
        if (galleryImagesBase64 != null && galleryImagesBase64.isNotEmpty) {
          reslt = await addToProductById(galleryImagesBase64,
              body['result']['product_id'] ?? body['result']['id'].toString());
        }
        if (reslt) return true;
      } catch (e) {
        throw e.toString();
      }
    }
  }
}
