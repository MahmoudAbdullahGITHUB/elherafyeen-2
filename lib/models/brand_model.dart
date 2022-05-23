class BrandModel {
  String id;
  String name;
  String photo;

  BrandModel({
    this.id,
    this.name,
    this.photo,
  });

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    return new BrandModel(
      id: map['id'].toString() ?? "-1",
      name: map['name'].toString() ?? "",
      photo: map['logo'].toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'name': this.name,
      // 'photo': this.photo,
    } as Map<String, dynamic>;
  }
}
