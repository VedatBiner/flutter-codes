import 'package:flutter/material.dart';
import '../../core/constants/enum/enum.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: GapEnum.L.value,
        right: GapEnum.M.value,
        bottom: GapEnum.M.value,
        top: GapEnum.M.value,
      ),
      color: Colors.white,
    );
  }
}
