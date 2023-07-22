import 'package:flutter/material.dart';

import '../../../constants.dart';

class SocialCard extends StatefulWidget {
  const SocialCard({
    super.key,
    required this.iconSrc,
    required this.name,
    required this.color,
    required this.press,
  });

  final String iconSrc, name;
  final Color color;
  final VoidCallback press;

  @override
  State<SocialCard> createState() => _SocialCardState();
}

class _SocialCardState extends State<SocialCard> {
  @override
  bool isHover = false;
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: InkWell(
        onTap: widget.press,
        onHover: (value) {
          setState(() {
            isHover = value;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(
            vertical: kDefaultPadding / 2,
            horizontal: kDefaultPadding * 1.5,
          ),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [if (isHover) kDefaultCardShadow],
          ),
          child: Row(
            children: [
              Image.asset(
                widget.iconSrc,
                width: 80,
                height: 80,
              ),
              const SizedBox(width: kDefaultPadding),
              Text(widget.name),
            ],
          ),

        ),
      ),
    );
  }
}
