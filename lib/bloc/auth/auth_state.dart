part of 'auth_bloc.dart';

@immutable
abstract class AuthState {
  const AuthState();
}

class CountriesLoaded extends AuthState {
  List<CountryModel> countries;

  CountriesLoaded({this.countries});
}

class InitialAuthState extends AuthState {}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class RegisterDone extends AuthState {
  bool result;

  RegisterDone(this.result);
}

class AuthSuccess extends AuthState {
  UserModel userData;

  AuthSuccess({this.userData});
}

class AuthError extends AuthState {
  String error;

  AuthError({this.error});
}
