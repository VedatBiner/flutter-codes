import 'package:flutter/material.dart';
import '../../../core/extension/widget_extension.dart';

class HomeRightImageChild extends StatelessWidget {
  const HomeRightImageChild({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/home.png",
    ).expanded(4);

    /*
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        image: DecorationImage(
          image: AssetImage("assets/images/home.png"),
        ),
      ),
    ).expanded(4);
*/
    /// ).expanded(4);
  }
}
