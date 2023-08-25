import 'package:flutter/material.dart';
import '../../core/constants/enum/theme_enum.dart';
import '../../core/theme/theme_interface.dart';
import '../../core/theme/theme_light.dart';

class ThemeManager extends ChangeNotifier implements IThemeManager {
  static ThemeManager? _instance;
  static ThemeManager get instance {
    _instance ??= ThemeManager.init();
    return _instance!;
  }

  ThemeManager.init();

  @override
  ThemeEnum currentEnum = ThemeEnum.light;

  @override
  ThemeData currentTheme = ThemeLight.instance.theme;

  @override
  void changeTheme(ThemeEnum themeEnum) {
    currentEnum = themeEnum;
    currentTheme = themeEnum.theme;
    notifyListeners();
  }

  @override
  void reverseTheme() {
    currentEnum =
        currentEnum == ThemeEnum.light ? ThemeEnum.dark : ThemeEnum.light;
    currentTheme = currentEnum.theme;
    notifyListeners();
  }
}
