class ShippingTypeModel {
  String id;
  String shipping_type;

  ShippingTypeModel({
    this.id,
    this.shipping_type,
  });

  factory ShippingTypeModel.fromMap(Map<String, dynamic> map) {
    return new ShippingTypeModel(
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
