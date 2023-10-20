import 'package:flutter/material.dart';
import 'package:tutorial_app/config/theme/theme_dark.dart';
import 'package:tutorial_app/config/theme/theme_light.dart';

class ThemeManager extends InheritedWidget {
  final ThemeData theme;
  final VoidCallback changeTheme;

  const ThemeManager({
    super.key,
    required this.theme,
    required this.changeTheme,
    required Widget child,
  }) : super(child: child);

  static ThemeManager? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeManager>();
  }

  static ThemeManager of(BuildContext context) {
    final themes = maybeOf(context);
    assert(themes != null, "Not found ThemeManager on Context");
    return themes!;
  }

  @override
  bool updateShouldNotify(ThemeManager oldWidget) {
    return theme != oldWidget.theme;
  }
}

class ThemeManagerNotifier extends ValueNotifier<ThemeData> {
  ThemeManagerNotifier(ThemeData value) : super(value);

  void changeTheme() {
    if (value == LightTheme.theme) {
      value = DarkTheme.theme;
    } else {
      value = LightTheme.theme;
    }
    notifyListeners();
  }
}
