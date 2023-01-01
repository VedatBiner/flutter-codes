import 'package:flutter/material.dart';
import 'constant.dart';

class IconCinsiyet extends StatelessWidget {
  final String cinsiyet;
  final IconData icon;

  const IconCinsiyet({required this.cinsiyet, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 50,
          color: Colors.black54,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          cinsiyet,
          style: kMetinStili,
        )
      ],
    );
  }
}
