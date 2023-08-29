import 'package:flutter/material.dart';

extension BuildContextScreenSizeExtension on BuildContext{
  Size get size => MediaQuery.of(this).size;
  bool get isDesktop => size.width >= 1200;
  bool get isTablet => size.width >= 600;
  bool get isMobile => !isDesktop && !isTablet;
}

