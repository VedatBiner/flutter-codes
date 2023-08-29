import 'package:flutter/material.dart';

extension PlatformInfoExtension on BuildContext {
  TargetPlatform get platform => Theme.of(this).platform;
  bool get isMobile =>
      platform == TargetPlatform.android || platform == TargetPlatform.iOS;
  bool get isDesktop =>
      platform == TargetPlatform.windows ||
      platform == TargetPlatform.macOS ||
      platform == TargetPlatform.linux;
  bool get isWeb => !isMobile && !isDesktop;
}
