/// <----- app_const.dart ----->

import 'package:flutter/material.dart';

import '../components/page_controller.dart';
import '../theme/theme_light.dart';
import '../theme/theme_manager.dart';

part "../constants/main_constant.dart";
part "../constants/listener_constant.dart";
part "../constants/splash_constant.dart";
part "../constants/home_constant.dart";

final class AppConst {
  AppConst._();

  static final listener = _ListenerConstant();
  static final main = _MainConstant();
  static final splash = _SplashConstant();
  static final home = _HomeConstant();
}
