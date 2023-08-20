import 'package:flutter/material.dart';

extension WidgetDesignExtension on Widget{
  Widget expanded(int flex, {Key? key}) => Expanded(
    flex: flex,
    key: key,
    child: this,
  );
}