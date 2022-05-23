part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {
  const AuthEvent();
}

class LoadCountries extends AuthEvent {
  const LoadCountries();
}

class LoginButtonPressed extends AuthEvent {
  String phone;
  String password;

  LoginButtonPressed({
    this.phone,
    this.password,
  });
}

class RegisterButtonPressed extends AuthEvent {
  String phone;
  String whatsapp;
  String password;
  String name;
  String countryId;
  String lang;

  RegisterButtonPressed({
    this.phone,
    this.whatsapp,
    this.password,
    this.name,
    this.countryId,
    this.lang,
  });
}
