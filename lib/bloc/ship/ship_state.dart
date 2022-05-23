part of 'ship_bloc.dart';

@immutable
abstract class ShipState {
  const ShipState();
}

class InitialShipState extends ShipState {}

class LoadingShip extends ShipState {
  const LoadingShip();
}

class AddShipLoading extends ShipState {
  const AddShipLoading();
}

class CountriesAndShippingTypesLoadded extends ShipState {
  List<CountryModel> countries;
  List<ShippingTypeModel> shippingTypes;

  CountriesAndShippingTypesLoadded({this.countries, this.shippingTypes});
}

class ShipError extends ShipState {
  String error;

  ShipError({this.error});
}

class ShipAdded extends ShipState {
  bool result;

  ShipAdded({this.result});
}
