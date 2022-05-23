class SearchModel {
  String id;
  String field_name;
  String logo;

  SearchModel({
    this.id,
    this.field_name,
    this.logo,
  });

  factory SearchModel.fromMap(Map<String, dynamic> map) {
    return new SearchModel(
      id: map['id'].toString(),
      field_name: map['field_name'].toString(),
      logo: map['logo'].toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'field_name': this.field_name,
    } as Map<String, dynamic>;
  }
}
