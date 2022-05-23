import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elherafyeen/api/auth_api.dart';
import 'package:elherafyeen/api/staff_api.dart';
import 'package:elherafyeen/models/country_model.dart';
import 'package:elherafyeen/models/role_model.dart';
import 'package:meta/meta.dart';

part 'staff_event.dart';
part 'staff_state.dart';

class StaffBloc extends Bloc<StaffEvent, StaffState> {
  StaffBloc({StaffState initialState}) : super(initialState);

  @override
  StaffState get initialState => InitialStaffState();

  @override
  Stream<StaffState> mapEventToState(StaffEvent event) async* {
    if (event is LoadCountriesAndRoles) {
      yield StaffLoading();
      try {
        var countries = await AuthApi.fetchCountries();
        var roles = await StaffApi.fetchRolesApi();

        yield LoaddedData(roles: roles, countries: countries);
      } catch (e) {
        print("mahmoud" + e.toString());
        yield StaffError(error: e.toString());
      }
    }
  }
}
