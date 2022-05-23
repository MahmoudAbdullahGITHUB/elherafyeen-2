part of 'vendor_bloc.dart';

@immutable
abstract class VendorState {
  const VendorState();
}

class InitialVendorState extends VendorState {}

class LoadingVendor extends VendorState {
  const LoadingVendor();
}

class DataLoadded extends VendorState {
  List<SearchModel> vendorFields;
  List<CategoryModel> categories;
  List<CategoryModel> classifications;
  List<CategoryModel> placeTypes;
  List<CategoryModel> workingHours;
  List<CategoryModel> servicesIntroduced;
  List<BrandModel> brands;

  DataLoadded(
      {this.vendorFields,
      this.categories,
      this.servicesIntroduced,
      this.classifications,
      this.placeTypes,
      this.brands,
      this.workingHours});
}

class DataLoaddedMarket extends VendorState {
  List<StoreTypeModel> storeTypes;
  List<CategoryModel> categories;

  DataLoaddedMarket({this.storeTypes, this.categories});
}

class VendorAdded extends VendorState {
  bool result;

  VendorAdded({this.result});
}

class BrandsLoaded extends VendorState {
  List<BrandModel> brands;

  BrandsLoaded({this.brands});
}

class LoadNothing extends VendorState {
  LoadNothing();
}

class ErrorVendor extends VendorState {
  final error;

  const ErrorVendor({this.error});
}
