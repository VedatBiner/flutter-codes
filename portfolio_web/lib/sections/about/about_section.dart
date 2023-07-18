import 'package:flutter/material.dart';
import 'package:portfolio_web/constants.dart';
import '../../components/default_button.dart';
import '../../components/my_outline_button.dart';
import 'components/about_section_text.dart';
import 'components/about_text_with_sign.dart';
import 'components/experience_card.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding * 2),
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AboutTextWithSign(),
              Expanded(
                child: AboutSectionText(
                  text:
                      "Lorem ipsum dolor sit amet, consectetur adipisicing elit, "
                      "sed do eiusmod tempor incididunt ut labore et dolore mag aliqua. "
                      "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris "
                      "nisi ut aliquip ex ea commodo consequat.",
                ),
              ),
              ExperienceCard(
                numOfExp: "08",
              ),
              Expanded(
                child: AboutSectionText(
                  text:
                      "Lorem ipsum dolor sit amet, consectetur adipisicing elit, "
                      "sed do eiusmod tempor incididunt ut labore et dolore mag aliqua. "
                      "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris "
                      "nisi ut aliquip ex ea commodo consequat.",
                ),
              ),
            ],
          ),
          const SizedBox(height: kDefaultPadding * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyOutlineButton(
                imageSrc: "assets/images/hand.png",
                text: "Hire Me!",
                press: () {},
              ),
              const SizedBox(width: kDefaultPadding * 1.5),
              DefaultButton(
                imageSrc: "assets/images/download.png",
                text: "Download CV",
                press: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
