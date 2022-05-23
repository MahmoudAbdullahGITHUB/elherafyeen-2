class VehicleModel {
  String id;
  String category_id;
  String brand_id;
  String model_id;
  String shape_id;
  String gear_box_id;
  String fuel_type_id;
  String cc;
  String manufacturing_year;
  String color;
  String cfduid;
  String image;
  String brand_name;
  String model_name;
  String shape_name;
  String gear_box_name;
  String fuel_name;

  VehicleModel(
      {this.id,
      this.category_id,
      this.brand_id,
      this.model_id,
      this.shape_id,
      this.gear_box_id,
      this.fuel_type_id,
      this.cc,
      this.manufacturing_year,
      this.color,
      this.cfduid,
      this.image,
      this.brand_name,
      this.model_name,
      this.shape_name,
      this.gear_box_name,
      this.fuel_name});

  factory VehicleModel.fromJson(Map<String, dynamic> map) {
    return new VehicleModel(
      id: map['id'].toString(),
      category_id: map['category_id'].toString(),
      brand_id: map['brand_id'].toString(),
      model_id: map['model_id'].toString(),
      shape_id: map['shape_id'].toString(),
      gear_box_id: map['gear_box_id'].toString(),
      fuel_type_id: map['fuel_type_id'].toString(),
      cc: map['cc'].toString(),
      manufacturing_year: map['manufacturing_year'].toString(),
      color: map['color'].toString(),
      cfduid: map['__cfduid'].toString(),
      image: map['image'].toString(),
      brand_name: map['brand_name'].toString(),
      model_name: map['model_name'].toString(),
      shape_name: map['shape_name'].toString(),
      gear_box_name: map['gear_box_name'].toString(),
      fuel_name: map['fuel_name'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'category_id': this.category_id,
      'brand_id': this.brand_id,
      'model_id': this.model_id,
      'shape_id': this.shape_id,
      'gear_box_id': this.gear_box_id,
      'fuel_type_id': this.fuel_type_id,
      'cc': this.cc,
      'manufacturing_year': this.manufacturing_year,
      'color': this.color,
      '__cfduid': this.cfduid,
      'image': this.image,
    };
  }
}
