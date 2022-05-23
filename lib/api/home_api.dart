import 'dart:convert';

import 'package:elherafyeen/models/brand_model.dart';
import 'package:elherafyeen/models/cart.dart';
import 'package:elherafyeen/models/category_model.dart';
import 'package:elherafyeen/models/phone_model.dart';
import 'package:elherafyeen/models/register_model.dart';
import 'package:elherafyeen/models/search_model.dart';
import 'package:elherafyeen/models/user_active_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:elherafyeen/utilities/Strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HomeApi {
  static String _url = Strings.apiLink;
  static var headers = {
    "Authorization": "Bearer " + RegisterModel.shared.token,
    "Accept": "application/json"
  };
  static double latitude;
  static double longitude;
  static var currentLocation;
  static var userActive = FirebaseDatabase.instance.reference().child("users");
  static var offers = FirebaseDatabase.instance.reference().child("offers");

  static Future<Map<String, double>> getCurrentLocation() async {
    Map<String, double> result = {"latitude": 0.0, "longitude": 0.0};
    try {
      currentLocation = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      result = {
        "latitude": currentLocation.latitude,
        "longitude": currentLocation.longitude
      };
      print(currentLocation.latitude);
      print(currentLocation.longitude);
      latitude = currentLocation.latitude;
      longitude = currentLocation.longitude;
    } catch (e) {
      currentLocation = null;
      print("mahmoud" + e.toString());
    }

    return result;
  }

  static pushUserActive() async {
    await getCurrentLocation();
    userActive = FirebaseDatabase.instance.reference().child("users");
    int i = 0;
    await userActive
        .orderByChild("id")
        .equalTo(RegisterModel.shared.id.toString())
        .once()
        .then((DataSnapshot snapshot) {
      try {
        final decoder = const UserActiveDecoder();
        if (decoder != null)
          decoder.convert(snapshot.value).toList().forEach((item) {
            i = 1;
            userActive.child(item.key.toString()).update({
              "id": RegisterModel.shared.id.toString(),
              "lat": latitude.toString(),
              "lng": longitude.toString()
            });
          });
      } catch (e) {
        userActive.push().set(<String, String>{
          "id": RegisterModel.shared.id.toString(),
          "lat": latitude.toString(),
          "lng": longitude.toString()
        });
      }
    }).then((value) {
      if (i == 0) {
        userActive.push().set(<String, String>{
          "id": RegisterModel.shared.id.toString(),
          "lat": latitude.toString(),
          "lng": longitude.toString()
        });
      }
    });
  }

  static addOffer(String title, String id, String phone) async {
    await getCurrentLocation();
    offers = FirebaseDatabase.instance.reference().child("offers");
    int i = 0;

    offers.push().set(<String, String>{
      "id": id,
      "phone": phone,
      "title": title.toString(),
    });
  }

  static Future<List<CategoryModel>> fetchCategories() async {
    if (RegisterModel.shared.type_id != null &&
        RegisterModel.shared.type_id == "5") {
      pushUserActive();
    }
    print("mahmoud lang " + RegisterModel.shared.lang.toString());
    final response = await http.get(Uri.parse(
        _url + "getMainCategoriesSubset?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<CategoryModel>.from(
          body['result'].map((data) => CategoryModel.fromMap(data)));
    }
  }

  static Future<List<CategoryModel>> getPaymentMethods() async {
    final response = await http.get(Uri.parse(
        _url + "get_subscription_methods?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<CategoryModel>.from(
          body['result'].map((data) => CategoryModel.fromMap(data)));
    }
  }

  static Future<String> getImageQRCode() async {
    final response = await http.get(
        Uri.parse(
            _url + "staff/get_qr_image?lang=${RegisterModel.shared.lang}"),
        headers: headers);
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return body['result']['qr_image'].toString();
    }
  }

  static Future<List<CategoryModel>> fetchVehicleCategories() async {
    if (RegisterModel.shared.type_id != null &&
        RegisterModel.shared.type_id == "5") {
      pushUserActive();
    }
    final response = await http.get(Uri.parse(
        _url + "getVehiclesCategories?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<CategoryModel>.from(
          body['result'].map((data) => CategoryModel.fromMap(data)));
    }
  }

  static Future<List<CategoryModel>> fetchCategoriesAll() async {
    if (RegisterModel.shared.type_id != null &&
        RegisterModel.shared.type_id == "5") {
      pushUserActive();
    }
    print("mahmoud lang " + RegisterModel.shared.lang.toString());
    final response = await http.get(Uri.parse(
        _url + "getMainCategories?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<CategoryModel>.from(
          body['result'].map((data) => CategoryModel.fromMap(data)));
    }
  }

  static Future<List<SearchModel>> fetchVendorToSearch(
      {String categoryId}) async {
    final response = await http.get(Uri.parse(_url +
        "getVendorFieldsToSearchWith?category_id=$categoryId&lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<SearchModel>.from(
          body['result'].map((data) => SearchModel.fromMap(data)));
    }
  }

  static Future<List<CategoryModel>> fetchServices({String categoryId}) async {
    final response = await http.get(Uri.parse(
        _url + "get_provided_services?lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<CategoryModel>.from(body['result']['services']
          .map((data) => CategoryModel.fromMap(data)));
    }
  }

  // static Future<VendorModel> fetchVendor({String vendor_id}) async {
  //   print("mahmoud$vendor_id");
  //   final response = await http.get(Uri.parse(_url +
  //       "getNormalVendorById?vendor_id=$vendor_id&lang=${RegisterModel.shared.lang}"));
  //   final body = json.decode(response.body);
  //   if (body['status'] == "failed") {
  //     print("mahmoud" + body['errors']);
  //     throw body['errors'];
  //   } else {
  //     print(body.toString());
  //     return VendorModel.fromMap(body['result']['vendor']);
  //   }
  // }


  static Future<VendorModel> fetchVendor({String vendor_id}) async {
    print("mahmoud$vendor_id");
    final response = await http.get(Uri.parse(_url +
        "getNormalVendorById?vendor_id=$vendor_id&lang=${RegisterModel.shared.lang}"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      print(body.toString());
      return VendorModel.fromMap(body['result']['vendor']);
    }
  }





  static Future<VendorModel> fetchProductDetails({String product_id}) async {
    final response = await http.get(
        Uri.parse(_url +
            "getProduct?product_id=$product_id"
                "&lang=${RegisterModel.shared.lang}"),
        headers: headers);
    final body = json.decode(response.body);
    print("MAHMOUD   " + body.toString());
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      print(body.toString());
      return VendorModel.fromMap(body['result']['product']);
    }
  }

  static Future<PhoneModel> get_user_numbers_list({String product_id}) async {
    final response = await http.get(Uri.parse(_url + "get_user_numbers_list"),
        headers: headers);
    final body = json.decode(response.body);
    print("MAHMOUD   " + body.toString());
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      print(body.toString());
      return body['result']['list'] != null &&
              body['result']['list'].toString() != "[]"
          ? PhoneModel.fromMap(body['result']['list'])
          : PhoneModel();
    }
  }

  static Future<PhoneModel> get_user_numbers_list_by_id({String userId}) async {
    final response = await http.get(
        Uri.parse(_url + "get_user_numbers_list_by_user_id?user_id=$userId"),
        headers: headers);
    final body = json.decode(response.body);
    print("MAHMOUD   " + body.toString());
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      print(body.toString());
      return body['result']['list'] != null &&
              body['result']['list'].toString() != "[]"
          ? PhoneModel.fromMap(body['result']['list'])
          : PhoneModel();
    }
  }

  static Future<List<VendorModel>> fetchMyServices(
      {String lat, String lng, String id}) async {
    print(lat + " " + lng);
    final response = await http.get(
        Uri.parse(_url +
            "getVehicleOwnerServiceVendors?lat=$lat&lng=$lng&service_id=$id&lang=${RegisterModel.shared.lang}"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<VendorModel>.from(body['result']['vendors']['vendors']
          .map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> getRandomAd({String lat, String lng}) async {
    print(lat + " " + lng);
    final response = await http.get(
        Uri.parse(_url +
            "ads/random?lat=$lat&lng=$lng&lang=${RegisterModel.shared.lang}"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<VendorModel>.from(
          body['result']['ad'].map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<bool> getEventsViewable() async {
    final response = await http.get(Uri.parse(_url + "is_events_viewable"),
        headers: {"Authorization": "Bearer " + RegisterModel.shared.token});
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      if (body['result']['show_events'] is String) {
        if (body['result']['show_events'].toString() == "true")
          return true;
        else
          return false;
      }
      return body['result']['show_events'];
    }
  }

  static Future<List<VendorModel>> fetchVendorsResult({
    String category_id,
    String field_id,
    String brand_id,
    String lat,
    String lng,
  }) async {
    final response = await http.get(Uri.parse(_url +
        "getVendorsForUser?lang=${RegisterModel.shared.lang}&"
            "category_id=$category_id&field_id=$field_id&brand_id=$brand_id&current_lat=$lat&current_lng=$lng"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(
          body['result']['vendors'].map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> fetchAllOffers() async {
    final response = await http.get(
        Uri.parse(
            _url + "get_all_offers?brand_id&lang=${RegisterModel.shared.lang}"),
        headers: headers);
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(body['result']['offers_list']['offers']
          .map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> getNearbyShippingList(
      {String lat, String lng}) async {
    final response = await http.get(
        Uri.parse(_url +
            "getNearByShippingList?lat=$lat"
                "&lng=$lng&lang=${RegisterModel.shared.lang}&page=1&items_per_page=7&is_company=0"),
        headers: headers);
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(body['result']['list']['list']
          .map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> fetchAllProducts() async {
    final response = await http.get(
        Uri.parse(_url + "getAllProducts?lang=${RegisterModel.shared.lang}"),
        headers: headers);
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body.toString());
      throw body['errors'];
    } else {
      return List<VendorModel>.from(body['result']['products_list']['products']
          .map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> fetchOffersByUser({
    String user_id,
  }) async {
    final response = await http.get(Uri.parse(_url +
        "get_offers_list_by_user_id?lang=${RegisterModel.shared.lang}&"
            "user_id=$user_id"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(body['result']['offers_list']
          .map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> fetchProductsForUser({
    String user_id,
  }) async {
    final response = await http.get(
        Uri.parse(_url +
            "getProductsListByUserId?user_id="
                "$user_id"),
        headers: {
          "Authorization": "Bearer " + RegisterModel.shared.token,
          "Accept": "application/json"
        });
    final body = json.decode(response.body);
    print(RegisterModel.shared.token.toString());

    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(body['result']['products']['products']
          .map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> fetchEvents() async {
    final response =
        await http.get(Uri.parse(_url + "get_available_events"), headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token,
      "Accept": "application/json"
    });
    final body = json.decode(response.body);
    print(RegisterModel.shared.token.toString());

    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(
          body['result'].map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<bool> addReview({
    String rev_user_id,
    String review,
    String stars,
  }) async {
    print(rev_user_id + "&" + review + "&" + stars);
    final response = await http.post(Uri.parse(_url + "add_review"), body: {
      "rev_user_id": rev_user_id,
      "review": "bla bla ",
      "stars": stars
    }, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token
    });
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<bool> addOrder({
    String ShippigId,
  }) async {
    // print("MY ORDER IS SSSS" + Cart().toJsonCart(ShippigId.toString()).toString());
    final response = await http.post(Uri.parse(_url + "addOrder"), body: {
      "shipping_user_id": ShippigId.toString(),
      "product_list": Cart.cartProducts
          .map((e) => Cart().toJsonProducts(e))
          .toList()
          .toString(),
    }, headers: {
      "Authorization": "Bearer " + RegisterModel.shared.token
    });
    final body = json.decode(response.body);
    print("MY ORDER IS SSSS " + body.toString());
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return true;
    }
  }

  static Future<List<VendorModel>> getToolsStoreById({
    String category_id,
    String lat,
    String lng,
  }) async {
    final response = await http.get(Uri.parse(_url +
        "getStores?lang=${RegisterModel.shared.lang}&"
            "tools_type_id=$category_id&current_lat=$lat&current_lng=$lng"));
    final body = json.decode(response.body);
    print("mahmoud" + body.toString());
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(body['result']['stores']['stores']
          .map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> getCompaniesByShippingType({
    String category_id,
    String lat,
    String lng,
  }) async {
    final response = await http.get(Uri.parse(_url +
        "getShippingCompaniesList?current_lat=$lat&current_lng=$lng&page=1&shipping_type_id=$category_id&lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    print("mahmoud" + body.toString());
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(body['result']['shippingCompanies']
              ['companies']
          .map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> getShippingRepsList({
    String category_id,
    String lat,
    String lng,
  }) async {
    final response = await http.get(Uri.parse(_url +
        "getShippingRepsList?current_lat=$lat&current_lng=$lng&page=1"
            "&shipping_type_id=$category_id&lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    print("mahmoud" + body.toString());
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(body['result']['shippingReps']['companies']
          .map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> fetchOutsideMaintenance({
    String lat,
    String lng,
  }) async {
    final response = await http.get(Uri.parse(_url +
        "getMobileMaintenance?lang=${RegisterModel.shared.lang}&"
            "current_lat=$lat&current_lng=$lng"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(
          body['result']['vendors'].map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> fetchOnlineDealers({
    String id,
    String lat,
    String lng,
  }) async {
    print("mahmoud $lat ++ $lng");
    final response = await http.get(Uri.parse(_url +
        "getMerchantsList?current_lat=$lat&current_lng=$lng"
            "&lang=${RegisterModel.shared.lang}&activity_id=$id"));
    final body = json.decode(response.body);
    print("mahmoud" + body.toString());
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(body['result']['merchants']['merchants']
          .map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> fetchMedicalDealers({
    String lat,
    String lng,
  }) async {
    print("mahmoud $lat ++ $lng");
    final response = await http.get(Uri.parse(_url +
        "getMerchantsList?current_lat=$lat&current_lng=$lng"
            "&lang=${RegisterModel.shared.lang}&is_medical_or_educational_services=1"));
    final body = json.decode(response.body);
    print("mahmoud" + body.toString());
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      return List<VendorModel>.from(body['result']['merchants']['merchants']
          .map((data) => VendorModel.fromMap(data)));
    }
  }

  static Future<List<VendorModel>> fetchMarkets({
    String lat,
    String lng,
    int page,
  }) async {
    final response = await http.get(Uri.parse(_url +
        "getShowroomsForUser?lang=${RegisterModel.shared.lang}&"
            "current_lat=$lat&current_lng=$lng&page=$page"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      var rooms = List<VendorModel>.from(
          body['result']['showrooms'].map((data) => VendorModel.fromMap(data)));
      print("mahmoud" + rooms.length.toString());
      return rooms;
    }
  }

  static Future<List<VendorModel>> fetchJobs(
      {String lat, String lng, int page, String city_name: ""}) async {
    print('fetchJobs $fetchJobs');
    String rout = _url +
        "applicantsList?lang=${RegisterModel.shared.lang}&page=$page" +
        (city_name.isNotEmpty ? "&city_name=$city_name" : "");
    print('routrote '+rout);
    final response = await http.get(Uri.parse(_url +
        "applicantsList?lang=${RegisterModel.shared.lang}&page=$page" +
        (city_name.isNotEmpty ? "&city_name=$city_name" : "")));
    final body = json.decode(response.body);
    print('bodyfff $body');
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      var rooms = List<VendorModel>.from(body['result']['applicants']
              ['applicants']
          .map((data) => VendorModel.fromMap(data)));
      return rooms;
    }
  }

  static Future<List<VendorModel>> FetchDisableJobs(
      {String lat, String lng, int page, String city_name: ""}) async {
    final response = await http.get(Uri.parse(_url +
        "disableApplicantsList?lang=${RegisterModel.shared.lang}&page=$page" +
        (city_name.isNotEmpty ? "&city_name=$city_name" : "")));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      var rooms = List<VendorModel>.from(body['result']['applicants']
              ['applicants']
          .map((data) => VendorModel.fromMap(data)));
      return rooms;
    }
  }

  static Future<List<VendorModel>> getNotifications() async {
    final response = await http.get(
        Uri.parse(
            _url + "getUserNotifications?lang=${RegisterModel.shared.lang}"),
        headers: headers);
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      print("mahmoud" + body['errors']);
      throw body['errors'];
    } else {
      var rooms = List<VendorModel>.from(body['result']['notifications']
              ['notifications']
          .map((data) => VendorModel.fromMap(data)));
      return rooms;
    }
  }

  static Future<List<BrandModel>> fetchBrands({String categoryId}) async {
    final response = await http.get(Uri.parse(_url +
        "getCategoryBrands?category_id=$categoryId&lang=${RegisterModel.shared.lang}"));
    final body = json.decode(response.body);
    if (body['status'] == "failed") {
      throw body['errors'];
    } else {
      return List<BrandModel>.from(
          body['result'].map((brand) => BrandModel.fromMap(brand)));
    }
  }

  static Future<bool> addWinsh({
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
    final response = await http.post(
        Uri.parse(_url + "addWinsh?lang=${RegisterModel.shared.lang}"),
        body: {
          'country_id': country_id,
          'country_code': country_code,
          'company_name': company_name,
          'whatsapp': whatsapp,
          'phone2': phone2,
          "driver_name": driver_name,
          "lat": lat,
          "lng": lng,
          "company_img": company_img,
          "winsh_img": winsh_img,
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

  static Future<bool> addNormalUser() async {
    final response =
        await http.post(Uri.parse(_url + "addNormalUser"), headers: {
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
