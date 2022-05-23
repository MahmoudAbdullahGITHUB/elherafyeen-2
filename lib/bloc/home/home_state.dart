part of 'home_bloc.dart';

@immutable
abstract class HomeState {
  const HomeState();
}

class InitialHomeState extends HomeState {}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class CategoriesLoaded extends HomeState {
  List<CategoryModel> categories;

  CategoriesLoaded({this.categories});
}

class VendrosToSearchWith extends HomeState {
  List<SearchModel> searches;

  VendrosToSearchWith({this.searches});
}

class ServicesLoaded extends HomeState {
  List<CategoryModel> searches;

  ServicesLoaded({this.searches});
}

class BrandsLoaded extends HomeState {
  List<BrandModel> brands;

  BrandsLoaded({this.brands});
}

class VendorLoaded extends HomeState {
  List<VendorModel> vendors;

  VendorLoaded({this.vendors});
}

class HomeError extends HomeState {
  final String error;

  const HomeError({this.error});
}
