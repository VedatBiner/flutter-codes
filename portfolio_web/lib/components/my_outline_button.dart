import 'package:flutter/material.dart';
import '../constants.dart';

class MyOutlineButton extends StatelessWidget {
  const MyOutlineButton({
    super.key,
    required this.imageSrc,
    required this.text,
    required this.press,
  });

  final String imageSrc, text;
  final Function press;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: OutlinedButton( /// OutlinedButton
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            vertical: kDefaultPadding,
            horizontal: kDefaultPadding * 2.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          side: const BorderSide(color: Color(0xFFEDEDED)),
        ),
        onPressed: (){} /*press*/,
        child: Row(
          children: [
            Image.asset(
              imageSrc,
              height: 40,
            ),
            const SizedBox(width: kDefaultPadding),
            Text(text),
          ],
        ),
      ),
    );
  }
}
