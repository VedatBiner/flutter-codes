/// <----- login_page.dart ----->
library;

import 'package:flutter/material.dart';

import 'package:flutter_login/flutter_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  /// loading time ...
  Duration get loadingTime => const Duration(seconds: 2000);

  /// login
  Future<String?> _authUser(LoginData data){
    return Future.delayed(loadingTime).then((value) => null);
  }

  /// forgot password
  Future<String?> _recoverPassword(String data){
    return Future.delayed(loadingTime).then((value) => null);
  }

  /// sign up
  Future<String?> _signUp(SignupData data){
    return Future.delayed(loadingTime).then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        onLogin: _authUser,
        onRecoverPassword: _recoverPassword,
      ),
    );
  }
}

