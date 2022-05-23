part of 'staff_bloc.dart';

@immutable
abstract class StaffState {
  const StaffState();
}

class InitialStaffState extends StaffState {}

class StaffLoading extends StaffState {
  const StaffLoading();
}

class LoaddedData extends StaffState {
  List<RoleModel> roles;
  List<CountryModel> countries;

  LoaddedData({this.roles, this.countries});
}

class StaffError extends StaffState {
  String error;

  StaffError({this.error});
}
