import 'package:flutter/foundation.dart' show immutable;

import '../models.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  //3 lines below just to craete singleton instance of this class. Singleton Pattern
  // const LoginApi._sharedInstance(); //1
  // static const LoginApi _shared = LoginApi._sharedInstance(); //2
  // factory LoginApi.instance() => _shared; //3

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => email == 'foo@bar.com' && password == 'foobar',
      ).then((isLoggedIn) => isLoggedIn ? const LoginHandle.fooBar(): null);
}
