/// <----- lapp_const.dart ----->
library;

import 'package:flutter/cupertino.dart';
import 'package:tutorial_app/views/home/components/page_controller.dart';

import '../core/language_model/language_listener.dart';
import '../config/theme/theme_light.dart';
import '../config/theme/theme_manager.dart';
import '../core/language_model/language_model.dart';

part "../constant/listener_constant.dart";
part "../constant/main_constant.dart";
part "../constant/splash_constant.dart";
part "../constant/home_constant.dart";

final class AppConst {
  AppConst._();

  static final listener = _ListenerConstant();
  static final main = _MainConstant();
  static final splash = _SplashConstant();
  static final home = _HomeConstant();
}