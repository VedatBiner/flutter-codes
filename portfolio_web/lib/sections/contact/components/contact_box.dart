

import 'package:flutter/material.dart';
import 'package:portfolio_web/sections/contact/components/social_card.dart';
import '../../../constants.dart';
import '../contact_section.dart';

class ContactBox extends StatelessWidget {
  const ContactBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: kDefaultPadding * 2),
      constraints: const BoxConstraints(maxWidth: 1110),
      padding: const EdgeInsets.all(kDefaultPadding * 3),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SocialCard(
                color: const Color(0xFFD9FFFC),
                iconSrc: "assets/images/skype.png",
                name: "TheFlutterWay",
                press: () {},
              ),
              SocialCard(
                color: const Color(0xFFE4FFC7),
                iconSrc: "assets/images/whatsapp.png",
                name: "TheFlutterWay",
                press: () {},
              ),
              SocialCard(
                color: const Color(0xFFE8F0F9),
                iconSrc: "assets/images/messenger.png",
                name: "TheFlutterWay",
                press: () {},
              ),
            ],
          ),
          const SizedBox(height: kDefaultPadding * 2),
          const ContactForm(),
        ],
      ),
    );
  }
}