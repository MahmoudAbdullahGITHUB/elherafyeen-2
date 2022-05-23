part of 'staff_bloc.dart';

@immutable
abstract class StaffEvent {
  const StaffEvent();
}

class LoadCountriesAndRoles extends StaffEvent {
  const LoadCountriesAndRoles();
}
