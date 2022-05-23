part of 'vendor_bloc.dart';

@immutable
abstract class VendorEvent {
  const VendorEvent();
}

class LoadingEvents extends VendorEvent {
  const LoadingEvents();
}

class LoadingEventsForMarket extends VendorEvent {
  const LoadingEventsForMarket();
}

class LoadingBrands extends VendorEvent {
  final catId;

  const LoadingBrands({this.catId});
}

class DoNothing extends VendorEvent {
  DoNothing();
}

class AddVendor extends VendorEvent {
  BuildContext context;
  String categoryId;
  int idOfStaff;
  String classification_id;
  String place_type_id;
  String working_hours;
  String owner_name;
  String lat;
  String lng;
  List<String> providedServices;
  List<String> brands;
  List<String> fields;
  List<String> galleryImagesBase64;

  // String providedServices2;
  String logo;
  String address;
  String desc;
  String name;
  String whats;
  String phone;

  AddVendor({
    this.context,
    this.categoryId,
    this.classification_id,
    this.place_type_id,
    this.working_hours,
    this.owner_name,
    this.lat,
    this.brands,
    this.idOfStaff,
    this.galleryImagesBase64,
    this.fields,
    this.lng,
    this.phone,
    this.name,
    this.whats,
    this.providedServices,
    this.logo,
    this.address,
    this.desc,
  });
}
