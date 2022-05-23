class CategoryShapeModel {
  String id;
  String shape_name;

  CategoryShapeModel({
    this.id,
    this.shape_name,
  });

  factory CategoryShapeModel.fromMap(Map<String, dynamic> map) {
    return new CategoryShapeModel(
      id: map['id'].toString(),
      shape_name: map['shape_name'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'shape_name': this.shape_name,
    } as Map<String, dynamic>;
  }
}
