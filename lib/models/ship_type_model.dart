class ShipTypeModel {
  String id;
  String shipping_type;

  ShipTypeModel({
    this.id,
    this.shipping_type,
  });

  factory ShipTypeModel.fromMap(Map<String, dynamic> map) {
    return new ShipTypeModel(
      id: map['id'].toString(),
      shipping_type: map['shipping_type'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'shipping_type': this.shipping_type,
    } as Map<String, dynamic>;
  }
}
