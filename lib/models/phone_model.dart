

class PhoneModel {
  String phone1;
  String phone2;
  String phone3;
  String name1;
  String name2;
  String name3;

  PhoneModel({this.phone1, this.phone2, this.phone3, this.name1, this.name2,
      this.name3});

  factory PhoneModel.fromMap(dynamic map) {
    if (null == map) return null;
    var temp;
    return PhoneModel(
      phone1: map['phone1']?? "",
      phone2: map['phone2']?? "",
      phone3: map['phone3']?? "",
      name1: map['name1']?? "",
      name2: map['name2']?? "",
      name3: map['name3']?? "",
    );
  }
}