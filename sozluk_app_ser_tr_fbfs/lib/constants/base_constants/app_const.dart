/// <----- app_const.dart ----->

import 'package:flutter/material.dart';

import '../../components/page_controller.dart';
// import '../../theme/theme_light.dart_orj';
// import '../../theme/theme_manager.dart_orj';

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
