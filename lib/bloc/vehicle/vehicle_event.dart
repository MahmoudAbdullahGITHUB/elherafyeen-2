part of 'vehicle_bloc.dart';

@immutable
abstract class VehicleEvent {
  const VehicleEvent();
}

class FetchCategories extends VehicleEvent {
  const FetchCategories();
}

class FetchBrand extends VehicleEvent {
  final catId;

  const FetchBrand({this.catId});
}

class FetchBrandModels extends VehicleEvent {
  final brandId;

  const FetchBrandModels({this.brandId});
}

class FetchShapes extends VehicleEvent {
  final catId;

  const FetchShapes({this.catId});
}

class FetchNothing extends VehicleEvent {
  const FetchNothing();
}

class FetchFuelTypes extends VehicleEvent {
  const FetchFuelTypes();
}

class AddVehicle extends VehicleEvent {
  final String categoryId;
  final String brandId;
  final String modelId;
  final String lat;
  final String lng;
  final String shapeId;
  final String gearBoxId;
  final String fuelTypeId;
  final String cc;
  final String manufacturingYear;
  final String color;
  final String image;

  const AddVehicle(
      {this.categoryId,
      this.brandId,
      this.lat,
      this.lng,
      this.modelId,
      this.shapeId,
      this.gearBoxId,
      this.fuelTypeId,
      this.cc,
      this.manufacturingYear,
      this.color,
      this.image});
}
