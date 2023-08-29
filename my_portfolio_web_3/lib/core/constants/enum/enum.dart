
import 'package:flutter/material.dart';

enum GapEnum {
  xS(8),
  S(16),
  N(24),
  M(36),
  L(48),
  xL(64),
  xxL(96),
  ;

  Widget get heightBox => SizedBox(height: value);
  Widget get widthBox => SizedBox(width: value);
  const GapEnum(this.value);
  final double value;
}

