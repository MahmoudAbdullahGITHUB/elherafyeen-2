class CountryModel {
  String id;
  String code;
  String key_name;
  String country_name;

  CountryModel({
    this.id,
    this.code,
    this.key_name,
    this.country_name,
  });

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return new CountryModel(
      id: map['id'].toString(),
      code: map['code'].toString(),
      key_name: map['key_name'].toString(),
      country_name: map['country_name'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'code': this.code,
      'key_name': this.key_name,
      'country_name': this.country_name,
    } as Map<String, dynamic>;
  }
}
