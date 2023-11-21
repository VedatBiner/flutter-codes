/// <----- context_extension.dart ----->
library;
import 'package:flutter/material.dart';

import '../../core/language_model/language_listener.dart';
import '../../config/theme/theme_manager.dart';

extension ThemeManagerContextExtension on BuildContext{
  ThemeData get theme => ThemeManager.of(this).theme;
}

extension LanguageManagerContextExtension on BuildContext{
  bool get language => LanguageManager.of(this);
}
