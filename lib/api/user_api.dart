import 'dart:convert';

import 'package:elherafyeen/api/vendor_api.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/pages/auth/language_page.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class UserApi {
  static final _url = Strings.apiLink;

  static Future<VendorModel> getUserData({BuildContext context}) async {
    print("Bearer " + RegisterModel.shared.token ?? "");
    final response = await http.get(Uri.parse(_url + "getUserData"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      if (body['errors'] != null && body['errors']['token'] != null) {
        Fluttertoast.showToast(
            msg:
                "عفوا لقد انتهي صلاحية الدخول من فضلك قم بتسجيل الدخول مرة اخري");
        if (context != null)
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => LanguagePage()),
              (route) => false);
      }
      throw body['errors'];
    } else {
      print("mahmoud" + body.toString());
      await RegisterModel.shared.fromJson(body['result']);
      await RegisterModel.shared.saveUserDataInfo();
      await RegisterModel.shared.getUserData();
      return VendorModel.fromMap(body['result']['user']);
    }
  }

  static Future<VendorModel> getUserByPhone({String phone}) async {
    final response = await http
        .get(Uri.parse(_url + "getUserByPhone?phone=$phone"), headers: {
      "Authorization": "Bearer " + (RegisterModel.shared.token ?? "")
    });
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return VendorModel.fromMap(body['result']['user']);
    }
  }

  static Future<VendorModel> getEvent({String id}) async {
    final response = await http
        .get(Uri.parse(_url + "get_event_by_id?event_id=$id"), headers: {
      "Authorization": "Bearer " + (RegisterModel.shared.token ?? "")
    });
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return VendorModel.fromMap(body['result']['event']);
    }
  }

  static Future<String> getActivePhone() async {
    final response = await http
        .get(Uri.parse(_url + "get_active_provider_cash"), headers: {
      "Authorization": "Bearer " + (RegisterModel.shared.token ?? "")
    });
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return body['result']['number'].toString();
    }
  }

  static Future<bool> addUserToEvent({eventId, receiptNumber}) async {
    final response = await http.post(Uri.parse(_url + "add_user_to_event"),
        body: {
          "event_id": eventId,
          "receipt_number": receiptNumber
        },
        headers: {
          "Authorization": "Bearer " + (RegisterModel.shared.token ?? "")
        });
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<bool> getSubscribedUser({eventId, userId}) async {
    final response = await http.get(
        Uri.parse(
            _url + "get_subscribed_user?event_id=$eventId&user_id=$userId"),
        headers: {
          "Authorization": "Bearer " + (RegisterModel.shared.token ?? "")
        });
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<List<VendorModel>> get_user_events({eventId, userId}) async {
    final response = await http
        .get(Uri.parse(_url + "get_user_events?user_id=$userId"), headers: {
      "Authorization": "Bearer " + (RegisterModel.shared.token ?? "")
    });
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      var rooms = List<VendorModel>.from(
          body['result']['events'].map((data) => VendorModel.fromMap(data)));
      return rooms;
    }
  }

  static Future<bool> updateUserImage({String image}) async {
    final response =
        await http.post(Uri.parse(_url + "updateUserImage"), body: {
      'image': "data:image/jpeg;base64," + image
    }, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
    });
    final body = json.decode(response.body);
    print(body.toString());
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      RegisterModel.shared.saveUserImage(image);
      print(body.toString());
      return true;
    }
  }

  static Future<bool> updateVendorImage({String image}) async {
    print("imagee updates");

    final response =
        await http.post(Uri.parse(_url + "updateVendorImage"), body: {
      'image': "data:image/jpeg;base64," + image
    }, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
    });
    // final body = json.decode(response.body);
    // print(body.toString());
    if (response.statusCode == 200) {
      RegisterModel.shared.saveUserImage(image);
    } else {
      throw response.body.toString();
    }
  }

  static Future<bool> updateUserData({
    List<String> galleryImages,
    String placeId,
    String carType,
    String classificationId,
    String maxShipping,
    String workingHour,
    String name,
    String phone,
    String email,
    String type_id,
    String password,
    String whatsapp,
    String address,
    String phone2,
    String desc,
    String image,
    String fb,
    String twitter,
    String yt,
    String linkedIn,
    String telegram,
    String insta,
    String video1,
    String video2,
    String video3,
    String video4,
    List<String> providedServices,
    List<String> fields,
    List<String> brands,
  }) async {
    var map = {};

    if (name != "" && name != null) {
      map.addAll({"name": name});
    }
    if (phone != "" && phone != null) {
      map.addAll({"phone": phone});
    }
    if (whatsapp != "" && whatsapp != null) {
      map.addAll({"whatsapp": whatsapp});
    }

    if (maxShipping != "" && maxShipping != null) {
      map.addAll({"maximum_load_limit": maxShipping});
    }
    if (address != "" && address != null) {
      map.addAll({"addr": address});
    }
    if (address != "" && address != null) {
      map.addAll({"address": address});
    }
    if (desc != "" && desc != null) {
      map.addAll({"notes": desc});
    }
    if (phone2 != "" && phone2 != null) {
      map.addAll({"phone2": phone2});
    }
    if (email != "" && email != null) {
      map.addAll({"email": email});
    }
    if (desc != "" && desc != null) {
      map.addAll({"description": desc});
    }
    if (fb != "" && fb != null) {
      map.addAll({"fb": fb});
    }
    if (insta != "" && insta != null) {
      map.addAll({"insta": insta});
    }
    if (twitter != "" && twitter != null) {
      map.addAll({"twitter": twitter});
    }
    if (linkedIn != "" && linkedIn != null) {
      map.addAll({"linkedin": linkedIn});
    }
    if (telegram != "" && telegram != null) {
      map.addAll({"telegram": telegram});
    }
    if (yt != "" && yt != null) {
      map.addAll({"yt": yt});
    }

    if (video1 != "" && video1 != null) {
      map.addAll({"videoLink1": video1});
    }

    if (video2 != "" && video2 != null) {
      map.addAll({"videoLink2": video2});
    }

    if (video3 != "" && video3 != null) {
      map.addAll({"videoLink3": video3});
    }

    if (video4 != "" && video4 != null) {
      map.addAll({"videoLink4": video4});
    }

    if (type_id == "2") {
      for (int i = 0; i < providedServices.length; i++) {
        var list = {"service_ids[$i]": providedServices[i]};
        map.addAll(list);
      }
      for (int i = 0; i < brands.length; i++) {
        var list = {"brand_ids[$i]": brands[i]};
        map.addAll(list);
      }
      for (int i = 0; i < fields.length; i++) {
        var list = {"field_ids[$i]": fields[i]};
        map.addAll(list);
      }

      if (placeId != null && placeId != "0") {
        var list = {"place_type_id": placeId};
        map.addAll(list);
      }
      if (classificationId != null && classificationId != "0") {
        var list = {"class_id": classificationId};
        map.addAll(list);
      }
      if (workingHour != null && workingHour != "0") {
        var list = {"working_hours": workingHour};
        map.addAll(list);
      }
    }

    String url = "";

    if (type_id == "2") {
      print("mahmoudhere fire");
      url = _url + "updateVendor";
    } else
      url = _url + "updateUserData";
    final response = await http.post(Uri.parse(url), body: map, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
    });
    final body = json.decode(response.body);

    print("mahmoud" + body.toString());
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      await getUserData();
      if (image != "" && type_id == "2") {
        print("imagee updates");
        await updateVendorImage(image: image);
      }
      if (type_id == "2") {
        if (galleryImages != null && galleryImages.length != 0) {
          await VendorApi.addToVendorGallery(galleryImages);
        }
      } else if (type_id == "9") {
        if (galleryImages != null && galleryImages.length != 0) {
          await VendorApi.addToMerchantGallery(galleryImages);
        }
      }
      return true;
    }
  }

  static Future<bool> updateCompany({
    List<String> galleryImages,
    String maxShipping,
    String workingHour,
    String name,
    String phone,
    String email,
    String type_id,
    String password,
    String whatsapp,
    String address,
    String phone2,
    String desc,
    String image,
    String fb,
    String twitter,
    String yt,
    String linkedIn,
    String telegram,
    String insta,
    String video1,
    String video2,
    String video3,
    String video4,
  }) async {
    var map = {};

    if (name != "" && name != null) {
      map.addAll({"company_name": name});
    }
    if (image != "" && image != null) {
      map.addAll({"company_img": "data:image/jpeg;base64," + image});
    }

    if (whatsapp != "" && whatsapp != null) {
      map.addAll({"whatsapp": whatsapp});
    }

    if (address != "" && address != null) {
      map.addAll({"company_address": address});
    }

    if (desc != "" && desc != null) {
      map.addAll({"notes": desc});
    }
    if (phone2 != "" && phone2 != null) {
      map.addAll({"phone2": phone2});
    }
    if (email != "" && email != null) {
      map.addAll({"email": email});
    }
    if (desc != "" && desc != null) {
      map.addAll({"description": desc});
    }
    if (fb != "" && fb != null) {
      map.addAll({"fb": fb});
    }
    if (insta != "" && insta != null) {
      map.addAll({"insta": insta});
    }
    if (twitter != "" && twitter != null) {
      map.addAll({"twitter": twitter});
    }
    if (linkedIn != "" && linkedIn != null) {
      map.addAll({"linkedin": linkedIn});
    }
    if (telegram != "" && telegram != null) {
      map.addAll({"telegram": telegram});
    }
    if (yt != "" && yt != null) {
      map.addAll({"yt": yt});
    }

    if (video1 != "" && video1 != null) {
      map.addAll({"videoLink1": video1});
    }

    if (video2 != "" && video2 != null) {
      map.addAll({"videoLink2": video2});
    }

    if (video3 != "" && video3 != null) {
      map.addAll({"videoLink3": video3});
    }

    if (video4 != "" && video4 != null) {
      map.addAll({"videoLink4": video4});
    }

    String url = "";

    url = _url + "updateShippingCompany";
    final response = await http.post(Uri.parse(url), body: map, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
    });
    final body = json.decode(response.body);

    print("mahmoud" + body.toString());
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      await getUserData();

      return true;
    }
  }

  static Future<bool> updateCaptines({
    List<String> galleryImages,
    String maxShipping,
    String workingHour,
    String name,
    String phone,
    String email,
    String type_id,
    String carType,
    String password,
    String whatsapp,
    String address,
    String phone2,
    String desc,
    String image,
    String fb,
    String twitter,
    String yt,
    String linkedIn,
    String telegram,
    String insta,
    String video1,
    String video2,
    String video3,
    String video4,
  }) async {
    var map = {};

    if (name != "" && name != null) {
      map.addAll({"name": name});
    }
    if (image != "" && image != null) {
      map.addAll({"image": "data:image/jpeg;base64," + image});
    }

    if (whatsapp != "" && whatsapp != null) {
      map.addAll({"whatsapp": whatsapp});
    }
    if (carType != "" && carType != null) {
      map.addAll({"vehicle_type": carType});
    }

    if (address != "" && address != null) {
      map.addAll({"address": address});
    }

    if (desc != "" && desc != null) {
      map.addAll({"notes": desc});
    }
    if (maxShipping != "" && maxShipping != null) {
      map.addAll({"maximum_load_limit": maxShipping});
    }
    if (phone2 != "" && phone2 != null) {
      map.addAll({"phone2": phone2});
    }
    if (email != "" && email != null) {
      map.addAll({"email": email});
    }
    if (desc != "" && desc != null) {
      map.addAll({"description": desc});
    }
    if (fb != "" && fb != null) {
      map.addAll({"fb": fb});
    }
    if (insta != "" && insta != null) {
      map.addAll({"insta": insta});
    }
    if (twitter != "" && twitter != null) {
      map.addAll({"twitter": twitter});
    }
    if (linkedIn != "" && linkedIn != null) {
      map.addAll({"linkedin": linkedIn});
    }
    if (telegram != "" && telegram != null) {
      map.addAll({"telegram": telegram});
    }
    if (yt != "" && yt != null) {
      map.addAll({"yt": yt});
    }

    if (video1 != "" && video1 != null) {
      map.addAll({"videoLink1": video1});
    }

    if (video2 != "" && video2 != null) {
      map.addAll({"videoLink2": video2});
    }

    if (video3 != "" && video3 != null) {
      map.addAll({"videoLink3": video3});
    }

    if (video4 != "" && video4 != null) {
      map.addAll({"videoLink4": video4});
    }

    String url = "";

    url = _url + "updateShippingRep";
    final response = await http.post(Uri.parse(url), body: map, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
    });
    final body = json.decode(response.body);

    print("mahmoud" + body.toString());
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      await getUserData();

      return true;
    }
  }

  static Future<bool> updateMerchant({
    String imageString,
    List<String> galleryImages,
    String name,
    String phone,
    String email,
    String type_id,
    String password,
    String whatsapp,
    String address,
    String phone2,
    String desc,
    String image,
    String fb,
    String twitter,
    String yt,
    String linkedIn,
    String telegram,
    String insta,
    String video1,
    String video2,
    String video3,
    String video4,
  }) async {
    var map = {};

    if (name != "" && name != null) {
      map.addAll({"name": name});
    }
    if (image != "" && image != null) {
      map.addAll({"image": "data:image/jpeg;base64," + image});
    }
    if (phone != "" && phone != null) {
      map.addAll({"phone": phone});
    }
    if (whatsapp != "" && whatsapp != null) {
      map.addAll({"whatsapp": whatsapp});
    }

    if (address != "" && address != null) {
      map.addAll({"address": address});
    }
    if (desc != "" && desc != null) {
      map.addAll({"notes": desc});
    }
    if (phone2 != "" && phone2 != null) {
      map.addAll({"phone2": phone2});
    }
    if (email != "" && email != null) {
      map.addAll({"email": email});
    }
    if (desc != "" && desc != null) {
      map.addAll({"description": desc});
    }
    if (fb != "" && fb != null) {
      map.addAll({"fb": fb});
    }
    if (insta != "" && insta != null) {
      map.addAll({"insta": insta});
    }
    if (twitter != "" && twitter != null) {
      map.addAll({"twitter": twitter});
    }
    if (linkedIn != "" && linkedIn != null) {
      map.addAll({"linkedin": linkedIn});
    }
    if (telegram != "" && telegram != null) {
      map.addAll({"telegram": telegram});
    }
    if (yt != "" && yt != null) {
      map.addAll({"yt": yt});
    }

    if (video1 != "" && video1 != null) {
      map.addAll({"videoLink1": video1});
    }

    if (video2 != "" && video2 != null) {
      map.addAll({"videoLink2": video2});
    }

    if (video3 != "" && video3 != null) {
      map.addAll({"videoLink3": video3});
    }

    if (video4 != "" && video4 != null) {
      map.addAll({"videoLink4": video4});
    }

    String url = "";

    url = _url + "updateMerchant";

    final response = await http.post(Uri.parse(url), body: map, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
    });
    final body = json.decode(response.body);

    print("mahmoud" + body.toString());
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      if (type_id == "9") {
        if (galleryImages != null && galleryImages.length != 0) {
          await VendorApi.addToMerchantGallery(galleryImages);
        }
        await getUserData();
        return true;
      }
    }
  }
}
