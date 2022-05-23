import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  EmployeeBloc(EmployeeState initialState) : super(initialState);

  @override
  EmployeeState get initialState => InitialEmployeeState();

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    // TODO: Add your event logic
  }
}
