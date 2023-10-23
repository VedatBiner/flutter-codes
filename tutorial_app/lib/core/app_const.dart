// app_const.dart
import '../core/language_model/language_listener.dart';
import '../config/theme/theme_light.dart';
import '../config/theme/theme_manager.dart';

final class AppConst {
  const AppConst._();
  static const Duration splashDuration = Duration(seconds: 2);

  static final ThemeManagerNotifier themeNotifier =
      ThemeManagerNotifier(LightTheme.theme);

  static final LanguageListener language = LanguageListener(true);
}
