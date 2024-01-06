/// <----- context_extension.dart ----->

import 'package:flutter/material.dart';

import '../theme/theme_manager.dart';

extension ThemeManagerContextExtension on BuildContext{
  ThemeData get theme => ThemeManager.of(this).theme;
}
