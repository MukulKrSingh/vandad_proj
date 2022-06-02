import 'package:flutter/foundation.dart' show immutable;


@immutable
abstract class AppAction {
  const AppAction();
}


@immutable class LoginAction implements AppAction {
  final String email;
  final String password;

  const LoginAction({
    required this.email,
    required this.password,
  });

  @override
  String toString() => 'LoginAction(email: $email, password: $password)';
}


@immutable class LoadNotesAction implements AppAction {
  //final LoginHandle loginHandle;

  const LoadNotesAction();

  
}