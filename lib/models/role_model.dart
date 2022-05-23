class RoleModel {
  String id;
  String role_name;

  RoleModel({this.id, this.role_name});

  factory RoleModel.fromMap(Map<String, dynamic> map) {
    return new RoleModel(
      id: map['id'].toString(),
      role_name: map['name'].toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'role_name': this.role_name,
    } as Map<String, dynamic>;
  }
}
