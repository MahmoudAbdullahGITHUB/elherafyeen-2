import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:elherafyeen/api/auth_api.dart';
import 'package:elherafyeen/models/country_model.dart';
import 'package:elherafyeen/models/user_model.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({AuthState initialState}) : super(initialState);

  @override
  AuthState get initialState => InitialAuthState();

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is LoadCountries) {
      try {
        var countries = await AuthApi.fetchCountries();
        yield CountriesLoaded(countries: countries);
      } catch (error) {
        print(error.toString());
        yield AuthError(error: error.toString());
      }
    } else if (event is RegisterButtonPressed) {
      yield AuthLoading();
      try {
        var result = await AuthApi.register(
            counrtyId: event.countryId,
            lang: event.lang,
            name: event.name,
            phone: event.phone,
            whatsapp: event.whatsapp,
            password: event.password);

        yield RegisterDone(result);
      } catch (error) {
        print(error.toString());
        yield AuthError(error: error.toString());
      }
    } else if (event is LoginButtonPressed) {
      yield AuthLoading();
      try {
        var result =
            await AuthApi.login(phone: event.phone, password: event.password);

        yield RegisterDone(result);
      } catch (error) {
        print(error.toString());
        yield AuthError(error: error.toString());
      }
    }
  }
}
