import 'package:flutter/material.dart';

extension PlatformInfoExtension on BuildContext {
  TargetPlatform get platform => Theme.of(this).platform;
  bool get isMobilePlatform =>
      platform == TargetPlatform.android || platform == TargetPlatform.iOS;
  bool get isDesktopPlatform =>
      platform == TargetPlatform.windows ||
      platform == TargetPlatform.macOS ||
      platform == TargetPlatform.linux;
  bool get isWebPlatform => !isMobilePlatform && !isDesktopPlatform;
}
