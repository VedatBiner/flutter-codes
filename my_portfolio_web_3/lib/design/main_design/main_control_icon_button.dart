import 'package:flutter/material.dart';
import 'package:my_portfolio_web_3/core/theme/theme_manager.dart';

IconButton mainControllerIconButton(
  IconData icon,
  void Function()? pressed,
) =>
    IconButton(
      onPressed: pressed,
      icon: Icon(
        icon,
        color: ThemeManager.instance.currentTheme.colorScheme.onBackground,
        size: 48,
      ),
    );
