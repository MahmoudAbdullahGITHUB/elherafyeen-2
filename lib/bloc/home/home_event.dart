part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {
  const HomeEvent();
}

class FetchHomeCategories extends HomeEvent {
  const FetchHomeCategories();
}

class FetchVehicleCategories extends HomeEvent {
  const FetchVehicleCategories();
}

class FetchCategoryBrands extends HomeEvent {
  String catId;

  FetchCategoryBrands({this.catId});
}

class FetchOutsideMaintenence extends HomeEvent {
  String lat;
  String lng;

  FetchOutsideMaintenence({this.lat, this.lng});
}

class FetchOnlineDealers extends HomeEvent {
  String lat;
  String lng;
  String id;

  FetchOnlineDealers({this.id, this.lat, this.lng});
}

class FetchMedicalMerchant extends HomeEvent {
  String lat;
  String lng;

  FetchMedicalMerchant({this.lat, this.lng});
}

class FetchMyServices extends HomeEvent {
  String lat;
  String lng;
  String id;

  FetchMyServices({this.lat, this.lng, this.id});
}

class FetchJobs extends HomeEvent {
  String lat;
  String lng;

  FetchJobs({this.lat, this.lng});
}

class FetchDisableJobs extends HomeEvent {
  String lat;
  String lng;

  FetchDisableJobs({this.lat, this.lng});
}

class Search extends HomeEvent {
  String catId;
  String brandId;
  String lat;
  String lng;
  String searchId;

  Search({this.catId, this.lat, this.lng, this.searchId, this.brandId});
}

class FetchVendorsToSearchWith extends HomeEvent {
  String categoryId;

  FetchVendorsToSearchWith({this.categoryId});
}

class FetchServices extends HomeEvent {
  FetchServices();
}
