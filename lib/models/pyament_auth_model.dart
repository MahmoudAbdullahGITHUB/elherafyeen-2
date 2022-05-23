class PaymentAuthModel {
  String token;
  String merchant_id;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  PaymentAuthModel({
    this.token,
    this.merchant_id,
  });

  PaymentAuthModel copyWith({
    String token,
    String merchant_id,
  }) {
    return new PaymentAuthModel(
      token: token ?? this.token,
      merchant_id: merchant_id ?? this.merchant_id,
    );
  }

  @override
  String toString() {
    return 'PaymentAuthModel{token: $token, merchant_id: $merchant_id}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentAuthModel &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          merchant_id == other.merchant_id);

  @override
  int get hashCode => token.hashCode ^ merchant_id.hashCode;

  factory PaymentAuthModel.fromMap(Map<String, dynamic> map) {
    return new PaymentAuthModel(
      token: map['token'].toString() ?? "",
      merchant_id: map['merchant_id'].toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'token': this.token,
      'merchant_id': this.merchant_id,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
