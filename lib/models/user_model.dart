import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  static final shared = UserModel(
    apiToken: null,
    id: 0,
    name: '',
    email: '',
    photo: '',
    phone: "",
    lang: "",
    addressId: 0,
  );

  String apiToken;
  int id;
  String name;
  String email;
  String photo;
  String phone;
  String lang;
  int addressId;

  UserModel({
    this.apiToken,
    this.id,
    this.name = "User Name",
    this.email,
    this.photo = "",
    this.phone = "",
    this.lang = "en",
    this.addressId = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        apiToken: json['user']['apitoken'],
        name: json['user']['name'] ?? '',
        id: json['user']['id'] ?? 0,
        email: json['user']['email'] ?? "-",
        photo: json['user']['photo'] ?? "",
        phone: json['user']['phone'] ?? "",
        addressId: 0);
  }
  factory UserModel.fromAdmin(Map<String, dynamic> json) {
    return UserModel(
      apiToken: "",
      name: json['name'] ?? '',
      id: json['id'] ?? 0,
      email: json['email'] ?? "-",
      photo: json['photo'] ?? "",
      phone: json['phone'] ?? "",
    );
  }

  factory UserModel.init() {
    UserModel.shared.getUserData();
    return UserModel.shared;
  }

  Future<void> initFromJson(Map<String, dynamic> json) async {
    apiToken = json['user']['apitoken'];
    id = json['user']['id'];
    name = json['user']['name'];
    phone = json['user']['phone'] != null ? json['user']['phone'] : "";
    email = json['user']['email'];
    photo = json['user']['photo'] != null ? json['user']['photo'] : "";
    lang = UserModel.shared.lang == null ? "en" : UserModel.shared.lang;
    addressId = 0;
  }

  Future<void> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    apiToken = prefs.getString('apiToken');
    id = prefs.getInt('id');
    name = prefs.getString('name');
    phone = prefs.getString('phone');
    email = prefs.getString('email');
    photo = prefs.getString('photo');
    lang = prefs.getString('lang');
    addressId = prefs.getInt('addressId');
  }

  Future<void> saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('apiToken', apiToken);
    prefs.setInt('id', id);
    prefs.setString('name', name);
    prefs.setString('email', email);
    prefs.setString('photo', photo);
    prefs.setString('phone', phone);
    prefs.setString('lang', lang);
    prefs.setInt('addressId', addressId);
  }

  Future<void> deleteUserData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("id");
    prefs.remove("name");
    prefs.remove("phone");
    prefs.remove("email");
    prefs.remove("photo");
    prefs.remove("lang");
    prefs.remove("addressId");
  }
}
