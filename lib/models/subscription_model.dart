class SubscriptionModel {
  String id;
  String name;
  String value;

  SubscriptionModel({
    this.id,
    this.name,
    this.value,
  });

  SubscriptionModel copyWith({
    String id,
    String sub_id,
    String value,
  }) {
    return new SubscriptionModel(
      id: id ?? this.id,
      name: sub_id ?? this.name,
      value: value ?? this.value,
    );
  }

  @override
  String toString() {
    return 'SubscriptionModel{id: $id, name: $name, value: $value}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubscriptionModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          value == other.value);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ value.hashCode;

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return new SubscriptionModel(
      id: map['id'].toString(),
      name: map['name'].toString(),
      value: map['value'].toString(),
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'id': this.id,
      'name': this.name,
      'value': this.value,
    } as Map<String, dynamic>;
  }

//</editor-fold>

}
