class BrandModelModel {
  String id;
  String model_name;

  BrandModelModel({
    this.id,
    this.model_name,
  });

  factory BrandModelModel.fromMap(Map<String, dynamic> map) {
    return new BrandModelModel(
      id: map['id'].toString() ?? "",
      model_name: map['model_name'].toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'model_name': this.model_name,
    } as Map<String, dynamic>;
  }
}
