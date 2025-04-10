import 'package:flutter/material.dart';

class HelperClass extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;
  final double paddingWidth;
  final Color bgColor;
  const HelperClass({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    required this.paddingWidth,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 768) {
          /// mobil görünüm
          return Container(
            width: size.width,
            alignment: Alignment.center,
            color: bgColor,
            padding: EdgeInsets.symmetric(
              horizontal: paddingWidth,
              vertical: size.height * 0.05,
            ),
            child: mobile,
          );
        } else if (constraints.maxWidth < 1200) {
          /// tablet görünümü
          return Container(
            width: size.width,
            alignment: Alignment.center,
            color: bgColor,
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.1,
              horizontal: paddingWidth,
            ),
            child: tablet,
          );
        } else {
          /// Desktop görünümü
          return Container(
            width: size.width,
            alignment: Alignment.center,
            color: bgColor,
            padding: EdgeInsets.symmetric(
              vertical: size.height * 0.18,
              horizontal: paddingWidth,
            ),
            child: desktop,
          );
        }
      },
    );
  }
}

