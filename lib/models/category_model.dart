class CategoryModel {
  String id;
  String name;
  String logo;
  String merchants_number_in;
  CategoryModel({
    this.id,
    this.name,
    this.logo,
    this.merchants_number_in,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return new CategoryModel(
      id: map['id'].toString() ?? "",
      name: map['name'].toString() ?? "",
      logo: map['logo'] ?? map['image'] ?? "",
      merchants_number_in: map['merchants_number_in']!=null ?map['merchants_number_in'].toString() : "",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'name': this.name,
      'logo': this.logo,
    } as Map<String, dynamic>;
  }
}
