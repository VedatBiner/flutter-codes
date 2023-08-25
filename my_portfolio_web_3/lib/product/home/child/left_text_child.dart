import 'package:flutter/material.dart';
import '../../../core/constants/enum/enum.dart';
import '../../../design/text_styles/google_font_styles.dart';
import '../../../core/extension/widget_extension.dart';

class HomeLetftTextChild extends StatelessWidget {
  const HomeLetftTextChild({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          helloText(),
          GapEnum.N.heightBox,
          jobText(),
          GapEnum.N.heightBox,
          detailText(),
          GapEnum.xxL.heightBox,
          aboutButton(),
        ],
      ),
    ).expanded(6);
  }

  ElevatedButton aboutButton() {
    return ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: const StadiumBorder(),
            fixedSize: const Size(250, 60),
          ),
          child: const FittedBox(
            child: Text(
              "More about me ",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        );
  }

  Text detailText() {
    return Text(
      "I'm a web designer with extensive experience for over "
      "10 years My expertise is to create and website design, graphic "
      "design, and many more ...",
      style: GFontStyle().normalStyle.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            color: Colors.grey,
          ),
    );
  }

  Text jobText() {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: "I'm a ",
            style: GFontStyle().normalStyle.copyWith(),
          ),
          const TextSpan(
            text: "Flutter Developer",
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }

  Text helloText() {
    return Text.rich(
      TextSpan(
        style: const TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: "Hello My name is ",
            style: GFontStyle().normalStyle.copyWith(),
          ),
          TextSpan(
            text: "Vedat Biner",
            style: GFontStyle().magicStyle.copyWith(
                  color: Colors.red,
                  fontSize: 40,
                ),
          ),
        ],
      ),
    );
  }
}
