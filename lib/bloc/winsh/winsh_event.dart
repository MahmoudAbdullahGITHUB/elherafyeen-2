part of 'winsh_bloc.dart';

@immutable
abstract class WinshEvent {
  const WinshEvent();
}

class LoadCountries extends WinshEvent {
  const LoadCountries();
}

class LoadWinches extends WinshEvent {
  final lat, lng, page, company;

  const LoadWinches({this.lat, this.lng, this.page, this.company});
}

class LoadCaptines extends WinshEvent {
  final lat, lng, category_id;

  const LoadCaptines({this.lat, this.lng, this.category_id});
}

class LoadNearbyCaptains extends WinshEvent {
  final lat, lng;

  const LoadNearbyCaptains({this.lat, this.lng});
}

class AddWinshButtonPressed extends WinshEvent {
  BuildContext context;
  bool staff_id;
  String country_id;
  String country_code;
  String company_name;
  String whatsapp;
  String phone2;
  String driver_name;
  String lat;
  String lng;
  String company_img;
  String winsh_img;

  AddWinshButtonPressed({
    this.context,
    this.staff_id: false,
    this.country_id,
    this.country_code,
    this.company_name,
    this.whatsapp,
    this.phone2,
    this.driver_name,
    this.lat,
    this.lng,
    this.company_img,
    this.winsh_img,
  });
}
