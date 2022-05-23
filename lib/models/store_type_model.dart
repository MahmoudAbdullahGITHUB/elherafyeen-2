class StoreTypeModel {
  String id;
  String tool_type_name;

  StoreTypeModel({
    this.id,
    this.tool_type_name,
  });

  factory StoreTypeModel.fromMap(Map<String, dynamic> map) {
    return new StoreTypeModel(
      id: map['id'].toString(),
      tool_type_name: map['tool_type_name'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'tool_type_name': this.tool_type_name,
    } as Map<String, dynamic>;
  }
}
