class WinshModel {
  String country_id;
  String country_code;
  String company_name;
  String phone;
  String id;
  String whatsapp;
  String phone2;
  String driver_name;
  String lat;
  String lng;
  String company_img;
  String winsh_img;

  WinshModel({
    this.country_id,
    this.country_code,
    this.company_name,
    this.phone,
    this.id,
    this.whatsapp,
    this.phone2,
    this.driver_name,
    this.lat,
    this.lng,
    this.company_img,
    this.winsh_img,
  });

  factory WinshModel.fromMap(Map<String, dynamic> map) {
    return new WinshModel(
      country_id: map['country_id'].toString() ?? "",
      country_code: map['country_code'].toString() ?? "",
      company_name: map['company_name'].toString() ?? "",
      phone: map['phone'].toString() ?? "",
      id: map['id'].toString() ?? "" ?? "",
      whatsapp: map['whatsapp'].toString() ?? "",
      phone2: map['phone2'].toString() ?? "",
      driver_name: map['driver_name'].toString() ?? "",
      lat: map['lat'].toString() ?? "",
      lng: map['lng'].toString() ?? "",
      company_img: map['company_img'].toString() ?? "",
      winsh_img: map['winsh_img'].toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'country_id': this.country_id,
      'country_code': this.country_code,
      'company_name': this.company_name,
      'phone': this.phone,
      'whatsapp': this.whatsapp,
      'phone2': this.phone2,
      'driver_name': this.driver_name,
      'lat': this.lat,
      'lng': this.lng,
      'company_img': this.company_img,
      'winsh_img': this.winsh_img,
    } as Map<String, dynamic>;
  }
}
