part of 'vehicle_bloc.dart';

@immutable
abstract class VehicleState {
  const VehicleState();
}

class InitialVehicleState extends VehicleState {}

class LoadingCategories extends VehicleState {
  const LoadingCategories();
}

class LoadingAddVehicle extends VehicleState {
  const LoadingAddVehicle();
}

class CategoryLoaded extends VehicleState {
  List<CategoryModel> listCategories;
  List<CategoryModel> listGearBoxTypes;
  var listBrands;
  var listBrandsShape;
  var listBrandsModel;
  var listFuelTypes;

  CategoryLoaded(
      {this.listCategories,
      this.listGearBoxTypes,
      this.listBrands,
      this.listBrandsShape,
      this.listBrandsModel,
      this.listFuelTypes});
}

class LoadedBrands extends VehicleState {
  var listBrands;

  LoadedBrands({this.listBrands});
}

class LoadedBrandsShape extends VehicleState {
  var listBrandsShape;

  LoadedBrandsShape({this.listBrandsShape});
}

class LoadedNothing extends VehicleState {
  LoadedNothing();
}

class AddedVehicle extends VehicleState {
  var result;

  AddedVehicle({this.result});
}

class LoadedBrandsModel extends VehicleState {
  var listBrandsModel;

  LoadedBrandsModel({this.listBrandsModel});
}

class LoadingCategoriesError extends VehicleState {
  final String error;

  const LoadingCategoriesError({this.error});
}
