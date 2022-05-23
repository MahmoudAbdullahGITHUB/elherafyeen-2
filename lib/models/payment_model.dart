class PaymentModel {
  String bill_reference;
  String id;
  String payment_id;

//<editor-fold desc="Data Methods" defaultstate="collapsed">

  PaymentModel({
    this.bill_reference,
    this.id,
    this.payment_id,
  });

  PaymentModel copyWith({
    String bill_reference,
    String id,
    String payment_id,
  }) {
    return new PaymentModel(
      bill_reference: bill_reference ?? this.bill_reference,
      id: id ?? this.id,
      payment_id: payment_id ?? this.payment_id,
    );
  }

  @override
  String toString() {
    return 'PaymentModel{bill_reference: $bill_reference, id: $id, payment_id: $payment_id}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentModel &&
          runtimeType == other.runtimeType &&
          bill_reference == other.bill_reference &&
          id == other.id &&
          payment_id == other.payment_id);

  @override
  int get hashCode =>
      bill_reference.hashCode ^ id.hashCode ^ payment_id.hashCode;

  factory PaymentModel.fromMap(Map<String, dynamic> map) {
    return new PaymentModel(
      bill_reference: map['bill_reference'].toString() ?? "",
      id: map['id'].toString() ?? "",
      payment_id: map['payment_id'].toString() ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'bill_reference': this.bill_reference,
      'id': this.id,
      'payment_id': this.payment_id,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
