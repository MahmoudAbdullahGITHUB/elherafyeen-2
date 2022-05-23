import 'package:elherafyeen/models/vehicle_model.dart';
import 'package:elherafyeen/models/vendor_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterModel {
  static final shared = RegisterModel(
    token: "",
    phone: "",
    id: "",
    user_id: "",
    username: "",
    type_id: "",
    email: "",
    image: "",
    lang: "ar",
    sugPhone:"",
  );

  String token;
  String phone;
  String id;
  String user_id;
  String username;
  String lang;
  String type_id;
  String email;
  String image;
  String sub_id;
  String role_id;
  String sugPhone;
  List<VehicleModel> vehicles;
  List<VendorModel> vendors;
  List<String> gallery;
  RegisterModel({
    this.token,
    this.phone,
    this.id,
    this.user_id,
    this.username,
    this.type_id,
    this.email,
    this.vehicles,
    this.vendors,
    this.lang,
    this.image,
    this.sub_id,
    this.role_id,
    this.sugPhone,
    this.gallery,
  });

  Future<void> fromJson(Map<String, dynamic> map) {
    token = map['token'].toString() ?? "";
    phone = map['user']['phone'].toString() ?? "";
    id = map['user']['id'].toString() ?? "";
    user_id = map['user']['user_id'].toString()  ??map['user']['id'].toString()  ?? "";
    username = map['user']['name'].toString() ?? "";
    type_id = map['user']['type_id'].toString() ?? "";
    email = map['user']['email'].toString() ?? "";
    image = map['user']['image'].toString() ?? map['user']['logo'];
  }

  factory RegisterModel.fromJsonMap(Map<String, dynamic> map) {
    return new RegisterModel(
      phone: map['phone'] ?? "",
      id: map['id'].toString() ?? "",
      user_id: map['user_id']??map['id'].toString() ?? "",
      username: map['name'].toString() ?? "",
      type_id: map['type_id'].toString() ?? "",
      email: map['email'].toString() ?? "",
      image: map['image'].toString() ?? "",
      sub_id: map['sub_id'].toString() ?? "",
      role_id: map['role_id'].toString() ?? "",
      vehicles: map['vehicles'] != null
          ? List<VehicleModel>.from(
              map['vehicles'].map((brand) => VehicleModel.fromJson(brand)))
          : null,
      gallery: map['gallery'] != null
          ? List<String>.from(map['gallery'].map((brand) => brand['image']))
          : null,
      // vendors: ['vendors'] != null
      //     ? List<VendorModel>.from(
      //         map['vendors'].map((brand) => VendorModel.fromMap(brand)))
      //     : null,
    );
  }

  Future<void> fromJsonRegister(Map<String, dynamic> map) {
    token = map['token'].toString() ?? "";
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token ?? "");
    prefs.setString('phone', phone ?? "");
    prefs.setString('id', id ?? "");
    prefs.setString('user_id', user_id ?? "");
    prefs.setString('email', email ?? "");
    prefs.setString('name', username ?? "");
    prefs.setString('type_id', type_id ?? "");
  }

  Future<void> saveUserDataInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('phone', phone);
    prefs.setString('id', id);
    prefs.setString('user_id', user_id);
    prefs.setString('email', email);
    prefs.setString('name', username);
    prefs.setString('type_id', type_id);
  }

  Future<void> saveUserImage(String image) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('image', image);
  }

  Future<void> saveLang(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', lang);
  }

  Future<void> saveLaunchLang(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('launchLang', lang);
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    phone = prefs.getString('phone');
    id = prefs.getString('id');
    user_id = prefs.getString('user_id');
    username = prefs.getString('name');
    type_id = prefs.getString('type_id');
    email = prefs.getString('email');
    image = prefs.getString('image');
    lang = prefs.getString('lang') ?? "ar";
  }

  Future<String> getLang() async {
    final prefs = await SharedPreferences.getInstance();
    lang = prefs.getString('lang') ?? "ar";

    return lang;
  }

  /// beso
  Future<String> getLaunchLang() async {
    final prefs = await SharedPreferences.getInstance();
    lang = prefs.getString('launchLang') ?? 'notSelectedBefore';

    return lang;
  }

  Future<void> saveSuggestionPhone(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sugPhone', phone);
  }

  Future<void> getSugNumber() async {
    final prefs = await SharedPreferences.getInstance();
    sugPhone = prefs.getString('sugPhone');
  }

  Future<void> deleteUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("phone");
    prefs.remove("lang");
    prefs.remove("id");
    prefs.remove("user_id");
    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("typed_data");
  }
}
