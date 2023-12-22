import 'package:flutter/material.dart';

class SayfaKiril extends StatefulWidget {
  const SayfaKiril({Key? key}) : super(key: key);

  @override
  State<SayfaKiril> createState() => _SayfaKirilState();
}

class _SayfaKirilState extends State<SayfaKiril> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Kiril Alfabesi",
        style: TextStyle(
          color: Colors.black54,
          fontSize: 36,
        ),
      ),
    );
  }
}