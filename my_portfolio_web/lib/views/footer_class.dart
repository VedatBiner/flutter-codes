import 'package:flutter/material.dart';
import 'package:my_portfolio_web/globals/app_colors.dart';

class FooterClass extends StatefulWidget {
  const FooterClass({super.key});

  @override
  State<FooterClass> createState() => _FooterClassState();
}

class _FooterClassState extends State<FooterClass> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: MediaQuery.of(context).size.width,
      color: AppColors.bgColor2,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: InkWell(
        onTap: (){},
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.themeColor,
          ),
          child: const Icon(
            Icons.arrow_upward,
            size: 25,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
