import 'package:flutter/material.dart';
import 'package:social_media_buttons/social_media_button.dart';

class SMButton extends StatelessWidget {
  const SMButton({
    super.key,
    required this.socialMedia,
    required this.color,
    required this.iconData,
  });

  final String socialMedia;
  final Color color;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return SocialMediaButton(
      size: 30,
      color: color,
      url: socialMedia,
      iconData: iconData,
    );
  }
}
