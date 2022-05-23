part of 'winsh_bloc.dart';

@immutable
abstract class WinshState {
  const WinshState();
}

class InitialWinshState extends WinshState {}

class LoadingWinsh extends WinshState {
  const LoadingWinsh();
}

class AddWinshLoading extends WinshState {
  const AddWinshLoading();
}

class CountriesLoadded extends WinshState {
  List<CountryModel> countries;

  CountriesLoadded({this.countries});
}

class WinchesLoadded extends WinshState {
  List<VendorModel> winches;

  WinchesLoadded({this.winches});
}

class WinshError extends WinshState {
  String error;

  WinshError({this.error});
}

class WinshAdded extends WinshState {
  bool result;

  WinshAdded({this.result});
}
