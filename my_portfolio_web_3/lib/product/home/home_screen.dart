import 'package:flutter/material.dart';
import 'package:my_portfolio_web_3/core/extension/theme_extension.dart';
import '../../product/home/child/left_text_child.dart';
import '../../product/home/child/right_image_child.dart';
import '../../core/constants/enum/enum.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.colorScheme.background,
      padding: EdgeInsets.only(
        left: GapEnum.L.value,
        right: GapEnum.M.value,
        bottom: GapEnum.M.value,
        top: GapEnum.M.value,
      ),
      child: homeChildren(),
    );
  }

  Row homeChildren() {
    return const Row(
      children: [HomeLetftTextChild(), HomeRightImageChild()],
    );
  }
}
