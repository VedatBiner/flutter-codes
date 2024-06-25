/// <----- app_const.dart ----->
library;

import 'package:flutter/material.dart';

import '../../components/page_controller.dart';

part 'main_constant.dart';
part 'listener_constant.dart';
part 'splash_constant.dart';
part 'home_constant.dart';

final class AppConst {
  AppConst._();
  static final listener = _ListenerConstant();
  static final main = _MainConstant();
  static final splash = _SplashConstant();
  static final home = _HomeConstant();
}
