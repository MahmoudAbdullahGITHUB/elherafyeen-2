part of 'ship_bloc.dart';

@immutable
abstract class ShipEvent {
  const ShipEvent();
}

class LoadCountries extends ShipEvent {
  const LoadCountries();
}

class AddShippingCoButtonPressed extends ShipEvent {
  String country_id;
  String country_code;
  String company_name;
  String shipping_type;
  String whatsapp;
  String phone2;
  String phone;
  String owner_name;
  String lat;
  String lng;
  String company_img;
  String company_details;
  String company_phone;
  bool staff;
  BuildContext context;

  AddShippingCoButtonPressed(
      {this.country_id,
      this.staff,
      this.context,
      this.country_code,
      this.company_name,
      this.whatsapp,
      this.phone2,
      this.phone,
      this.shipping_type,
      this.lat,
      this.lng,
      this.owner_name,
      this.company_img,
      this.company_details,
      this.company_phone});
}
